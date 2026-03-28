import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';
import '../../notifications/services/app_notification_service.dart';

class TasksService {
  TasksService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
    AppNotificationService? appNotifications,
  }) : appNotifications = appNotifications ?? AppNotificationService();

  final AuthContext authContext;
  final ClockService clock;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;
  final AppNotificationService appNotifications;

  Future<TaskDto> upsertTask(
    Session session, {
    required String clientOperationId,
    int? taskId,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    String priority = 'normal',
    DateTime? dueAt,
    String? dueInputMode,
    int? dueOffsetValue,
    String? dueOffsetUnit,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'tasks.upsertTask',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh && taskId != null) {
        return _findTask(session, taskId, transaction: transaction);
      }
      if (!isFresh) {
        final binding = await idempotency.getBinding(
          session,
          actorAuthUserId: authUserId,
          action: 'tasks.upsertTask',
          clientOperationId: clientOperationId,
          transaction: transaction,
        );
        if (binding?.resourceType == 'task') {
          return _findTask(
            session,
            binding!.resourceId,
            transaction: transaction,
          );
        }
      }

      final now = clock.nowUtc();
      await _validateAssignee(
        session,
        familyId: familyId,
        actorProfileId: actorProfileId,
        isPersonal: isPersonal,
        assigneeProfileId: assigneeProfileId,
        transaction: transaction,
      );
      final normalizedDeadline = _normalizeDeadline(
        dueAt: dueAt,
        dueInputMode: dueInputMode,
        dueOffsetValue: dueOffsetValue,
        dueOffsetUnit: dueOffsetUnit,
      );
      if (taskId == null) {
        final inserted = await TaskRow.db.insertRow(
          session,
          TaskRow(
            familyId: familyId,
            title: title,
            description: description,
            isPersonal: isPersonal,
            priority: priority,
            status: 'open',
            dueAt: normalizedDeadline.dueAt,
            dueInputMode: normalizedDeadline.dueInputMode,
            dueOffsetValue: normalizedDeadline.dueOffsetValue,
            dueOffsetUnit: normalizedDeadline.dueOffsetUnit,
            recurrenceMode: recurrenceMode,
            recurrenceRrule: recurrenceRrule,
            assigneeProfileId: assigneeProfileId,
            createdByProfileId: actorProfileId,
            completedAt: null,
            sourceTaskId: null,
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
            version: 1,
          ),
          transaction: transaction,
        );

        final dto = _mapTask(inserted);
        await idempotency.bindResource(
          session,
          actorAuthUserId: authUserId,
          action: 'tasks.upsertTask',
          clientOperationId: clientOperationId,
          resourceType: 'task',
          resourceId: dto.id,
          transaction: transaction,
        );
        await _appendHistory(
          session,
          taskId: dto.id,
          actorProfileId: actorProfileId,
          eventType: 'created',
          details: 'Task created',
          transaction: transaction,
        );

        await changeFeed.appendChange(
          session,
          feature: 'tasks',
          entityType: 'task',
          entityId: dto.id,
          operation: 'upserted',
          familyId: familyId,
          version: dto.version,
          payload: {'title': dto.title},
          transaction: transaction,
        );

        await realtime.publish(
          session,
          familyId: familyId,
          event: FamilyRealtimeEvent(
            familyId: familyId,
            feature: 'tasks',
            entityType: 'task',
            entityId: dto.id,
            eventType: 'tasks.updated',
            changedAt: now,
          ),
        );

        await _notifyTaskAssignmentIfNeeded(
          session,
          actorProfileId: actorProfileId,
          previousAssigneeProfileId: null,
          task: dto,
          transaction: transaction,
        );

        return dto;
      }

      final row = await _findVisibleTaskRow(
        session,
        familyId: familyId,
        taskId: taskId,
        viewerProfileId: actorProfileId,
        transaction: transaction,
      );
      if (row == null) {
        throw FileNotFoundException(message: 'Task not found.');
      }
      await TaskRow.db.updateRow(
        session,
        row.copyWith(
          title: title,
          description: description,
          isPersonal: isPersonal,
          priority: priority,
          dueAt: normalizedDeadline.dueAt,
          dueInputMode: normalizedDeadline.dueInputMode,
          dueOffsetValue: normalizedDeadline.dueOffsetValue,
          dueOffsetUnit: normalizedDeadline.dueOffsetUnit,
          recurrenceMode: recurrenceMode,
          recurrenceRrule: recurrenceRrule,
          assigneeProfileId: assigneeProfileId,
          updatedAt: now,
          version: row.version + 1,
        ),
        transaction: transaction,
      );

      final updated = await _findTask(
        session,
        taskId,
        transaction: transaction,
      );

      await _appendHistory(
        session,
        taskId: updated.id,
        actorProfileId: actorProfileId,
        eventType: 'updated',
        details: 'Task updated',
        transaction: transaction,
      );

      await changeFeed.appendChange(
        session,
        feature: 'tasks',
        entityType: 'task',
        entityId: updated.id,
        operation: 'upserted',
        familyId: familyId,
        version: updated.version,
        payload: {'title': updated.title},
        transaction: transaction,
      );

      await realtime.publish(
        session,
        familyId: familyId,
        event: FamilyRealtimeEvent(
          familyId: familyId,
          feature: 'tasks',
          entityType: 'task',
          entityId: updated.id,
          eventType: 'tasks.updated',
          changedAt: now,
        ),
      );

      await _notifyTaskAssignmentIfNeeded(
        session,
        actorProfileId: actorProfileId,
        previousAssigneeProfileId: row.assigneeProfileId,
        task: updated,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<List<TaskDto>> listTasks(
    Session session, {
    required int familyId,
  }) async {
    final profileId = await rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
    );

    final rows = await TaskRow.db.find(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          t.deletedAt.equals(null) &
          (t.isPersonal.equals(false) | t.createdByProfileId.equals(profileId)),
      orderBy: (t) => t.id,
      orderDescending: true,
    );

    return rows.map(_mapTask).toList();
  }

  Future<List<TaskHistoryEntryDto>> listTaskHistory(
    Session session, {
    required int familyId,
    required int taskId,
    int limit = 50,
  }) async {
    final profileId = await rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
    );

    final task = await _findVisibleTaskRow(
      session,
      familyId: familyId,
      taskId: taskId,
      viewerProfileId: profileId,
    );
    if (task == null) {
      throw FileNotFoundException(message: 'Task not found.');
    }

    final normalizedLimit = limit <= 0 ? 1 : (limit > 100 ? 100 : limit);
    final rows = await TaskHistoryRow.db.find(
      session,
      where: (t) => t.taskId.equals(taskId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: normalizedLimit,
    );
    final actorProfileIds = rows.map((row) => row.actorProfileId).toSet();
    final profiles = actorProfileIds.isEmpty
        ? <AppProfileRow>[]
        : await AppProfileRow.db.find(
            session,
            where: (t) => t.id.inSet(actorProfileIds),
          );
    final profilesById = {for (final profile in profiles) profile.id!: profile};

    return rows
        .map(
          (row) => TaskHistoryEntryDto(
            id: row.id!,
            taskId: row.taskId,
            profileId: row.actorProfileId,
            actorDisplayName:
                profilesById[row.actorProfileId]?.displayName ??
                'User #${row.actorProfileId}',
            eventType: row.eventType,
            details: row.details ?? '',
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  Future<TaskDto> completeTask(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'tasks.completeTask',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      await session.db.unsafeQuery(
        'SELECT "id" FROM "task" WHERE "id" = @taskId AND "familyId" = @familyId AND "deletedAt" IS NULL FOR UPDATE',
        transaction: transaction,
        parameters: QueryParameters.named({
          'taskId': taskId,
          'familyId': familyId,
        }),
      );
      final currentRow = await _findVisibleTaskRow(
        session,
        familyId: familyId,
        taskId: taskId,
        viewerProfileId: actorProfileId,
        transaction: transaction,
      );
      if (currentRow == null) {
        throw FileNotFoundException(message: 'Task not found.');
      }

      final current = _mapTask(currentRow);
      if (!isFresh || current.status == 'completed') {
        return current;
      }

      final now = clock.nowUtc();
      await TaskRow.db.updateRow(
        session,
        currentRow.copyWith(
          status: 'completed',
          completedAt: now,
          updatedAt: now,
          version: currentRow.version + 1,
        ),
        transaction: transaction,
      );

      await _appendHistory(
        session,
        taskId: taskId,
        actorProfileId: actorProfileId,
        eventType: 'completed',
        details: 'Task completed',
        transaction: transaction,
      );

      if (current.recurrenceMode == 'generateOnComplete' &&
          current.recurrenceRrule != null) {
        final nextDueAt = _nextDue(current.dueAt, current.recurrenceRrule!);
        if (nextDueAt != null) {
          final existingNext = await TaskRow.db.findFirstRow(
            session,
            where: (t) =>
                t.sourceTaskId.equals(current.id) &
                t.dueAt.equals(nextDueAt) &
                t.deletedAt.equals(null),
            transaction: transaction,
          );
          if (existingNext == null) {
            try {
              final nextTask = await TaskRow.db.insertRow(
                session,
                TaskRow(
                  familyId: current.familyId,
                  title: current.title,
                  description: current.description,
                  isPersonal: current.isPersonal,
                  priority: current.priority,
                  status: 'open',
                  dueAt: nextDueAt,
                  recurrenceMode: current.recurrenceMode,
                  recurrenceRrule: current.recurrenceRrule,
                  assigneeProfileId: current.assigneeProfileId,
                  createdByProfileId: actorProfileId,
                  completedAt: null,
                  sourceTaskId: current.id,
                  createdAt: now,
                  updatedAt: now,
                  deletedAt: null,
                  version: 1,
                ),
                transaction: transaction,
              );
              await _appendHistory(
                session,
                taskId: nextTask.id!,
                actorProfileId: actorProfileId,
                eventType: 'created',
                details: 'Task created from recurrence',
                transaction: transaction,
              );
            } on DatabaseInsertRowException {
              // A concurrent completion already created the follow-up task.
            } on DatabaseQueryException catch (error) {
              if (error.code != '23505') {
                rethrow;
              }
              // A concurrent completion already created the follow-up task.
            }
          }
        }
      }

      await changeFeed.appendChange(
        session,
        feature: 'tasks',
        entityType: 'task',
        entityId: taskId,
        operation: 'completed',
        familyId: familyId,
        version: current.version + 1,
        payload: {'status': 'completed'},
        transaction: transaction,
      );

      await realtime.publish(
        session,
        familyId: familyId,
        event: FamilyRealtimeEvent(
          familyId: familyId,
          feature: 'tasks',
          entityType: 'task',
          entityId: taskId,
          eventType: 'tasks.updated',
          changedAt: now,
        ),
      );

      await _notifyTaskCompleted(
        session,
        actorProfileId: actorProfileId,
        task: current,
        transaction: transaction,
      );

      return _findTask(session, taskId, transaction: transaction);
    });
  }

  Future<OperationResult> deleteTask(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'tasks.deleteTask',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (!isFresh) {
        return OperationResult(success: true, message: 'Already deleted');
      }

      await session.db.unsafeQuery(
        'SELECT "id" FROM "task" WHERE "id" = @taskId AND "familyId" = @familyId AND "deletedAt" IS NULL FOR UPDATE',
        transaction: transaction,
        parameters: QueryParameters.named({
          'taskId': taskId,
          'familyId': familyId,
        }),
      );

      final row = await _findVisibleTaskRow(
        session,
        familyId: familyId,
        taskId: taskId,
        viewerProfileId: actorProfileId,
        transaction: transaction,
      );
      if (row == null) {
        return OperationResult(success: true, message: 'Already deleted');
      }

      final now = clock.nowUtc();
      final nextVersion = row.version + 1;
      await TaskRow.db.updateRow(
        session,
        row.copyWith(
          deletedAt: now,
          updatedAt: now,
          version: nextVersion,
        ),
        transaction: transaction,
      );

      await _appendHistory(
        session,
        taskId: taskId,
        actorProfileId: actorProfileId,
        eventType: 'deleted',
        details: 'Task deleted',
        transaction: transaction,
      );

      await changeFeed.appendChange(
        session,
        feature: 'tasks',
        entityType: 'task',
        entityId: taskId,
        operation: 'deleted',
        familyId: familyId,
        version: nextVersion,
        payload: {'title': row.title},
        transaction: transaction,
      );

      await realtime.publish(
        session,
        familyId: familyId,
        event: FamilyRealtimeEvent(
          familyId: familyId,
          feature: 'tasks',
          entityType: 'task',
          entityId: taskId,
          eventType: 'tasks.updated',
          changedAt: now,
        ),
      );

      return OperationResult(success: true, message: 'Task deleted');
    });
  }

  Future<TaskDto> _findTask(
    Session session,
    int taskId, {
    Transaction? transaction,
  }) async {
    final row = await TaskRow.db.findById(
      session,
      taskId,
      transaction: transaction,
    );
    return _mapTask(row!);
  }

  Future<TaskRow?> _findVisibleTaskRow(
    Session session, {
    required int familyId,
    required int taskId,
    required int viewerProfileId,
    Transaction? transaction,
  }) {
    return TaskRow.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(taskId) &
          t.familyId.equals(familyId) &
          t.deletedAt.equals(null) &
          (t.isPersonal.equals(false) |
              t.createdByProfileId.equals(viewerProfileId)),
      transaction: transaction,
    );
  }

  Future<void> _validateAssignee(
    Session session, {
    required int familyId,
    required int actorProfileId,
    required bool isPersonal,
    required int? assigneeProfileId,
    Transaction? transaction,
  }) async {
    if (assigneeProfileId == null) {
      return;
    }

    if (isPersonal && assigneeProfileId != actorProfileId) {
      throw ArgumentError.value(
        assigneeProfileId,
        'assigneeProfileId',
        'Personal tasks cannot be assigned to another family member.',
      );
    }

    final member = await FamilyMemberRow.db.findFirstRow(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          t.profileId.equals(assigneeProfileId) &
          t.status.equals('active') &
          t.deletedAt.equals(null),
      transaction: transaction,
    );
    if (member == null) {
      throw ArgumentError.value(
        assigneeProfileId,
        'assigneeProfileId',
        'Assignee must be an active family member.',
      );
    }
  }

  Future<void> _appendHistory(
    Session session, {
    required int taskId,
    required int actorProfileId,
    required String eventType,
    required String details,
    Transaction? transaction,
  }) async {
    await TaskHistoryRow.db.insertRow(
      session,
      TaskHistoryRow(
        taskId: taskId,
        actorProfileId: actorProfileId,
        eventType: eventType,
        details: details,
        createdAt: clock.nowUtc(),
      ),
      transaction: transaction,
    );
  }

  Future<void> _notifyTaskAssignmentIfNeeded(
    Session session, {
    required int actorProfileId,
    required int? previousAssigneeProfileId,
    required TaskDto task,
    Transaction? transaction,
  }) async {
    final assigneeProfileId = task.assigneeProfileId;
    if (assigneeProfileId == null ||
        assigneeProfileId == actorProfileId ||
        assigneeProfileId == previousAssigneeProfileId) {
      return;
    }

    await appNotifications.createForProfiles(
      session,
      profileIds: [assigneeProfileId],
      familyId: task.familyId,
      category: 'task_assigned',
      title: 'Task assigned',
      body: task.title,
      entityType: 'task',
      entityId: task.id,
      route: '/home/tasks',
      payload: {
        'category': 'task_assigned',
        'familyId': task.familyId,
        'taskId': task.id,
      },
      transaction: transaction,
    );
  }

  Future<void> _notifyTaskCompleted(
    Session session, {
    required int actorProfileId,
    required TaskDto task,
    Transaction? transaction,
  }) async {
    await appNotifications.createForFamilyMembers(
      session,
      familyId: task.familyId,
      category: 'task_completed',
      title: 'Task completed',
      body: task.title,
      entityType: 'task',
      entityId: task.id,
      route: '/home/tasks',
      payload: {
        'category': 'task_completed',
        'familyId': task.familyId,
        'taskId': task.id,
      },
      transaction: transaction,
    );
  }

  DateTime? _nextDue(DateTime? base, String rrule) {
    if (base == null) {
      return null;
    }

    final upper = rrule.toUpperCase();
    int interval = 1;
    for (final part in upper.split(';')) {
      final kv = part.split('=');
      if (kv.length == 2 && kv[0] == 'INTERVAL') {
        interval = int.tryParse(kv[1]) ?? 1;
      }
    }

    if (upper.contains('FREQ=WEEKLY')) {
      return base.add(Duration(days: 7 * interval));
    }
    if (upper.contains('FREQ=MONTHLY')) {
      return DateTime.utc(
        base.year,
        base.month + interval,
        base.day,
        base.hour,
        base.minute,
        base.second,
      );
    }
    if (upper.contains('FREQ=YEARLY')) {
      return DateTime.utc(
        base.year + interval,
        base.month,
        base.day,
        base.hour,
        base.minute,
        base.second,
      );
    }

    return base.add(Duration(days: interval));
  }

  TaskDto _mapTask(TaskRow row) {
    return TaskDto(
      id: row.id!,
      familyId: row.familyId,
      title: row.title,
      description: row.description,
      isPersonal: row.isPersonal,
      priority: row.priority,
      status: row.status,
      dueAt: row.dueAt,
      dueInputMode: row.dueInputMode,
      dueOffsetValue: row.dueOffsetValue,
      dueOffsetUnit: row.dueOffsetUnit,
      recurrenceMode: row.recurrenceMode,
      recurrenceRrule: row.recurrenceRrule,
      assigneeProfileId: row.assigneeProfileId,
      completedAt: row.completedAt,
      updatedAt: row.updatedAt,
      version: row.version,
    );
  }
}

