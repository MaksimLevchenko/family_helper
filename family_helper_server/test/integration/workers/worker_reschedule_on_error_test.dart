// ignore_for_file: implementation_imports

import 'package:family_helper_server/src/notifications/services/notifications_service.dart';
import 'package:family_helper_server/src/workers/future_call_names.dart';
import 'package:family_helper_server/src/workers/notifications_due_reminder_call.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/future_call_entry.dart';
import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

class _FailingNotificationsService extends NotificationsService {
  @override
  Future<int> processDueReminders(Session session) {
    throw StateError('simulated worker failure');
  }
}

void main() {
  withServerpod('Worker reschedule on error', (sessionBuilder, _) {
    test(
      'notifications worker schedules next run even when processing fails',
      () async {
        final worker = NotificationsDueReminderCall(
          service: _FailingNotificationsService(),
        );
        final builder = authenticatedBuilder(sessionBuilder, user1Id);

        final before = await withDbSession(builder, (session) async {
          final rows = await FutureCallEntry.db.find(
            session,
            where: (t) => t.identifier.equals(
              FutureCallNames.notificationsDueReminderIdentifier,
            ),
          );
          return rows.length;
        });

        await withDbSession(builder, (
          session,
        ) async {
          await worker.invoke(session, null);
        });

        final after = await withDbSession(builder, (session) async {
          final rows = await FutureCallEntry.db.find(
            session,
            where: (t) => t.identifier.equals(
              FutureCallNames.notificationsDueReminderIdentifier,
            ),
          );
          return rows.length;
        });

        expect(before, inInclusiveRange(0, 1));
        expect(after, 1);
      },
    );
  });
}
