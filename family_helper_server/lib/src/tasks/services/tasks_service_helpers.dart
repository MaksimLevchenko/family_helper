part of 'tasks_service.dart';

Future<TaskDto> _findTask(
  TasksService service,
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
  TasksService service,
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
  TasksService service,
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
      createdAt: service.clock.nowUtc(),
    ),
    transaction: transaction,
  );
}

Future<void> _notifyTaskAssignmentIfNeeded(
  TasksService service,
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

  await service.appNotifications.createForProfiles(
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
  TasksService service,
  Session session, {
  required int actorProfileId,
  required TaskDto task,
  Transaction? transaction,
}) async {
  await service.appNotifications.createForFamilyMembers(
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
      dueOffsetValue:
          dueOffsetValue != null && dueOffsetValue > 0 ? dueOffsetValue : null,
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
