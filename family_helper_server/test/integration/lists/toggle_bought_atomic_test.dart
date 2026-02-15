import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

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
        final rows = await session.db.unsafeQuery(
          'SELECT COUNT(*) AS total FROM list_item_history WHERE item_id = @itemId',
          parameters: QueryParameters.named({'itemId': item.id}),
        );
        return rows.first.toColumnMap()['total'] as int;
      });

      expect(historyCount, 2);

      final storedState = await withDbSession(owner, (session) async {
        final rows = await session.db.unsafeQuery(
          'SELECT is_bought FROM list_item WHERE id = @itemId',
          parameters: QueryParameters.named({'itemId': item.id}),
        );
        return rows.first.toColumnMap()['is_bought'] as bool;
      });

      expect(storedState, false);
    });
  });
}
