part of 'notifications_service.dart';

Future<NotificationPreferenceDto> _upsertPreferenceImpl(
  NotificationsService service,
  Session session, {
  required String clientOperationId,
  required String notificationType,
  required bool enabled,
  String? quietHoursStart,
  String? quietHoursEnd,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final profileId = await service.authContext.ensureProfileId(
      session,
      transaction: transaction,
    );

    await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'notifications.upsertPreference',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    final now = service.clock.nowUtc();
    final existing = await NotificationPreferenceRow.db.findFirstRow(
      session,
      where: (t) =>
          t.profileId.equals(profileId) &
          t.notificationType.equals(notificationType),
      transaction: transaction,
    );
    final row = existing == null
        ? await NotificationPreferenceRow.db.insertRow(
            session,
            NotificationPreferenceRow(
              profileId: profileId,
              notificationType: notificationType,
              enabled: enabled,
              quietHoursStart: quietHoursStart,
              quietHoursEnd: quietHoursEnd,
              updatedAt: now,
              version: 1,
            ),
            transaction: transaction,
          )
        : await NotificationPreferenceRow.db.updateRow(
            session,
            existing.copyWith(
              enabled: enabled,
              quietHoursStart: quietHoursStart,
              quietHoursEnd: quietHoursEnd,
              updatedAt: now,
              version: existing.version + 1,
            ),
            transaction: transaction,
          );

    return _mapPreference(row);
  });
}

Future<List<NotificationPreferenceDto>> _listPreferencesImpl(
  NotificationsService service,
  Session session,
) async {
  final profileId = await service.authContext.ensureProfileId(session);
  final rows = await NotificationPreferenceRow.db.find(
    session,
    where: (t) => t.profileId.equals(profileId),
    orderBy: (t) => t.notificationType,
  );
  return rows.map(_mapPreference).toList();
}
