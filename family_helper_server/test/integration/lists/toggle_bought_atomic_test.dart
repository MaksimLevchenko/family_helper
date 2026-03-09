import 'package:test/test.dart';
import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

void main() {
  withServerpod('Lists toggle bought', (sessionBuilder, endpoints) {
    test('toggleBought updates item atomically and writes history', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-list-001',
        title: 'List Family',
      );

      final list = await endpoints.lists.upsertList(
        owner,
        clientOperationId: 'list-create-001',
        familyId: family.id,
        title: 'Shopping',
        listType: 'shopping',
      );

      final item = await endpoints.lists.addItem(
        owner,
        clientOperationId: 'item-create-001',
        familyId: family.id,
        listId: list.id,
        title: 'Milk',
        qty: 1,
      );

      final toggles = await Future.wait([
        endpoints.lists.toggleBought(
          owner,
          clientOperationId: 'item-toggle-001',
          familyId: family.id,
          itemId: item.id,
        ),
        endpoints.lists.toggleBought(
          owner,
          clientOperationId: 'item-toggle-002',
          familyId: family.id,
          itemId: item.id,
        ),
      ]);

      expect(toggles.length, 2);

      final historyCount = await withDbSession(owner, (session) async {
        return ListItemHistoryRow.db.count(
          session,
          where: (t) => t.itemId.equals(item.id),
        );
      });

      expect(historyCount, 2);

      final storedState = await withDbSession(owner, (session) async {
        final row = await ListItemRow.db.findById(session, item.id);
        return row!.isBought;
      });

      expect(storedState, false);
    });
  });
}


