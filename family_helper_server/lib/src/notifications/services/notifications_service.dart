import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';
import 'app_notification_service.dart';

class NotificationsService {
  NotificationsService({
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

  Future<OperationResult> registerPushToken(
    Session session, {
    required String clientOperationId,
    required String token,
    required String platform,
    String? provider,
    String? deviceId,
    String? appVersion,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'notifications.registerPushToken',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final now = clock.nowUtc();
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

  Future<AppNotificationDto> sendTestPush(
    Session session, {
    required String clientOperationId,
    required int familyId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'notifications.sendTestPush',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final debugEntityId = clock.nowUtc().millisecondsSinceEpoch & 0x7fffffff;
      final notification = await appNotifications.createForProfiles(
        session,
        profileIds: [profileId],
        familyId: familyId,
        category: 'debug_test_push',
        title: 'Test push',
        body: 'If you see this, Firebase push delivery is working.',
        entityType: 'notification',
        entityId: debugEntityId,
        route: '/home/settings/notifications',
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

  Future<NotificationPreferenceDto> upsertPreference(
    Session session, {
    required String clientOperationId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'notifications.upsertPreference',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final now = clock.nowUtc();
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

  Future<List<NotificationPreferenceDto>> listPreferences(
    Session session,
  ) async {
    final profileId = await authContext.ensureProfileId(session);
    final rows = await NotificationPreferenceRow.db.find(
      session,
      where: (t) => t.profileId.equals(profileId),
      orderBy: (t) => t.notificationType,
    );
    return rows.map(_mapPreference).toList();
  }

  Future<ReminderDto> scheduleReminder(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    String payloadJson = '{}',
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'notifications.scheduleReminder',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final now = clock.nowUtc();
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

      await changeFeed.appendChange(
        session,
        feature: 'notifications',
        entityType: 'reminder',
        entityId: row.id!,
        operation: 'scheduled',
        familyId: familyId,
        version: 1,
        transaction: transaction,
      );

      await realtime.publish(
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

  Future<ReminderDto?> replaceReminder(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required String entityType,
    required int entityId,
    DateTime? remindAt,
    String payloadJson = '{}',
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
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
      final now = clock.nowUtc();

      for (final reminder in existing) {
        final cancelled = await ReminderRow.db.updateRow(
          session,
          reminder.copyWith(status: 'cancelled'),
          transaction: transaction,
        );
        await _emitReminderChange(
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

  Future<List<ReminderDto>> listReminders(
    Session session, {
    int? familyId,
    String? status,
    int limit = 100,
  }) async {
    final profileId = await authContext.ensureProfileId(session);
    final normalizedLimit = limit <= 0 ? 1 : (limit > 500 ? 500 : limit);
    if (familyId != null) {
      await rbac.ensureFamilyRole(
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

  Future<AppNotificationListResponse> listInbox(
    Session session, {
    required int familyId,
    bool unreadOnly = false,
    int limit = 50,
    DateTime? before,
  }) {
    return appNotifications.listInbox(
      session,
      familyId: familyId,
      unreadOnly: unreadOnly,
      limit: limit,
      before: before,
    );
  }

  Future<OperationResult> markRead(
    Session session, {
    required int notificationId,
  }) {
    return appNotifications.markRead(session, notificationId: notificationId);
  }

  Future<OperationResult> markAllRead(
    Session session, {
    required int familyId,
  }) {
    return appNotifications.markAllRead(session, familyId: familyId);
  }

  Future<int> unreadCount(
    Session session, {
    required int familyId,
  }) {
    return appNotifications.unreadCount(session, familyId: familyId);
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

  Future<int> processDueReminders(Session session) async {
    final firedAt = clock.nowUtc();
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
        session,
        reminder: reminder,
        firedAt: firedAt,
      );
      await realtime.publish(
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

  Future<void> _createReminderNotification(
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
        : await _defaultReminderBody(session, reminder: reminder);

    await appNotifications.createForProfiles(
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
    Session session, {
    required int familyId,
    required int reminderId,
    required String operation,
    required DateTime changedAt,
    Transaction? transaction,
  }) async {
    await changeFeed.appendChange(
      session,
      feature: 'notifications',
      entityType: 'reminder',
      entityId: reminderId,
      operation: operation,
      familyId: familyId,
      version: 1,
      transaction: transaction,
    );

    await realtime.publish(
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
