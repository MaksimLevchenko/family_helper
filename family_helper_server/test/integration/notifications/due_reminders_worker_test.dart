import 'package:test/test.dart';

import 'package:family_helper_server/src/notifications/services/notifications_service.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Notifications due reminder worker',
    (sessionBuilder, endpoints) {
      test('processDueReminders fires due reminders exactly once', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-reminder-$runId',
          title: 'Reminder Family',
        );

        final reminder = await endpoints.notifications.scheduleReminder(
          owner,
          clientOperationId: 'reminder-schedule-$runId',
          familyId: family.id,
          entityType: 'task',
          entityId: 123,
          remindAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
          payloadJson: '{"taskId":123}',
        );

        final notificationsService = NotificationsService();
        final workerRuns = await Future.wait([
          withDbSession(owner, notificationsService.processDueReminders),
          withDbSession(owner, notificationsService.processDueReminders),
        ]);
        final firstRun = workerRuns[0];
        final secondRun = workerRuns[1];

        expect(firstRun + secondRun, 1);
        expect(workerRuns.where((count) => count == 1), hasLength(1));

        final thirdRun = await withDbSession(
          owner,
          notificationsService.processDueReminders,
        );
        expect(thirdRun, 0);

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
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
