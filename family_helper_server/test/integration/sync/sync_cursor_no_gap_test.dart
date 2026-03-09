import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Sync cursor no gap', (sessionBuilder, endpoints) {
    test(
      'cursor (since + lastSeenChangeId) does not lose changes on same timestamp',
      () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final since = DateTime.utc(2020, 1, 1);

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-sync-cursor-001',
          title: 'Sync Cursor Family',
        );

        await endpoints.tasks.upsertTask(
          owner,
          clientOperationId: 'task-create-sync-cursor-001',
          familyId: family.id,
          title: 'First task',
          isPersonal: false,
          priority: 'normal',
        );

        await endpoints.tasks.upsertTask(
          owner,
          clientOperationId: 'task-create-sync-cursor-002',
          familyId: family.id,
          title: 'Second task',
          isPersonal: false,
          priority: 'normal',
        );

        final firstPage = await endpoints.sync.changes(
          owner,
          since: since,
          familyId: family.id,
          limit: 1,
          lastSeenChangeId: 0,
        );
        expect(firstPage.changes, isNotEmpty);

        final secondPage = await endpoints.sync.changes(
          owner,
          since: firstPage.nextSince,
          familyId: family.id,
          limit: 100,
          lastSeenChangeId: firstPage.nextLastSeenChangeId,
        );

        final firstIds = firstPage.changes.map((it) => it.id).toSet();
        final secondIds = secondPage.changes.map((it) => it.id).toSet();

        expect(secondIds.intersection(firstIds), isEmpty);
        expect(secondPage.changes, isNotEmpty);
      },
    );
  });
}
