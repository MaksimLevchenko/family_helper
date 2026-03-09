import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../notifications/services/notifications_service.dart';
import 'future_call_registry.dart';

class NotificationsDueReminderCall extends FutureCall<NotificationsDuePayload> {
  NotificationsDueReminderCall({NotificationsService? service})
    : service = service ?? NotificationsService();

  final NotificationsService service;

  @override
  Future<void> invoke(Session session, NotificationsDuePayload? object) async {
    try {
      await service.processDueReminders(session);
    } catch (error, stackTrace) {
      session.log(
        'notifications_due_reminder worker failed; payload=${object?.toJson()}',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      await FutureCallRegistry.scheduleNotificationsDueReminder(
        session.server.serverpod,
      );
    }
  }
}
