import 'package:test/test.dart';

import 'package:family_helper_server/src/generated/protocol.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Notifications replace reminder',
    (sessionBuilder, endpoints) {
      test(
        'replaceReminder keeps one active reminder and cancels prior records',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final runId = DateTime.now().microsecondsSinceEpoch;

          final family = await endpoints.family.createFamily(
            owner,
            clientOperationId: 'family-create-replace-reminder-$runId',
            title: 'Replace Reminder Family',
          );

          final firstReminder = await endpoints.notifications.replaceReminder(
            owner,
            clientOperationId: 'replace-reminder-first-$runId',
            familyId: family.id,
            entityType: 'task',
            entityId: 501,
            remindAt: DateTime.utc(2026, 3, 27, 8),
            payloadJson: '{"taskId":501}',
          );

          expect(firstReminder, isNotNull);
          expect(firstReminder!.status, 'scheduled');

          final secondReminder = await endpoints.notifications.replaceReminder(
            owner,
            clientOperationId: 'replace-reminder-second-$runId',
            familyId: family.id,
            entityType: 'task',
            entityId: 501,
            remindAt: DateTime.utc(2026, 3, 27, 9),
            payloadJson: '{"taskId":501}',
          );

          expect(secondReminder, isNotNull);
          expect(secondReminder!.status, 'scheduled');
          expect(secondReminder.remindAt, DateTime.utc(2026, 3, 27, 9));

          final scheduledAfterReplace = await endpoints.notifications
              .listReminders(
                owner,
                familyId: family.id,
                status: 'scheduled',
                limit: 100,
              );
          expect(
            scheduledAfterReplace.where((item) => item.entityId == 501),
            hasLength(1),
          );
          expect(
            scheduledAfterReplace
                .singleWhere((item) => item.entityId == 501)
                .id,
            secondReminder.id,
          );

          final rowsAfterReplace = await withDbSession(owner, (session) async {
            return ReminderRow.db.find(
              session,
              where: (t) =>
                  t.familyId.equals(family.id) &
                  t.entityType.equals('task') &
                  t.entityId.equals(501),
            );
          });
          expect(
            rowsAfterReplace.where((row) => row.status == 'scheduled'),
            hasLength(1),
          );
          expect(
            rowsAfterReplace.where((row) => row.status == 'cancelled'),
            hasLength(1),
          );

          final removedReminder = await endpoints.notifications.replaceReminder(
            owner,
            clientOperationId: 'replace-reminder-remove-$runId',
            familyId: family.id,
            entityType: 'task',
            entityId: 501,
            remindAt: null,
            payloadJson: '{"taskId":501}',
          );

          expect(removedReminder, isNull);

          final scheduledAfterRemoval = await endpoints.notifications
              .listReminders(
                owner,
                familyId: family.id,
                status: 'scheduled',
                limit: 100,
              );
          expect(
            scheduledAfterRemoval.where((item) => item.entityId == 501),
            isEmpty,
          );

          final rowsAfterRemoval = await withDbSession(owner, (session) async {
            return ReminderRow.db.find(
              session,
              where: (t) =>
                  t.familyId.equals(family.id) &
                  t.entityType.equals('task') &
                  t.entityId.equals(501),
            );
          });
          expect(
            rowsAfterRemoval.where((row) => row.status == 'cancelled'),
            hasLength(2),
          );
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
