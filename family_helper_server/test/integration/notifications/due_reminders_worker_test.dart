import 'package:test/test.dart';

import 'package:family_helper_server/src/notifications/services/notifications_service.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Notifications due reminder worker', (
    sessionBuilder,
    endpoints,
  ) {
    test('processDueReminders fires due reminders exactly once', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-reminder-001',
        title: 'Reminder Family',
      );

      final reminder = await endpoints.notifications.scheduleReminder(
        owner,
        clientOperationId: 'reminder-schedule-001',
        familyId: family.id,
        entityType: 'task',
        entityId: 123,
        remindAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
        payloadJson: '{"taskId":123}',
      );

      final notificationsService = NotificationsService();
      final firstRun = await withDbSession(
        owner,
        notificationsService.processDueReminders,
      );
      final secondRun = await withDbSession(
        owner,
        notificationsService.processDueReminders,
      );

      expect(firstRun, 1);
      expect(secondRun, 0);

      final changes = await endpoints.sync.changes(
        owner,
        since: DateTime.utc(2020, 1, 1),
        familyId: family.id,
        limit: 100,
        lastSeenChangeId: 0,
      );

      expect(
        changes.changes.any(
          (it) => it.feature == 'notifications' && it.entityId == reminder.id,
        ),
        isTrue,
      );
    });
  });
}
