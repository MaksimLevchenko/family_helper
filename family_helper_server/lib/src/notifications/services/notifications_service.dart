import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/notifications/fcm_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class NotificationsService {
  NotificationsService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    this.fcmService = const FcmService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
  final IdempotencyService idempotency;
  final FcmService fcmService;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;

  Future<OperationResult> registerPushToken(
    Session session, {
    required String clientOperationId,
    required String token,
    required String platform,
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

      await session.db.unsafeExecute(
        '''
        INSERT INTO push_token (
          profile_id,
          token,
          platform,
          created_at,
          updated_at,
          deleted_at,
          version
        ) VALUES (
          @profileId,
          @token,
          @platform,
          @now,
          @now,
          NULL,
          1
        )
        ON CONFLICT (profile_id, token)
        DO UPDATE SET
          platform = EXCLUDED.platform,
          updated_at = EXCLUDED.updated_at,
          deleted_at = NULL,
          version = push_token.version + 1
        ''',
        parameters: QueryParameters.named({
          'profileId': profileId,
          'token': token,
          'platform': platform,
          'now': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      return OperationResult(success: true, message: 'Push token registered');
    });
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

      final rows = await session.db.unsafeQuery(
        '''
        INSERT INTO notification_preference (
          profile_id,
          notification_type,
          enabled,
          quiet_hours_start,
          quiet_hours_end,
          updated_at,
          version
        ) VALUES (
          @profileId,
          @notificationType,
          @enabled,
          @quietHoursStart,
          @quietHoursEnd,
          @updatedAt,
          1
        )
        ON CONFLICT (profile_id, notification_type)
        DO UPDATE SET
          enabled = EXCLUDED.enabled,
          quiet_hours_start = EXCLUDED.quiet_hours_start,
          quiet_hours_end = EXCLUDED.quiet_hours_end,
          updated_at = EXCLUDED.updated_at,
          version = notification_preference.version + 1
        RETURNING
          id,
          profile_id,
          notification_type,
          enabled,
          quiet_hours_start,
          quiet_hours_end,
          updated_at
        ''',
        parameters: QueryParameters.named({
          'profileId': profileId,
          'notificationType': notificationType,
          'enabled': enabled,
          'quietHoursStart': quietHoursStart,
          'quietHoursEnd': quietHoursEnd,
          'updatedAt': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      return _mapPreference(rows.first.toColumnMap());
    });
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

      final rows = await session.db.unsafeQuery(
        '''
        INSERT INTO reminder (
          family_id,
          entity_type,
          entity_id,
          profile_id,
          remind_at,
          status,
          payload_json,
          client_operation_id,
          fired_at,
          created_at
        ) VALUES (
          @familyId,
          @entityType,
          @entityId,
          @profileId,
          @remindAt,
          'scheduled',
          @payload,
          @clientOperationId,
          NULL,
          @createdAt
        )
        ON CONFLICT (profile_id, client_operation_id)
        DO UPDATE SET
          remind_at = EXCLUDED.remind_at,
          status = 'scheduled',
          payload_json = EXCLUDED.payload_json
        RETURNING
          id,
          family_id,
          entity_type,
          entity_id,
          profile_id,
          remind_at,
          status,
          payload_json,
          fired_at,
          created_at
        ''',
        parameters: QueryParameters.named({
          'familyId': familyId,
          'entityType': entityType,
          'entityId': entityId,
          'profileId': profileId,
          'remindAt': remindAt.toUtc(),
          'payload': payloadJson,
          'clientOperationId': clientOperationId,
          'createdAt': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      await changeFeed.appendChange(
        session,
        feature: 'notifications',
        entityType: 'reminder',
        entityId: rows.first.toColumnMap()['id'] as int,
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
          entityId: rows.first.toColumnMap()['id'] as int,
          eventType: 'notifications.updated',
          changedAt: DateTime.now().toUtc(),
        ),
      );

      return _mapReminder(rows.first.toColumnMap());
    });
  }

  Future<int> processDueReminders(Session session) async {
    final dueRows = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        entity_type,
        entity_id,
        profile_id,
        remind_at,
        status,
        payload_json,
        fired_at,
        created_at
      FROM reminder
      WHERE status = 'scheduled'
        AND remind_at <= @now
      ORDER BY remind_at ASC
      LIMIT 200
      ''',
      parameters: QueryParameters.named({'now': DateTime.now().toUtc()}),
    );

    int sent = 0;
    for (final row in dueRows) {
      final reminder = _mapReminder(row.toColumnMap());
      final tokens = await session.db.unsafeQuery(
        '''
        SELECT token
        FROM push_token
        WHERE profile_id = @profileId
          AND deleted_at IS NULL
        ''',
        parameters: QueryParameters.named({'profileId': reminder.profileId}),
      );

      for (final tokenRow in tokens) {
        final token = tokenRow.toColumnMap()['token'] as String;
        await fcmService.send(
          token,
          title: 'Family Helper reminder',
          body: 'Reminder for ${reminder.entityType}',
          data: {
            'entityType': reminder.entityType,
            'entityId': reminder.entityId.toString(),
            'reminderId': reminder.id.toString(),
          },
        );
      }

      await session.db.unsafeExecute(
        '''
        UPDATE reminder
        SET status = 'fired', fired_at = @firedAt
        WHERE id = @id
        ''',
        parameters: QueryParameters.named({
          'id': reminder.id,
          'firedAt': DateTime.now().toUtc(),
        }),
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
          changedAt: DateTime.now().toUtc(),
        ),
      );

      sent += 1;
    }

    return sent;
  }

  NotificationPreferenceDto _mapPreference(Map<String, dynamic> row) {
    return NotificationPreferenceDto(
      id: row['id'] as int,
      profileId: row['profile_id'] as int,
      notificationType: row['notification_type'] as String,
      enabled: row['enabled'] as bool,
      quietHoursStart: row['quiet_hours_start'] as String?,
      quietHoursEnd: row['quiet_hours_end'] as String?,
      updatedAt: row['updated_at'] as DateTime,
    );
  }

  ReminderDto _mapReminder(Map<String, dynamic> row) {
    return ReminderDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int,
      entityType: row['entity_type'] as String,
      entityId: row['entity_id'] as int,
      profileId: row['profile_id'] as int,
      remindAt: row['remind_at'] as DateTime,
      status: row['status'] as String,
      payloadJson: row['payload_json'] as String,
      firedAt: row['fired_at'] as DateTime?,
      createdAt: row['created_at'] as DateTime,
    );
  }
}
