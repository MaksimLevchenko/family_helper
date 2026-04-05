part of 'notifications_service.dart';

Future<OperationResult> _registerPushTokenImpl(
  NotificationsService service,
  Session session, {
  required String clientOperationId,
  required String token,
  required String platform,
  String? provider,
  String? deviceId,
  String? appVersion,
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
      action: 'notifications.registerPushToken',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    final now = service.clock.nowUtc();
    await _deactivateTokenForOtherProfiles(
      session,
      profileId: profileId,
      token: token,
      now: now,
      transaction: transaction,
    );
    final existing = await _findPushTokenRow(
      session,
      profileId: profileId,
      token: token,
      transaction: transaction,
    );
    if (existing == null) {
      try {
        await PushTokenRow.db.insertRow(
          session,
          PushTokenRow(
            profileId: profileId,
            token: token,
            platform: platform,
            provider: provider,
            deviceId: deviceId,
            appVersion: appVersion,
            createdAt: now,
            updatedAt: now,
            lastSeenAt: now,
            lastErrorAt: null,
            deletedAt: null,
            disabledAt: null,
            version: 1,
          ),
          transaction: transaction,
        );
      } on DatabaseInsertRowException {
        await _refreshExistingPushToken(
          session,
          profileId: profileId,
          token: token,
          platform: platform,
          provider: provider,
          deviceId: deviceId,
          appVersion: appVersion,
          now: now,
          transaction: transaction,
        );
      } on DatabaseQueryException catch (error) {
        if (error.code != '23505') {
          rethrow;
        }
        await _refreshExistingPushToken(
          session,
          profileId: profileId,
          token: token,
          platform: platform,
          provider: provider,
          deviceId: deviceId,
          appVersion: appVersion,
          now: now,
          transaction: transaction,
        );
      }
    } else {
      await _updatePushTokenRow(
        session,
        existing: existing,
        platform: platform,
        provider: provider,
        deviceId: deviceId,
        appVersion: appVersion,
        now: now,
        transaction: transaction,
      );
    }

    return OperationResult(success: true, message: 'Push token registered');
  });
}

Future<AppNotificationDto> _sendTestPushImpl(
  NotificationsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
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
      action: 'notifications.sendTestPush',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    final debugEntityId =
        service.clock.nowUtc().millisecondsSinceEpoch & 0x7fffffff;
    final localeCode = await service.appNotifications.profileLocaleCode(
      session,
      profileId: profileId,
      transaction: transaction,
    );
    final message = buildDebugTestPushNotificationMessage(
      localeCode: localeCode,
    );

    final notification = await service.appNotifications.createForProfiles(
      session,
      profileIds: [profileId],
      familyId: familyId,
      category: 'debug_test_push',
      title: message.title,
      body: message.body,
      entityType: 'notification',
      entityId: debugEntityId,
      route: '/home/notifications/settings',
      payload: {
        'category': 'debug_test_push',
        'familyId': familyId,
        'entityType': 'notification',
        'entityId': debugEntityId,
        'clientOperationId': clientOperationId,
      },
      transaction: transaction,
    );

    return notification.single;
  });
}
