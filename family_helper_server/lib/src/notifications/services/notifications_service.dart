import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class NotificationsService {
  NotificationsService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
  final ClockService clock;
  final IdempotencyService idempotency;
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

      final now = clock.nowUtc();
      final existing = await PushTokenRow.db.findFirstRow(
        session,
        where: (t) => t.profileId.equals(profileId) & t.token.equals(token),
        transaction: transaction,
      );
      if (existing == null) {
        await PushTokenRow.db.insertRow(
          session,
          PushTokenRow(
            profileId: profileId,
            token: token,
            platform: platform,
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
            version: 1,
          ),
          transaction: transaction,
        );
      } else {
        await PushTokenRow.db.updateRow(
          session,
          existing.copyWith(
            platform: platform,
            updatedAt: now,
            deletedAt: null,
            version: existing.version + 1,
          ),
          transaction: transaction,
        );
      }

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
}
