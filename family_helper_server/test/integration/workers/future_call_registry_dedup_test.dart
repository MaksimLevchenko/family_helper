import 'package:test/test.dart';
import 'package:serverpod/src/generated/future_call_entry.dart';
import 'package:family_helper_server/src/workers/future_call_names.dart';
import 'package:family_helper_server/src/workers/future_call_registry.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('FutureCall registry dedupe', (sessionBuilder, _) {
    test(
      'scheduleAll keeps single pending job per worker identifier',
      () async {
        await withDbSession(sessionBuilder, (session) async {
          await FutureCallRegistry.scheduleAll(session.server.serverpod);
          await FutureCallRegistry.scheduleAll(session.server.serverpod);

          final identifiers = <String>{
            FutureCallNames.notificationsDueReminderIdentifier,
            FutureCallNames.mediaCleanupIdentifier,
            FutureCallNames.privacyExportIdentifier,
            FutureCallNames.accountDeletionIdentifier,
          };
          final rows = await FutureCallEntry.db.find(
            session,
            where: (t) => t.identifier.inSet(identifiers),
          );

          final grouped = <String, int>{};
          for (final row in rows) {
            final id = row.identifier!;
            grouped[id] = (grouped[id] ?? 0) + 1;
          }

          expect(grouped.length, 4);
          for (final total in grouped.values) {
            expect(total, 1);
          }
        });
      },
    );
  });
}
