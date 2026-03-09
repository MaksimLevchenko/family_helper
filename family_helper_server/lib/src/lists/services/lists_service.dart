import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class ListsService {
  ListsService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;

  Future<FamilyListDto> upsertList(
    Session session, {
    required String clientOperationId,
    int? listId,
    required int familyId,
    required String title,
    required String listType,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.upsertList',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh && listId != null) {
        return _findList(session, listId, transaction: transaction);
      }

      final now = DateTime.now().toUtc();
      if (listId == null) {
        final inserted = await FamilyListRow.db.insertRow(
          session,
          FamilyListRow(
            familyId: familyId,
            title: title,
            listType: listType,
            createdByProfileId: profileId,
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
            version: 1,
          ),
          transaction: transaction,
        );
        final dto = _mapList(inserted);
        await _emitListChange(
          session,
          familyId: familyId,
          entityType: 'list',
          entityId: dto.id,
          transaction: transaction,
        );
        return dto;
      }

      final row = await FamilyListRow.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(listId) &
            t.familyId.equals(familyId) &
            t.deletedAt.equals(null),
        transaction: transaction,
      );
      if (row == null) throw Exception('List not found');
      await FamilyListRow.db.updateRow(
        session,
        row.copyWith(
          title: title,
          listType: listType,
          updatedAt: now,
          version: row.version + 1,
        ),
        transaction: transaction,
      );

      final updated = await _findList(session, listId, transaction: transaction);
      await _emitListChange(
        session,
        familyId: familyId,
        entityType: 'list',
        entityId: updated.id,
        transaction: transaction,
      );
      return updated;
    });
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
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.addItem',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        final latest = await ListItemRow.db.findFirstRow(
          session,
          where: (t) => t.listId.equals(listId) & t.deletedAt.equals(null),
          orderBy: (t) => t.id,
          orderDescending: true,
          transaction: transaction,
        );
        if (latest != null) {
          return _mapItem(latest);
        }
      }

      final now = DateTime.now().toUtc();
      final existingItems = await ListItemRow.db.find(
        session,
        where: (t) => t.listId.equals(listId),
        transaction: transaction,
      );
      final maxPos = existingItems.isEmpty
          ? 0
          : existingItems.map((e) => e.positionIndex).reduce((a, b) => a > b ? a : b);
      final nextPosition = maxPos + 1;

      final inserted = await ListItemRow.db.insertRow(
        session,
        ListItemRow(
          listId: listId,
          title: title,
          qty: qty,
          unit: unit,
          note: note,
          priceCents: priceCents,
          category: category,
          positionIndex: nextPosition,
          isBought: false,
          boughtByProfileId: null,
          boughtAt: null,
          createdByProfileId: actorProfileId,
          createdAt: now,
          updatedAt: now,
          deletedAt: null,
          version: 1,
        ),
        transaction: transaction,
      );

      final item = _mapItem(inserted);
      await _appendItemHistory(
        session,
        itemId: item.id,
        actorProfileId: actorProfileId,
        eventType: 'created',
        transaction: transaction,
      );

      await _emitListChange(
        session,
        familyId: familyId,
        entityType: 'list_item',
        entityId: item.id,
        transaction: transaction,
      );

      return item;
    });
  }

  Future<ListItemDto> toggleBought(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int itemId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.toggleBought',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final currentRow = await ListItemRow.db.findFirstRow(
        session,
        where: (li) => li.id.equals(itemId) & li.deletedAt.equals(null),
        transaction: transaction,
      );
      if (currentRow == null) {
        throw Exception('List item not found');
      }
      final list = await FamilyListRow.db.findById(
        session,
        currentRow.listId,
        transaction: transaction,
      );
      if (list == null || list.familyId != familyId) {
        throw Exception('List item not found');
      }

      final current = currentRow;
      if (!isFresh) {
        return _mapItem(currentRow);
      }

      final now = DateTime.now().toUtc();
      final nextBought = !current.isBought;
      final updatedRow = await ListItemRow.db.updateRow(
        session,
        current.copyWith(
          isBought: nextBought,
          boughtByProfileId: nextBought ? actorProfileId : null,
          boughtAt: nextBought ? now : null,
          updatedAt: now,
          version: current.version + 1,
        ),
        transaction: transaction,
      );

      await _appendItemHistory(
        session,
        itemId: itemId,
        actorProfileId: actorProfileId,
        eventType: nextBought ? 'bought' : 'unbought',
        transaction: transaction,
      );

      await _emitListChange(
        session,
        familyId: familyId,
        entityType: 'list_item',
        entityId: itemId,
        transaction: transaction,
      );

      return _mapItem(updatedRow);
    });
  }

  Future<OperationResult> reorderItems(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int listId,
    required List<int> orderedItemIds,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.reorderItems',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        return OperationResult(success: true, message: 'Already processed');
      }

      for (int i = 0; i < orderedItemIds.length; i++) {
        final row = await ListItemRow.db.findFirstRow(
          session,
          where: (t) =>
              t.id.equals(orderedItemIds[i]) &
              t.listId.equals(listId) &
              t.deletedAt.equals(null),
          transaction: transaction,
        );
        if (row != null) {
          await ListItemRow.db.updateRow(
            session,
            row.copyWith(
              positionIndex: i + 1,
              updatedAt: DateTime.now().toUtc(),
              version: row.version + 1,
            ),
            transaction: transaction,
          );
        }
      }

      await _emitListChange(
        session,
        familyId: familyId,
        entityType: 'list',
        entityId: listId,
        transaction: transaction,
      );

      return OperationResult(success: true, message: 'Reordered');
    });
  }

  Future<List<ListItemDto>> listItems(
    Session session, {
    required int familyId,
    required int listId,
  }) async {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');

    final list = await FamilyListRow.db.findById(session, listId);
    if (list == null || list.familyId != familyId) return const <ListItemDto>[];

    final rows = await ListItemRow.db.find(
      session,
      where: (li) => li.listId.equals(listId) & li.deletedAt.equals(null),
      orderByList: (li) => [
        Order(column: li.positionIndex),
        Order(column: li.id),
      ],
    );

    return rows.map(_mapItem).toList();
  }

  Future<FamilyListDto> _findList(
    Session session,
    int listId, {
    Transaction? transaction,
  }) async {
    final row = await FamilyListRow.db.findById(
      session,
      listId,
      transaction: transaction,
    );

    return _mapList(row!);
  }

  Future<void> _appendItemHistory(
    Session session, {
    required int itemId,
    required int actorProfileId,
    required String eventType,
    Transaction? transaction,
  }) async {
    await ListItemHistoryRow.db.insertRow(
      session,
      ListItemHistoryRow(
        itemId: itemId,
        actorProfileId: actorProfileId,
        eventType: eventType,
        createdAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  Future<void> _emitListChange(
    Session session, {
    required int familyId,
    required String entityType,
    required int entityId,
    Transaction? transaction,
  }) async {
    await changeFeed.appendChange(
      session,
      feature: 'lists',
      entityType: entityType,
      entityId: entityId,
      operation: 'upserted',
      familyId: familyId,
      version: 1,
      transaction: transaction,
    );

    await realtime.publish(
      session,
      familyId: familyId,
      event: FamilyRealtimeEvent(
        familyId: familyId,
        feature: 'lists',
        entityType: entityType,
        entityId: entityId,
        eventType: 'lists.updated',
        changedAt: DateTime.now().toUtc(),
      ),
    );
  }

  FamilyListDto _mapList(FamilyListRow row) {
    return FamilyListDto(
      id: row.id!,
      familyId: row.familyId,
      title: row.title,
      listType: row.listType,
      createdByProfileId: row.createdByProfileId,
      updatedAt: row.updatedAt,
      version: row.version,
    );
  }

  ListItemDto _mapItem(ListItemRow row) {
    return ListItemDto(
      id: row.id!,
      listId: row.listId,
      title: row.title,
      qty: row.qty,
      unit: row.unit,
      note: row.note,
      priceCents: row.priceCents,
      category: row.category,
      positionIndex: row.positionIndex,
      isBought: row.isBought,
      boughtByProfileId: row.boughtByProfileId,
      boughtAt: row.boughtAt,
      updatedAt: row.updatedAt,
      version: row.version,
    );
  }
}


