import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class NotificationsRepository {
  const NotificationsRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<OperationResult> registerPushToken({
    required String clientOperationId,
    required String token,
    required String platform,
    String? provider,
    String? deviceId,
    String? appVersion,
  }) {
    return _apiClient.client.notifications.registerPushToken(
      clientOperationId: clientOperationId,
      token: token,
      platform: platform,
      provider: provider,
      deviceId: deviceId,
      appVersion: appVersion,
    );
  }

  Future<AppNotificationDto> sendTestPush({
    required String clientOperationId,
    required int familyId,
  }) {
    return _apiClient.client.notifications.sendTestPush(
      clientOperationId: clientOperationId,
      familyId: familyId,
    );
  }

  Future<NotificationPreferenceDto> upsertPreference({
    required String clientOperationId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return _apiClient.client.notifications.upsertPreference(
      clientOperationId: clientOperationId,
      notificationType: notificationType,
      enabled: enabled,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
    );
  }

  Future<List<NotificationPreferenceDto>> listPreferences() {
    return _apiClient.client.notifications.listPreferences();
  }

  Future<ReminderDto> scheduleReminder({
    required String clientOperationId,
    required int familyId,
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
  }) {
    return _apiClient.client.notifications.scheduleReminder(
      clientOperationId: clientOperationId,
      familyId: familyId,
      entityType: entityType,
      entityId: entityId,
      remindAt: remindAt,
      payloadJson: payloadJson,
    );
  }

  Future<ReminderDto?> replaceReminder({
    required String clientOperationId,
    required int familyId,
    required String entityType,
    required int entityId,
    DateTime? remindAt,
    required String payloadJson,
  }) {
    return _apiClient.client.notifications.replaceReminder(
      clientOperationId: clientOperationId,
      familyId: familyId,
      entityType: entityType,
      entityId: entityId,
      remindAt: remindAt,
      payloadJson: payloadJson,
    );
  }

  Future<List<ReminderDto>> listReminders({
    int? familyId,
    String? status,
    int limit = 100,
  }) {
    return _apiClient.client.notifications.listReminders(
      familyId: familyId,
      status: status,
      limit: limit,
    );
  }

  Future<AppNotificationListResponse> listInbox({
    required int familyId,
    bool unreadOnly = false,
    int limit = 50,
    DateTime? before,
  }) {
    return _apiClient.client.notifications.listInbox(
      familyId: familyId,
      unreadOnly: unreadOnly,
      limit: limit,
      before: before,
    );
  }

  Future<OperationResult> markRead({
    required int notificationId,
  }) {
    return _apiClient.client.notifications.markRead(
      notificationId: notificationId,
    );
  }

  Future<OperationResult> markAllRead({
    required int familyId,
  }) {
    return _apiClient.client.notifications.markAllRead(familyId: familyId);
  }

  Future<int> unreadCount({
    required int familyId,
  }) {
    return _apiClient.client.notifications.unreadCount(familyId: familyId);
  }
}
