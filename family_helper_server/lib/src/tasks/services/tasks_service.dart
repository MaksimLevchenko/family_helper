import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class TasksService {
  TasksService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;

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

      final now = DateTime.now().toUtc();
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
            dueAt: dueAt?.toUtc(),
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

        return dto;
      }

      final row = await TaskRow.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(taskId) &
            t.familyId.equals(familyId) &
            t.deletedAt.equals(null),
        transaction: transaction,
      );
      if (row == null) throw Exception('Task not found');
      await TaskRow.db.updateRow(
        session,
        row.copyWith(
          title: title,
          description: description,
          isPersonal: isPersonal,
          priority: priority,
          dueAt: dueAt?.toUtc(),
          recurrenceMode: recurrenceMode,
          recurrenceRrule: recurrenceRrule,
          assigneeProfileId: assigneeProfileId,
          updatedAt: now,
          version: row.version + 1,
        ),
        transaction: transaction,
      );

      final updated = await _findTask(session, taskId, transaction: transaction);

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

      final currentRow = await TaskRow.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(taskId) &
            t.familyId.equals(familyId) &
            t.deletedAt.equals(null),
        transaction: transaction,
      );
      if (currentRow == null) {
        throw Exception('Task not found');
      }

      final current = _mapTask(currentRow);
      if (!isFresh || current.status == 'completed') {
        return current;
      }

      final now = DateTime.now().toUtc();
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
            await TaskRow.db.insertRow(
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

      return _findTask(session, taskId, transaction: transaction);
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
        createdAt: DateTime.now().toUtc(),
      ),
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
      recurrenceMode: row.recurrenceMode,
      recurrenceRrule: row.recurrenceRrule,
      assigneeProfileId: row.assigneeProfileId,
      completedAt: row.completedAt,
      updatedAt: row.updatedAt,
      version: row.version,
    );
  }
}


