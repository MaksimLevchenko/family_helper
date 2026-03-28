part of 'notifications_service.dart';

Future<PushTokenRow?> _findPushTokenRow(
  Session session, {
  required int profileId,
  required String token,
  Transaction? transaction,
}) {
  return PushTokenRow.db.findFirstRow(
    session,
    where: (t) => t.profileId.equals(profileId) & t.token.equals(token),
    transaction: transaction,
  );
}

Future<void> _refreshExistingPushToken(
  Session session, {
  required int profileId,
  required String token,
  required String platform,
  String? provider,
  String? deviceId,
  String? appVersion,
  required DateTime now,
  Transaction? transaction,
}) async {
  final concurrent = await _findPushTokenRow(
    session,
    profileId: profileId,
    token: token,
    transaction: transaction,
  );
  if (concurrent == null) {
    throw StateError(
      'Push token row for profileId=$profileId token=$token was inserted concurrently but could not be loaded.',
    );
  }
  await _updatePushTokenRow(
    session,
    existing: concurrent,
    platform: platform,
    provider: provider,
    deviceId: deviceId,
    appVersion: appVersion,
    now: now,
    transaction: transaction,
  );
}

Future<void> _deactivateTokenForOtherProfiles(
  Session session, {
  required int profileId,
  required String token,
  required DateTime now,
  Transaction? transaction,
}) async {
  final duplicates = await PushTokenRow.db.find(
    session,
    where: (t) =>
        t.token.equals(token) &
        t.profileId.notEquals(profileId) &
        t.deletedAt.equals(null),
    transaction: transaction,
  );
  for (final duplicate in buildDeactivatedDuplicatePushTokens(
    tokens: duplicates,
    profileId: profileId,
    token: token,
    now: now,
  )) {
    await PushTokenRow.db.updateRow(
      session,
      duplicate,
      transaction: transaction,
    );
  }
}

Future<void> _updatePushTokenRow(
  Session session, {
  required PushTokenRow existing,
  required String platform,
  String? provider,
  String? deviceId,
  String? appVersion,
  required DateTime now,
  Transaction? transaction,
}) {
  return PushTokenRow.db.updateRow(
    session,
    existing.copyWith(
      platform: platform,
      provider: provider ?? existing.provider,
      deviceId: deviceId ?? existing.deviceId,
      appVersion: appVersion ?? existing.appVersion,
      updatedAt: now,
      lastSeenAt: now,
      lastErrorAt: null,
      deletedAt: null,
      disabledAt: null,
      version: existing.version + 1,
    ),
    transaction: transaction,
  );
}

Future<ReminderDto?> _findScheduledReminderForEntity(
  Session session, {
  required int familyId,
  required int profileId,
  required String entityType,
  required int entityId,
  Transaction? transaction,
}) async {
  final row = await ReminderRow.db.findFirstRow(
    session,
    where: (t) =>
        t.familyId.equals(familyId) &
        t.profileId.equals(profileId) &
        t.entityType.equals(entityType) &
        t.entityId.equals(entityId) &
        t.status.equals('scheduled'),
    orderBy: (t) => t.remindAt,
    orderDescending: true,
    transaction: transaction,
  );
  return row == null ? null : _mapReminder(row);
}

Future<void> _createReminderNotification(
  NotificationsService service,
  Session session, {
  required ReminderDto reminder,
  required DateTime firedAt,
}) async {
  final payload = _decodePayload(reminder.payloadJson);
  final title = (payload['title'] as String?)?.trim().isNotEmpty == true
      ? payload['title'] as String
      : _defaultReminderTitle(reminder.entityType);
  final body = (payload['body'] as String?)?.trim().isNotEmpty == true
      ? payload['body'] as String
      : await _defaultReminderBody(service, session, reminder: reminder);

  await service.appNotifications.createForProfiles(
    session,
    profileIds: [reminder.profileId],
    familyId: reminder.familyId,
    category: 'reminder_due',
    title: title,
    body: body,
    entityType: reminder.entityType,
    entityId: reminder.entityId,
    route: _routeForEntityType(reminder.entityType),
    payload: {
      ...payload,
      'notificationId': reminder.id,
      'remindAt': reminder.remindAt.toIso8601String(),
      'firedAt': firedAt.toIso8601String(),
    },
  );
}

