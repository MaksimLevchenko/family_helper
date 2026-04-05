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
import 'notification_message_builder.dart';

part 'notifications_service_helpers.dart';
part 'notifications_service_preferences.dart';
part 'notifications_service_reminders.dart';
part 'notifications_service_tokens.dart';

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
  }) {
    return _registerPushTokenImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      token: token,
      platform: platform,
      provider: provider,
      deviceId: deviceId,
      appVersion: appVersion,
    );
  }

  Future<AppNotificationDto> sendTestPush(
    Session session, {
    required String clientOperationId,
    required int familyId,
  }) {
    return _sendTestPushImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
    );
  }

  Future<NotificationPreferenceDto> upsertPreference(
    Session session, {
    required String clientOperationId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return _upsertPreferenceImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      notificationType: notificationType,
      enabled: enabled,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
    );
  }

  Future<List<NotificationPreferenceDto>> listPreferences(Session session) {
    return _listPreferencesImpl(this, session);
  }

  Future<ReminderDto> scheduleReminder(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    String payloadJson = '{}',
  }) {
    return _scheduleReminderImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      entityType: entityType,
      entityId: entityId,
      remindAt: remindAt,
      payloadJson: payloadJson,
    );
  }

  Future<ReminderDto?> replaceReminder(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required String entityType,
    required int entityId,
    DateTime? remindAt,
    String payloadJson = '{}',
  }) {
    return _replaceReminderImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      entityType: entityType,
      entityId: entityId,
      remindAt: remindAt,
      payloadJson: payloadJson,
    );
  }

  Future<List<ReminderDto>> listReminders(
    Session session, {
    int? familyId,
    String? status,
    int limit = 100,
  }) {
    return _listRemindersImpl(
      this,
      session,
      familyId: familyId,
      status: status,
      limit: limit,
    );
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

  Future<int> processDueReminders(Session session) {
    return _processDueRemindersImpl(this, session);
  }
}
