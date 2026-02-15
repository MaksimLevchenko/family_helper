import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/lists_service.dart';

class ListsEndpoint extends Endpoint {
  ListsEndpoint({ListsService? service}) : service = service ?? ListsService();

  final ListsService service;

  Future<FamilyListDto> upsertList(
    Session session, {
    required String clientOperationId,
    int? listId,
    required int familyId,
    required String title,
    required String listType,
  }) {
    return service.upsertList(
      session,
      clientOperationId: clientOperationId,
      listId: listId,
      familyId: familyId,
      title: title,
      listType: listType,
    );
  }

  Future<ListItemDto> addItem(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int listId,
    required String title,
    double qty = 1,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
  }) {
    return service.addItem(
      session,
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

  Future<ListItemDto> toggleBought(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) {
    return service.toggleBought(
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      itemId: itemId,
    );
  }

  Future<OperationResult> reorderItems(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int listId,
    required List<int> orderedItemIds,
  }) {
    return service.reorderItems(
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      listId: listId,
      orderedItemIds: orderedItemIds,
    );
  }

  Future<List<ListItemDto>> listItems(
    Session session, {
    required int familyId,
    required int listId,
  }) {
    return service.listItems(session, familyId: familyId, listId: listId);
  }
}
