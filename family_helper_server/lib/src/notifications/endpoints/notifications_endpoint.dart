import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/notifications_service.dart';

class NotificationsEndpoint extends Endpoint {
  NotificationsEndpoint({NotificationsService? service})
    : service = service ?? NotificationsService();

  final NotificationsService service;

  Future<OperationResult> registerPushToken(
    Session session, {
    required String clientOperationId,
    required String token,
    required String platform,
    String? provider,
    String? deviceId,
    String? appVersion,
  }) {
    return service.registerPushToken(
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
    return service.sendTestPush(
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
    return service.upsertPreference(
      session,
      clientOperationId: clientOperationId,
      notificationType: notificationType,
      enabled: enabled,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
    );
  }

  Future<List<NotificationPreferenceDto>> listPreferences(Session session) {
    return service.listPreferences(session);
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
    return service.scheduleReminder(
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
    return service.replaceReminder(
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
    return service.listReminders(
      session,
      familyId: familyId,
      status: status,
      limit: limit,
    );
  }

  Future<int> processDueReminders(Session session) {
    throw AccessDeniedException(
      message: 'This method is internal and is not available to clients.',
    );
  }

  Future<AppNotificationListResponse> listInbox(
    Session session, {
    required int familyId,
    bool unreadOnly = false,
    int limit = 50,
    DateTime? before,
  }) {
    return service.listInbox(
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
    return service.markRead(session, notificationId: notificationId);
  }

  Future<OperationResult> markAllRead(
    Session session, {
    required int familyId,
  }) {
    return service.markAllRead(session, familyId: familyId);
  }

  Future<int> unreadCount(
    Session session, {
    required int familyId,
  }) {
    return service.unreadCount(session, familyId: familyId);
  }
}