Map<String, dynamic> _decodePayload(String raw) {
  try {
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic>
        ? decoded
        : const <String, dynamic>{};
  } catch (_) {
    return const <String, dynamic>{};
  }
}

String _defaultReminderTitle(String entityType) {
  return switch (entityType) {
    'task' => 'Task reminder',
    'calendar' => 'Event reminder',
    _ => 'Reminder',
  };
}

Future<String> _defaultReminderBody(
  NotificationsService service,
  Session session, {
  required ReminderDto reminder,
}) async {
  if (reminder.entityType == 'task') {
    final task = await TaskRow.db.findById(session, reminder.entityId);
    if (task != null) {
      return task.title;
    }
  }
  if (reminder.entityType == 'calendar') {
    final event = await CalendarEventRow.db.findById(
      session,
      reminder.entityId,
    );
    if (event != null) {
      return event.title;
    }
  }
  return 'Open Family Helper to view the reminder.';
}

String? _routeForEntityType(String entityType) {
  return switch (entityType) {
    'task' => '/home/tasks',
    'calendar' => '/home/calendar',
    'invite' => '/home/settings/family',
    'goal' => '/home/goals',
    'list' => '/home/lists',
    _ => '/home/settings/notifications',
  };
}

NotificationPreferenceDto _mapPreference(NotificationPreferenceRow row) {
  return NotificationPreferenceDto(
    id: row.id!,
    profileId: row.profileId,
    notificationType: row.notificationType,
    enabled: row.enabled,
    quietHoursStart: row.quietHoursStart,
    quietHoursEnd: row.quietHoursEnd,
    updatedAt: row.updatedAt,
  );
}

ReminderDto _mapReminder(ReminderRow row) {
  return ReminderDto(
    id: row.id!,
    familyId: row.familyId,
    entityType: row.entityType,
    entityId: row.entityId,
    profileId: row.profileId,
    remindAt: row.remindAt,
    status: row.status,
    payloadJson: row.payloadJson,
    firedAt: row.firedAt,
    createdAt: row.createdAt,
  );
}

ReminderDto _mapReminderColumns(Map<String, dynamic> columns) {
  return ReminderDto(
    id: columns['id'] as int,
    familyId: columns['familyId'] as int,
    entityType: columns['entityType'] as String,
    entityId: columns['entityId'] as int,
    profileId: columns['profileId'] as int,
    remindAt: (columns['remindAt'] as DateTime).toUtc(),
    status: columns['status'] as String,
    payloadJson: columns['payloadJson'] as String,
    firedAt: (columns['firedAt'] as DateTime?)?.toUtc(),
    createdAt: (columns['createdAt'] as DateTime).toUtc(),
  );
}

Future<void> _emitReminderChange(
  NotificationsService service,
  Session session, {
  required int familyId,
  required int reminderId,
  required String operation,
  required DateTime changedAt,
  Transaction? transaction,
}) async {
  await service.changeFeed.appendChange(
    session,
    feature: 'notifications',
    entityType: 'reminder',
    entityId: reminderId,
    operation: operation,
    familyId: familyId,
    version: 1,
    transaction: transaction,
  );

  await service.realtime.publish(
    session,
    familyId: familyId,
    event: FamilyRealtimeEvent(
      familyId: familyId,
      feature: 'notifications',
      entityType: 'reminder',
      entityId: reminderId,
      eventType: 'notifications.updated',
      changedAt: changedAt,
    ),
  );
}

List<PushTokenRow> buildDeactivatedDuplicatePushTokens({
  required List<PushTokenRow> tokens,
  required int profileId,
  required String token,
  required DateTime now,
}) {
  return tokens
      .where(
        (entry) =>
            entry.token == token &&
            entry.profileId != profileId &&
            entry.deletedAt == null,
      )
      .map(
        (entry) => entry.copyWith(
          deletedAt: now,
          updatedAt: now,
          version: entry.version + 1,
        ),
      )
      .toList();
}
