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
  }) {
    return service.registerPushToken(
      session,
      clientOperationId: clientOperationId,
      token: token,
      platform: platform,
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

  Future<int> processDueReminders(Session session) {
    throw AccessDeniedException(
      message: 'This method is internal and is not available to clients.',
    );
  }
}