class _NormalizedTaskDeadline {
  const _NormalizedTaskDeadline({
    required this.dueAt,
    required this.dueInputMode,
    required this.dueOffsetValue,
    required this.dueOffsetUnit,
  });

  final DateTime? dueAt;
  final String? dueInputMode;
  final int? dueOffsetValue;
  final String? dueOffsetUnit;
}

_NormalizedTaskDeadline _normalizeDeadline({
  required DateTime? dueAt,
  required String? dueInputMode,
  required int? dueOffsetValue,
  required String? dueOffsetUnit,
}) {
  final mode = dueInputMode?.trim();
  return switch (mode) {
    'none' => const _NormalizedTaskDeadline(
      dueAt: null,
      dueInputMode: 'none',
      dueOffsetValue: null,
      dueOffsetUnit: null,
    ),
    'relative' => _NormalizedTaskDeadline(
      dueAt: dueAt?.toUtc(),
      dueInputMode: 'relative',
      dueOffsetValue: dueOffsetValue != null && dueOffsetValue > 0
          ? dueOffsetValue
          : null,
      dueOffsetUnit: dueOffsetUnit,
    ),
    'absolute' => _NormalizedTaskDeadline(
      dueAt: dueAt?.toUtc(),
      dueInputMode: 'absolute',
      dueOffsetValue: null,
      dueOffsetUnit: null,
    ),
    _ => _NormalizedTaskDeadline(
      dueAt: dueAt?.toUtc(),
      dueInputMode: dueAt == null ? 'none' : null,
      dueOffsetValue: null,
      dueOffsetUnit: null,
    ),
  };
}
