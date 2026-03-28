part of 'notifications_service.dart';

Future<ReminderDto> _scheduleReminderImpl(
  NotificationsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required String entityType,
  required int entityId,
  required DateTime remindAt,
  String payloadJson = '{}',
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final profileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'notifications.scheduleReminder',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    final now = service.clock.nowUtc();
    final existing = await ReminderRow.db.findFirstRow(
      session,
      where: (t) =>
          t.profileId.equals(profileId) &
          t.clientOperationId.equals(clientOperationId),
      transaction: transaction,
    );
    final row = existing == null
        ? await ReminderRow.db.insertRow(
            session,
            ReminderRow(
              familyId: familyId,
              entityType: entityType,
              entityId: entityId,
              profileId: profileId,
              remindAt: remindAt.toUtc(),
              status: 'scheduled',
              payloadJson: payloadJson,
              clientOperationId: clientOperationId,
              firedAt: null,
              createdAt: now,
            ),
            transaction: transaction,
          )
        : await ReminderRow.db.updateRow(
            session,
            existing.copyWith(
              remindAt: remindAt.toUtc(),
              status: 'scheduled',
              payloadJson: payloadJson,
            ),
            transaction: transaction,
          );

    await service.changeFeed.appendChange(
      session,
      feature: 'notifications',
      entityType: 'reminder',
      entityId: row.id!,
      operation: 'scheduled',
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
        entityId: row.id!,
        eventType: 'notifications.updated',
        changedAt: now,
      ),
    );

    return _mapReminder(row);
  });
}

Future<ReminderDto?> _replaceReminderImpl(
  NotificationsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required String entityType,
  required int entityId,
  DateTime? remindAt,
  String payloadJson = '{}',
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final profileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'notifications.replaceReminder',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    if (!isFresh) {
      return _findScheduledReminderForEntity(
        session,
        familyId: familyId,
        profileId: profileId,
        entityType: entityType,
        entityId: entityId,
        transaction: transaction,
      );
    }

    final existing = await ReminderRow.db.find(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          t.profileId.equals(profileId) &
          t.entityType.equals(entityType) &
          t.entityId.equals(entityId) &
          t.status.equals('scheduled'),
      transaction: transaction,
    );
    final now = service.clock.nowUtc();

    for (final reminder in existing) {
      final cancelled = await ReminderRow.db.updateRow(
        session,
        reminder.copyWith(status: 'cancelled'),
        transaction: transaction,
      );
      await _emitReminderChange(
        service,
        session,
        familyId: familyId,
        reminderId: cancelled.id!,
        operation: 'cancelled',
        changedAt: now,
        transaction: transaction,
      );
    }

    if (remindAt == null) {
      return null;
    }

    final row = await ReminderRow.db.insertRow(
      session,
      ReminderRow(
        familyId: familyId,
        entityType: entityType,
        entityId: entityId,
        profileId: profileId,
        remindAt: remindAt.toUtc(),
        status: 'scheduled',
        payloadJson: payloadJson,
        clientOperationId: clientOperationId,
        firedAt: null,
        createdAt: now,
      ),
      transaction: transaction,
    );
    await _emitReminderChange(
      service,
      session,
      familyId: familyId,
      reminderId: row.id!,
      operation: 'scheduled',
      changedAt: now,
      transaction: transaction,
    );
    return _mapReminder(row);
  });
}

Future<List<ReminderDto>> _listRemindersImpl(
  NotificationsService service,
  Session session, {
  int? familyId,
  String? status,
  int limit = 100,
}) async {
  final profileId = await service.authContext.ensureProfileId(session);
  final normalizedLimit = limit <= 0 ? 1 : (limit > 500 ? 500 : limit);
  if (familyId != null) {
    await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
    );
  }

  final rows = await ReminderRow.db.find(
    session,
    where: (t) {
      var predicate = t.profileId.equals(profileId);
      if (familyId != null) {
        predicate = predicate & t.familyId.equals(familyId);
      }
      if (status != null && status.trim().isNotEmpty) {
        predicate = predicate & t.status.equals(status.trim());
      }
      return predicate;
    },
    orderBy: (t) => t.remindAt,
    orderDescending: true,
    limit: normalizedLimit,
  );

  return rows.map(_mapReminder).toList();
}

Future<int> _processDueRemindersImpl(
  NotificationsService service,
  Session session,
) async {
  final firedAt = service.clock.nowUtc();
  final firedReminders = await session.db.transaction((transaction) async {
    final result = await session.db.unsafeQuery(
      '''
        UPDATE "reminder"
        SET "status" = 'fired',
            "firedAt" = @firedAt
        WHERE "id" IN (
          SELECT "id"
          FROM "reminder"
          WHERE "status" = 'scheduled'
            AND "remindAt" <= @firedAt
          ORDER BY "remindAt"
          LIMIT 200
          FOR UPDATE SKIP LOCKED
        )
        RETURNING "id", "familyId", "entityType", "entityId", "profileId",
                  "remindAt", "status", "payloadJson", "firedAt", "createdAt"
        ''',
      transaction: transaction,
      parameters: QueryParameters.named({'firedAt': firedAt}),
    );

    return result
        .map((row) => _mapReminderColumns(row.toColumnMap()))
        .toList();
  });

  for (final reminder in firedReminders) {
    await _createReminderNotification(
      service,
      session,
      reminder: reminder,
      firedAt: firedAt,
    );
    await service.realtime.publish(
      session,
      familyId: reminder.familyId,
      event: FamilyRealtimeEvent(
        familyId: reminder.familyId,
        feature: 'notifications',
        entityType: 'reminder',
        entityId: reminder.id,
        eventType: 'reminder_fired',
        changedAt: firedAt,
      ),
    );
  }

  return firedReminders.length;
}
