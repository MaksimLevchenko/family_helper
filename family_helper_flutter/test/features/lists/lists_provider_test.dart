import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:family_helper_flutter/features/lists/data/lists_repository.dart';
import 'package:family_helper_flutter/features/lists/providers/lists_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestFamilySelectionCubit extends FamilySelectionCubit {
  _TestFamilySelectionCubit(int? initialFamilyId) : super() {
    emit(initialFamilyId);
  }

  @override
  Future<void> bootstrap() async {}

  @override
  Future<void> setFamilyId(int familyId) async {
    emit(familyId);
  }
}

class _FakeListsRepository implements ListsRepository {
  final familyListsResults = <List<FamilyListDto>>[];
  final itemResults = <List<ListItemDto>>[];
  Completer<ListItemDto>? toggleCompleter;

  @override
  Future<ListItemDto> addItem({
    required String clientOperationId,
    required int familyId,
    required int listId,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
  }) async {
    return _item(id: 999, listId: listId, title: title);
  }

  @override
  Future<List<FamilyListDto>> listFamilyLists({required int familyId}) async {
    if (familyListsResults.isEmpty) {
      return const [];
    }
    return familyListsResults.removeAt(0);
  }

  @override
  Future<OperationResult> deleteItem({
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) async {
    return OperationResult(success: true, message: 'Deleted');
  }

  @override
  Future<OperationResult> deleteList({
    required String clientOperationId,
    required int familyId,
    required int listId,
  }) async {
    return OperationResult(success: true, message: 'Deleted');
  }

  @override
  Future<List<ListItemDto>> listItems({
    required int familyId,
    required int listId,
  }) async {
    if (itemResults.isEmpty) {
      return const [];
    }
    return itemResults.removeAt(0);
  }

  @override
  Future<ListItemDto> toggleBought({
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) {
    final completer = toggleCompleter;
    if (completer != null) {
      return completer.future;
    }
    return Future.value(_item(id: itemId, listId: 1, title: 'Updated'));
  }

  @override
  Future<OperationResult> reorderItems({
    required String clientOperationId,
    required int familyId,
    required int listId,
    required List<int> orderedItemIds,
  }) async {
    return OperationResult(success: true, message: 'Reordered');
  }

  @override
  Future<FamilyListDto> upsertList({
    required String clientOperationId,
    int? listId,
    required int familyId,
    required String title,
    required String listType,
  }) async {
    return _list(
      id: listId ?? 1,
      title: title,
      type: listType,
      pendingItemsCount: 0,
    );
  }

  @override
  Future<ListItemDto> updateItem({
    required String clientOperationId,
    required int familyId,
    required int itemId,
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
  }) async {
    return _item(
      id: itemId,
      listId: 1,
      title: title,
    );
  }
}

void main() {
  group('ListsCubit', () {
    test('loads family lists and auto-selects the first list', () async {
      final repository = _FakeListsRepository()
        ..familyListsResults.add([
          _list(id: 1, title: 'Groceries', pendingItemsCount: 2),
          _list(
            id: 2,
            title: 'Birthday',
            type: 'wishlist',
            pendingItemsCount: 1,
          ),
        ])
        ..itemResults.add([
          _item(id: 10, listId: 1, title: 'Milk'),
        ]);
      final familySelectionCubit = _TestFamilySelectionCubit(null);
      final cubit = ListsCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
      );

      await familySelectionCubit.setFamilyId(42);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      expect(cubit.state.lists, hasLength(2));
      expect(cubit.state.selectedListId, 1);
      expect(cubit.state.items.single.title, 'Milk');

      await cubit.close();
      await familySelectionCubit.close();
    });

    test(
      'toggleBought keeps screen loading off and marks only the pending item',
      () async {
        final repository = _FakeListsRepository()
          ..familyListsResults.add([
            _list(id: 1, title: 'Groceries', pendingItemsCount: 1),
          ])
          ..itemResults.add([
            _item(id: 10, listId: 1, title: 'Milk'),
          ]);
        final familySelectionCubit = _TestFamilySelectionCubit(null);
        final cubit = ListsCubit(
          repository: repository,
          familySelectionCubit: familySelectionCubit,
        );

        await familySelectionCubit.setFamilyId(42);
        await Future<void>.delayed(const Duration(milliseconds: 1));

        final toggleCompleter = Completer<ListItemDto>();
        repository.toggleCompleter = toggleCompleter;
        repository.itemResults.add([
          _item(
            id: 10,
            listId: 1,
            title: 'Milk',
            isBought: true,
            boughtByDisplayName: 'Nadia',
          ),
        ]);
        repository.familyListsResults.add([
          _list(id: 1, title: 'Groceries', pendingItemsCount: 0),
        ]);

        final future = cubit.toggleBought(cubit.state.items.single);

        expect(cubit.state.pendingActionItemId, 10);
        expect(cubit.state.isLoading, isFalse);

        toggleCompleter.complete(
          _item(
            id: 10,
            listId: 1,
            title: 'Milk',
            isBought: true,
            boughtByDisplayName: 'Nadia',
          ),
        );
        await future;

        expect(cubit.state.pendingActionItemId, isNull);
        expect(cubit.state.items.single.isBought, isTrue);
        expect(cubit.state.items.single.boughtByDisplayName, 'Nadia');
        expect(cubit.state.lists.single.pendingItemsCount, 0);

        await cubit.close();
        await familySelectionCubit.close();
      },
    );
  });
}

FamilyListDto _list({
  required int id,
  required String title,
  String type = 'shopping',
  int? pendingItemsCount,
}) {
  return FamilyListDto(
    id: id,
    familyId: 42,
    title: title,
    listType: type,
    createdByProfileId: 1,
    pendingItemsCount: pendingItemsCount,
    updatedAt: DateTime.utc(2026, 3, 26, id),
    version: 1,
  );
}

ListItemDto _item({
  required int id,
  required int listId,
  required String title,
  bool isBought = false,
  String? boughtByDisplayName,
}) {
  return ListItemDto(
    id: id,
    listId: listId,
    title: title,
    qty: 1,
    positionIndex: 1,
    isBought: isBought,
    boughtByProfileId: isBought ? 2 : null,
    boughtByDisplayName: boughtByDisplayName,
    boughtAt: isBought ? DateTime.utc(2026, 3, 26, 12) : null,
    updatedAt: DateTime.utc(2026, 3, 26, 12),
    version: 1,
  );
}
