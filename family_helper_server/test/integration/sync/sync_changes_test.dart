import 'package:test/test.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Sync changes feed', (sessionBuilder, endpoints) {
    test('returns updates for created family entities', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final since = DateTime.utc(2020, 1, 1);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-sync-001',
        title: 'Sync Family',
      );

      await endpoints.tasks.upsertTask(
        owner,
        clientOperationId: 'task-create-sync-001',
        familyId: family.id,
        title: 'Sync task',
        isPersonal: false,
        priority: 'normal',
      );

      final changes = await endpoints.sync.changes(
        owner,
        since: since,
        familyId: family.id,
        limit: 100,
        lastSeenChangeId: 0,
      );

      expect(changes.changes, isNotEmpty);
      expect(
        changes.changes.any(
          (it) => it.feature == 'family' && it.entityType == 'family',
        ),
        isTrue,
      );
      expect(
        changes.changes.any(
          (it) => it.feature == 'tasks' && it.entityType == 'task',
        ),
        isTrue,
      );
    });

    test('normalizes invalid and oversized limits', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final since = DateTime.utc(2020, 1, 1);
      final changedAt = DateTime.utc(2026, 3, 9, 12, 0);

      await withDbSession(owner, (session) async {
        for (var i = 0; i < 510; i++) {
          await ChangeFeedRow.db.insertRow(
            session,
            ChangeFeedRow(
              familyId: null,
              feature: 'sync-test',
              entityType: 'seed',
              entityId: i + 1,
              operation: 'seeded',
              changedAt: changedAt,
              tombstone: false,
              version: 1,
              payloadJson: '{}',
            ),
          );
        }
      });

      final lowLimit = await endpoints.sync.changes(
        owner,
        since: since,
        familyId: null,
        limit: -10,
        lastSeenChangeId: 0,
      );
      expect(lowLimit.changes, hasLength(1));

      final highLimit = await endpoints.sync.changes(
        owner,
        since: since,
        familyId: null,
        limit: 10_000,
        lastSeenChangeId: 0,
      );
      expect(highLimit.changes, hasLength(500));
      expect(highLimit.hasMore, isTrue);
    });
  });
}
