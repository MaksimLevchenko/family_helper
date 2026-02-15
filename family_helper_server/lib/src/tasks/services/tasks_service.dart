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
        final inserted = await session.db.unsafeQuery(
          '''
          INSERT INTO task (
            family_id,
            title,
            description,
            is_personal,
            priority,
            status,
            due_at,
            recurrence_mode,
            recurrence_rrule,
            assignee_profile_id,
            created_by_profile_id,
            completed_at,
            source_task_id,
            created_at,
            updated_at,
            deleted_at,
            version
          ) VALUES (
            @familyId,
            @title,
            @description,
            @isPersonal,
            @priority,
            'open',
            @dueAt,
            @recurrenceMode,
            @recurrenceRrule,
            @assignee,
            @createdBy,
            NULL,
            NULL,
            @now,
            @now,
            NULL,
            1
          )
          RETURNING
            id,
            family_id,
            title,
            description,
            is_personal,
            priority,
            status,
            due_at,
            recurrence_mode,
            recurrence_rrule,
            assignee_profile_id,
            completed_at,
            updated_at,
            version
          ''',
          parameters: QueryParameters.named({
            'familyId': familyId,
            'title': title,
            'description': description,
            'isPersonal': isPersonal,
            'priority': priority,
            'dueAt': dueAt?.toUtc(),
            'recurrenceMode': recurrenceMode,
            'recurrenceRrule': recurrenceRrule,
            'assignee': assigneeProfileId,
            'createdBy': actorProfileId,
            'now': now,
          }),
          transaction: transaction,
        );

        final dto = _mapTask(inserted.first.toColumnMap());
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

      await session.db.unsafeExecute(
        '''
        UPDATE task
        SET
          title = @title,
          description = @description,
          is_personal = @isPersonal,
          priority = @priority,
          due_at = @dueAt,
          recurrence_mode = @recurrenceMode,
          recurrence_rrule = @recurrenceRrule,
          assignee_profile_id = @assignee,
          updated_at = @updatedAt,
          version = version + 1
        WHERE id = @id
          AND family_id = @familyId
          AND deleted_at IS NULL
        ''',
        parameters: QueryParameters.named({
          'id': taskId,
          'familyId': familyId,
          'title': title,
          'description': description,
          'isPersonal': isPersonal,
          'priority': priority,
          'dueAt': dueAt?.toUtc(),
          'recurrenceMode': recurrenceMode,
          'recurrenceRrule': recurrenceRrule,
          'assignee': assigneeProfileId,
          'updatedAt': now,
        }),
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

    final rows = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        title,
        description,
        is_personal,
        priority,
        status,
        due_at,
        recurrence_mode,
        recurrence_rrule,
        assignee_profile_id,
        completed_at,
        updated_at,
        version
      FROM task
      WHERE family_id = @familyId
        AND deleted_at IS NULL
        AND (is_personal = false OR created_by_profile_id = @profileId)
      ORDER BY id DESC
      ''',
      parameters: QueryParameters.named({
        'familyId': familyId,
        'profileId': profileId,
      }),
    );

    return rows.map((row) => _mapTask(row.toColumnMap())).toList();
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

      final lockedRows = await session.db.unsafeQuery(
        '''
        SELECT
          id,
          family_id,
          title,
          description,
          is_personal,
          priority,
          status,
          due_at,
          recurrence_mode,
          recurrence_rrule,
          assignee_profile_id,
          completed_at,
          updated_at,
          version
        FROM task
        WHERE id = @id
          AND family_id = @familyId
          AND deleted_at IS NULL
        FOR UPDATE
        ''',
        parameters: QueryParameters.named({'id': taskId, 'familyId': familyId}),
        transaction: transaction,
      );
      if (lockedRows.isEmpty) {
        throw Exception('Task not found');
      }

      final current = _mapTask(lockedRows.first.toColumnMap());
      if (!isFresh || current.status == 'completed') {
        return current;
      }

      final now = DateTime.now().toUtc();
      await session.db.unsafeExecute(
        '''
        UPDATE task
        SET status = 'completed',
            completed_at = @now,
            updated_at = @now,
            version = version + 1
        WHERE id = @id
        ''',
        parameters: QueryParameters.named({'id': taskId, 'now': now}),
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
          await session.db.unsafeExecute(
            '''
            INSERT INTO task (
              family_id,
              title,
              description,
              is_personal,
              priority,
              status,
              due_at,
              recurrence_mode,
              recurrence_rrule,
              assignee_profile_id,
              created_by_profile_id,
              completed_at,
              source_task_id,
              created_at,
              updated_at,
              deleted_at,
              version
            ) VALUES (
              @familyId,
              @title,
              @description,
              @isPersonal,
              @priority,
              'open',
              @dueAt,
              @recurrenceMode,
              @recurrenceRrule,
              @assignee,
              @createdBy,
              NULL,
              @sourceTaskId,
              @now,
              @now,
              NULL,
              1
            )
            ON CONFLICT ON CONSTRAINT task_unique_generated_next
            DO NOTHING
            ''',
            parameters: QueryParameters.named({
              'familyId': current.familyId,
              'title': current.title,
              'description': current.description,
              'isPersonal': current.isPersonal,
              'priority': current.priority,
              'dueAt': nextDueAt,
              'recurrenceMode': current.recurrenceMode,
              'recurrenceRrule': current.recurrenceRrule,
              'assignee': current.assigneeProfileId,
              'createdBy': actorProfileId,
              'sourceTaskId': current.id,
              'now': now,
            }),
            transaction: transaction,
          );
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
    final rows = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        title,
        description,
        is_personal,
        priority,
        status,
        due_at,
        recurrence_mode,
        recurrence_rrule,
        assignee_profile_id,
        completed_at,
        updated_at,
        version
      FROM task
      WHERE id = @id
      LIMIT 1
      ''',
      parameters: QueryParameters.named({'id': taskId}),
      transaction: transaction,
    );

    return _mapTask(rows.first.toColumnMap());
  }

  Future<void> _appendHistory(
    Session session, {
    required int taskId,
    required int actorProfileId,
    required String eventType,
    required String details,
    Transaction? transaction,
  }) async {
    await session.db.unsafeExecute(
      '''
      INSERT INTO task_history (
        task_id,
        actor_profile_id,
        event_type,
        details,
        created_at
      ) VALUES (
        @taskId,
        @actor,
        @eventType,
        @details,
        @createdAt
      )
      ''',
      parameters: QueryParameters.named({
        'taskId': taskId,
        'actor': actorProfileId,
        'eventType': eventType,
        'details': details,
        'createdAt': DateTime.now().toUtc(),
      }),
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

  TaskDto _mapTask(Map<String, dynamic> row) {
    return TaskDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int,
      title: row['title'] as String,
      description: row['description'] as String?,
      isPersonal: row['is_personal'] as bool,
      priority: row['priority'] as String,
      status: row['status'] as String,
      dueAt: row['due_at'] as DateTime?,
      recurrenceMode: row['recurrence_mode'] as String?,
      recurrenceRrule: row['recurrence_rrule'] as String?,
      assigneeProfileId: row['assignee_profile_id'] as int?,
      completedAt: row['completed_at'] as DateTime?,
      updatedAt: row['updated_at'] as DateTime,
      version: row['version'] as int,
    );
  }
}
