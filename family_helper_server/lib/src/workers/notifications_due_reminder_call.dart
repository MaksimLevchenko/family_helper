import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../notifications/services/notifications_service.dart';

class NotificationsDueReminderCall extends FutureCall<NotificationsDuePayload> {
  NotificationsDueReminderCall({NotificationsService? service})
    : service = service ?? NotificationsService();

  final NotificationsService service;

  @override
  Future<void> invoke(Session session, NotificationsDuePayload? object) async {
    await service.processDueReminders(session);
    await session.server.serverpod.futureCallWithDelay(
      'notificationsDueReminder',
      null,
      const Duration(seconds: 30),
    );
  }
}
