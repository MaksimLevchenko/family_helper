import 'package:test/test.dart';
import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

void main() {
  withServerpod(
    'Lists toggle bought',
    (sessionBuilder, endpoints) {
      test('toggleBought updates item atomically and writes history', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-list-$runId',
          title: 'List Family',
        );

        final list = await endpoints.lists.upsertList(
          owner,
          clientOperationId: 'list-create-$runId',
          familyId: family.id,
          title: 'Shopping',
          listType: 'shopping',
        );

        final item = await endpoints.lists.addItem(
          owner,
          clientOperationId: 'item-create-$runId',
          familyId: family.id,
          listId: list.id,
          title: 'Milk',
          qty: 1,
        );

        final toggles = await Future.wait([
          endpoints.lists.toggleBought(
            owner,
            clientOperationId: 'item-toggle-a-$runId',
            familyId: family.id,
            itemId: item.id,
          ),
          endpoints.lists.toggleBought(
            owner,
            clientOperationId: 'item-toggle-b-$runId',
            familyId: family.id,
            itemId: item.id,
          ),
        ]);

        expect(toggles.length, 2);

        final toggleHistoryCount = await withDbSession(owner, (session) async {
          return ListItemHistoryRow.db.count(
            session,
            where: (t) =>
                t.itemId.equals(item.id) &
                (t.eventType.equals('bought') | t.eventType.equals('unbought')),
          );
        });

        expect(toggleHistoryCount, 2);

        final storedState = await withDbSession(owner, (session) async {
          final row = await ListItemRow.db.findById(session, item.id);
          return row!.isBought;
        });

        expect(storedState, false);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
