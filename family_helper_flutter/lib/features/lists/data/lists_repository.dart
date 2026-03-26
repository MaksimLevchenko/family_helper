import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class ListsRepository {
  const ListsRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<List<FamilyListDto>> listFamilyLists({
    required int familyId,
  }) {
    return _apiClient.client.lists.listFamilyLists(familyId: familyId);
  }

  Future<FamilyListDto> upsertList({
    required String clientOperationId,
    int? listId,
    required int familyId,
    required String title,
    required String listType,
  }) {
    return _apiClient.client.lists.upsertList(
      clientOperationId: clientOperationId,
      listId: listId,
      familyId: familyId,
      title: title,
      listType: listType,
    );
  }

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
  }) {
    return _apiClient.client.lists.addItem(
      clientOperationId: clientOperationId,
      familyId: familyId,
      listId: listId,
      title: title,
      qty: qty,
      unit: unit,
      note: note,
      priceCents: priceCents,
      category: category,
    );
  }

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
  }) {
    return _apiClient.client.lists.updateItem(
      clientOperationId: clientOperationId,
      familyId: familyId,
      itemId: itemId,
      title: title,
      qty: qty,
      unit: unit,
      note: note,
      priceCents: priceCents,
      category: category,
    );
  }

  Future<ListItemDto> toggleBought({
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) {
    return _apiClient.client.lists.toggleBought(
      clientOperationId: clientOperationId,
      familyId: familyId,
      itemId: itemId,
    );
  }

  Future<OperationResult> deleteItem({
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) {
    return _apiClient.client.lists.deleteItem(
      clientOperationId: clientOperationId,
      familyId: familyId,
      itemId: itemId,
    );
  }

  Future<OperationResult> deleteList({
    required String clientOperationId,
    required int familyId,
    required int listId,
  }) {
    return _apiClient.client.lists.deleteList(
      clientOperationId: clientOperationId,
      familyId: familyId,
      listId: listId,
    );
  }

  Future<OperationResult> reorderItems({
    required String clientOperationId,
    required int familyId,
    required int listId,
    required List<int> orderedItemIds,
  }) {
    return _apiClient.client.lists.reorderItems(
      clientOperationId: clientOperationId,
      familyId: familyId,
      listId: listId,
      orderedItemIds: orderedItemIds,
    );
  }

  Future<List<ListItemDto>> listItems({
    required int familyId,
    required int listId,
  }) {
    return _apiClient.client.lists.listItems(
      familyId: familyId,
      listId: listId,
    );
  }
}
