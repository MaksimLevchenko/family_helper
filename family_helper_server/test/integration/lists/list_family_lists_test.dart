import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Lists family summaries',
    (sessionBuilder, endpoints) {
      test(
        'listFamilyLists orders by updatedAt and exposes buyer names',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final member = authenticatedBuilder(sessionBuilder, user2Id);
          final runId = DateTime.now().microsecondsSinceEpoch;

          final family = await endpoints.family.createFamily(
            owner,
            clientOperationId: 'family-create-lists-view-$runId',
            title: 'Lists family',
          );

          await endpoints.profile.update(
            member,
            clientOperationId: 'profile-member-lists-view-$runId',
            displayName: 'Member Tester',
            clearAvatarMedia: false,
          );

          final invite = await endpoints.family.createInvite(
            owner,
            familyId: family.id,
            clientOperationId: 'family-invite-lists-view-$runId',
            inviteType: 'code',
          );

          await endpoints.family.acceptInvite(
            member,
            clientOperationId: 'family-accept-lists-view-$runId',
            tokenOrCode: invite.inviteCode,
          );

          final groceries = await endpoints.lists.upsertList(
            owner,
            clientOperationId: 'list-groceries-create-$runId',
            familyId: family.id,
            title: 'Groceries',
            listType: 'shopping',
          );

          final wishlist = await endpoints.lists.upsertList(
            owner,
            clientOperationId: 'list-wishlist-create-$runId',
            familyId: family.id,
            title: 'Birthday wishlist',
            listType: 'wishlist',
          );

          await endpoints.lists.upsertList(
            owner,
            clientOperationId: 'list-groceries-update-$runId',
            listId: groceries.id,
            familyId: family.id,
            title: 'Groceries refreshed',
            listType: 'shopping',
          );

          final item = await endpoints.lists.addItem(
            owner,
            clientOperationId: 'list-item-create-$runId',
            familyId: family.id,
            listId: groceries.id,
            title: 'Milk',
            qty: 1,
          );

          await endpoints.lists.toggleBought(
            member,
            clientOperationId: 'list-item-toggle-$runId',
            familyId: family.id,
            itemId: item.id,
          );

          final summaries = await endpoints.lists.listFamilyLists(
            owner,
            familyId: family.id,
          );
          final items = await endpoints.lists.listItems(
            owner,
            familyId: family.id,
            listId: groceries.id,
          );

          expect(summaries, hasLength(2));
          expect(summaries.first.title, 'Groceries refreshed');
          expect(summaries.first.pendingItemsCount, 0);
          expect(summaries.last.id, wishlist.id);
          expect(items.single.boughtByDisplayName, 'Member Tester');
        },
      );

      test(
        'updateItem and delete endpoints remove items and lists from active views',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final runId = DateTime.now().microsecondsSinceEpoch;

          final family = await endpoints.family.createFamily(
            owner,
            clientOperationId: 'family-create-lists-edit-delete-$runId',
            title: 'Lists edit delete family',
          );

          final list = await endpoints.lists.upsertList(
            owner,
            clientOperationId: 'list-create-edit-delete-$runId',
            familyId: family.id,
            title: 'Weekend shopping',
            listType: 'shopping',
          );

          final item = await endpoints.lists.addItem(
            owner,
            clientOperationId: 'list-item-create-edit-delete-$runId',
            familyId: family.id,
            listId: list.id,
            title: 'Milk',
            qty: 1,
            note: 'Whole milk',
          );

          final updatedItem = await endpoints.lists.updateItem(
            owner,
            clientOperationId: 'list-item-update-edit-delete-$runId',
            familyId: family.id,
            itemId: item.id,
            title: 'Oat milk',
            qty: 2,
            unit: 'pcs',
            note: 'Unsweetened',
          );

          expect(updatedItem.title, 'Oat milk');
          expect(updatedItem.qty, 2);
          expect(updatedItem.unit, 'pcs');
          expect(updatedItem.note, 'Unsweetened');

          await endpoints.lists.deleteItem(
            owner,
            clientOperationId: 'list-item-delete-edit-delete-$runId',
            familyId: family.id,
            itemId: item.id,
          );

          final itemsAfterDelete = await endpoints.lists.listItems(
            owner,
            familyId: family.id,
            listId: list.id,
          );
          expect(itemsAfterDelete, isEmpty);

          await endpoints.lists.deleteList(
            owner,
            clientOperationId: 'list-delete-edit-delete-$runId',
            familyId: family.id,
            listId: list.id,
          );

          final listsAfterDelete = await endpoints.lists.listFamilyLists(
            owner,
            familyId: family.id,
          );
          expect(listsAfterDelete, isEmpty);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
