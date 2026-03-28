import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

part 'lists_service_helpers.dart';
part 'lists_service_items.dart';
part 'lists_service_lists.dart';

class ListsService {
  ListsService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
  final ClockService clock;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;

  Future<List<FamilyListDto>> listFamilyLists(
    Session session, {
    required int familyId,
  }) {
    return _listFamilyListsImpl(this, session, familyId: familyId);
  }

  Future<FamilyListDto> upsertList(
    Session session, {
    required String clientOperationId,
    int? listId,
    required int familyId,
    required String title,
    required String listType,
  }) {
    return _upsertListImpl(
      this,
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
    return _addItemImpl(
      this,
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

  Future<ListItemDto> updateItem(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int itemId,
    required String title,
    double qty = 1,
    String? unit,
    String? note,
    int? priceCents,
    String? category,
  }) {
    return _updateItemImpl(
      this,
      session,
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

  Future<ListItemDto> toggleBought(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) {
    return _toggleBoughtImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      itemId: itemId,
    );
  }

  Future<OperationResult> deleteItem(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) {
    return _deleteItemImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      itemId: itemId,
    );
  }

  Future<OperationResult> deleteList(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int listId,
  }) {
    return _deleteListImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      listId: listId,
    );
  }

  Future<OperationResult> reorderItems(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int listId,
    required List<int> orderedItemIds,
  }) {
    return _reorderItemsImpl(
      this,
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
    return _listItemsImpl(this, session, familyId: familyId, listId: listId);
  }
}
