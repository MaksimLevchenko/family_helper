import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class NotificationsRepository {
  const NotificationsRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<OperationResult> registerPushToken({
    required String clientOperationId,
    required String token,
    required String platform,
  }) {
    return _apiClient.client.notifications.registerPushToken(
      clientOperationId: clientOperationId,
      token: token,
      platform: platform,
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
}
