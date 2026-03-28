part of 'tasks_service.dart';

Future<TaskDto> _upsertTaskImpl(
  TasksService service,
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
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'tasks.upsertTask',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    if (!isFresh && taskId != null) {
      return _findTask(service, session, taskId, transaction: transaction);
    }
    if (!isFresh) {
      final binding = await service.idempotency.getBinding(
        session,
        actorAuthUserId: authUserId,
        action: 'tasks.upsertTask',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (binding?.resourceType == 'task') {
        return _findTask(
          service,
          session,
          binding!.resourceId,
          transaction: transaction,
        );
      }
    }

    final now = service.clock.nowUtc();
    await _validateAssignee(
      service,
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
      await service.idempotency.bindResource(
        session,
        actorAuthUserId: authUserId,
        action: 'tasks.upsertTask',
        clientOperationId: clientOperationId,
        resourceType: 'task',
        resourceId: dto.id,
        transaction: transaction,
      );
      await _appendHistory(
        service,
        session,
        taskId: dto.id,
        actorProfileId: actorProfileId,
        eventType: 'created',
        details: 'Task created',
        transaction: transaction,
      );

      await service.changeFeed.appendChange(
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

      await service.realtime.publish(
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
        service,
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
      service,
      session,
      taskId,
      transaction: transaction,
    );

    await _appendHistory(
      service,
      session,
      taskId: updated.id,
      actorProfileId: actorProfileId,
      eventType: 'updated',
      details: 'Task updated',
      transaction: transaction,
    );

    await service.changeFeed.appendChange(
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

    await service.realtime.publish(
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
      service,
      session,
      actorProfileId: actorProfileId,
      previousAssigneeProfileId: row.assigneeProfileId,
      task: updated,
      transaction: transaction,
    );

    return updated;
  });
}

Future<List<TaskDto>> _listTasksImpl(
  TasksService service,
  Session session, {
  required int familyId,
}) async {
  final profileId = await service.rbac.ensureFamilyRole(
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

Future<List<TaskHistoryEntryDto>> _listTaskHistoryImpl(
  TasksService service,
  Session session, {
  required int familyId,
  required int taskId,
  int limit = 50,
}) async {
  final profileId = await service.rbac.ensureFamilyRole(
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

Future<TaskDto> _completeTaskImpl(
  TasksService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required int taskId,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
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

    final now = service.clock.nowUtc();
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
      service,
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
              service,
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

    await service.changeFeed.appendChange(
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

    await service.realtime.publish(
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
      service,
      session,
      actorProfileId: actorProfileId,
      task: current,
      transaction: transaction,
    );

    return _findTask(service, session, taskId, transaction: transaction);
  });
}

Future<OperationResult> _deleteTaskImpl(
  TasksService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required int taskId,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
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

    final now = service.clock.nowUtc();
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
      service,
      session,
      taskId: taskId,
      actorProfileId: actorProfileId,
      eventType: 'deleted',
      details: 'Task deleted',
      transaction: transaction,
    );

    await service.changeFeed.appendChange(
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

    await service.realtime.publish(
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
