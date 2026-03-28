part of 'lists_service.dart';

Future<ListItemDto> _addItemImpl(
  ListsService service,
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
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
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

    final now = service.clock.nowUtc();
    await session.db.unsafeQuery(
      'SELECT "id" FROM "family_list" WHERE "id" = @listId FOR UPDATE',
      transaction: transaction,
      parameters: QueryParameters.named({'listId': listId}),
    );
    final existingItems = await ListItemRow.db.find(
      session,
      where: (t) => t.listId.equals(listId),
      transaction: transaction,
    );
    final maxPos = existingItems.isEmpty
        ? 0
        : existingItems
              .map((e) => e.positionIndex)
              .reduce((a, b) => a > b ? a : b);
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
      service,
      session,
      itemId: item.id,
      actorProfileId: actorProfileId,
      eventType: 'created',
      transaction: transaction,
    );

    await _emitListChange(
      service,
      session,
      familyId: familyId,
      entityType: 'list_item',
      entityId: item.id,
      transaction: transaction,
    );

    return item;
  });
}

Future<ListItemDto> _updateItemImpl(
  ListsService service,
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
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'lists.updateItem',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    await session.db.unsafeQuery(
      'SELECT "id" FROM "list_item" WHERE "id" = @itemId AND "deletedAt" IS NULL FOR UPDATE',
      transaction: transaction,
      parameters: QueryParameters.named({'itemId': itemId}),
    );
    final currentRow = await ListItemRow.db.findFirstRow(
      session,
      where: (li) => li.id.equals(itemId) & li.deletedAt.equals(null),
      transaction: transaction,
    );
    if (currentRow == null) {
      throw FileNotFoundException(message: 'List item not found.');
    }
    final list = await FamilyListRow.db.findById(
      session,
      currentRow.listId,
      transaction: transaction,
    );
    if (list == null || list.familyId != familyId || list.deletedAt != null) {
      throw FileNotFoundException(message: 'List item not found.');
    }

    if (!isFresh) {
      return _mapItem(
        currentRow,
        boughtByDisplayName: await _buyerDisplayNameForRow(
          service,
          session,
          currentRow,
          transaction: transaction,
        ),
      );
    }

    final updatedRow = await ListItemRow.db.updateRow(
      session,
      currentRow.copyWith(
        title: title,
        qty: qty,
        unit: unit,
        note: note,
        priceCents: priceCents,
        category: category,
        updatedAt: service.clock.nowUtc(),
        version: currentRow.version + 1,
      ),
      transaction: transaction,
    );

    await _appendItemHistory(
      service,
      session,
      itemId: itemId,
      actorProfileId: actorProfileId,
      eventType: 'updated',
      transaction: transaction,
    );
    await _emitListChange(
      service,
      session,
      familyId: familyId,
      entityType: 'list_item',
      entityId: itemId,
      transaction: transaction,
    );

    return _mapItem(
      updatedRow,
      boughtByDisplayName: await _buyerDisplayNameForRow(
        service,
        session,
        updatedRow,
        transaction: transaction,
      ),
    );
  });
}

Future<ListItemDto> _toggleBoughtImpl(
  ListsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required int itemId,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'lists.toggleBought',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    await session.db.unsafeQuery(
      'SELECT "id" FROM "list_item" WHERE "id" = @itemId AND "deletedAt" IS NULL FOR UPDATE',
      transaction: transaction,
      parameters: QueryParameters.named({'itemId': itemId}),
    );
    final currentRow = await ListItemRow.db.findFirstRow(
      session,
      where: (li) => li.id.equals(itemId) & li.deletedAt.equals(null),
      transaction: transaction,
    );
    if (currentRow == null) {
      throw FileNotFoundException(message: 'List item not found.');
    }
    final list = await FamilyListRow.db.findById(
      session,
      currentRow.listId,
      transaction: transaction,
    );
    if (list == null || list.familyId != familyId) {
      throw FileNotFoundException(message: 'List item not found.');
    }

    if (!isFresh) {
      return _mapItem(currentRow);
    }

    final now = service.clock.nowUtc();
    final nextBought = !currentRow.isBought;
    final updatedRow = await ListItemRow.db.updateRow(
      session,
      currentRow.copyWith(
        isBought: nextBought,
        boughtByProfileId: nextBought ? actorProfileId : null,
        boughtAt: nextBought ? now : null,
        updatedAt: now,
        version: currentRow.version + 1,
      ),
      transaction: transaction,
    );

    await _appendItemHistory(
      service,
      session,
      itemId: itemId,
      actorProfileId: actorProfileId,
      eventType: nextBought ? 'bought' : 'unbought',
      transaction: transaction,
    );

    await _emitListChange(
      service,
      session,
      familyId: familyId,
      entityType: 'list_item',
      entityId: itemId,
      transaction: transaction,
    );

    return _mapItem(
      updatedRow,
      boughtByDisplayName: await _buyerDisplayNameForRow(
        service,
        session,
        updatedRow,
        transaction: transaction,
      ),
    );
  });
}

Future<OperationResult> _deleteItemImpl(
  ListsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required int itemId,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'lists.deleteItem',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    final row = await ListItemRow.db.findById(
      session,
      itemId,
      transaction: transaction,
    );
    if (row == null) {
      throw FileNotFoundException(message: 'List item not found.');
    }
    final list = await FamilyListRow.db.findById(
      session,
      row.listId,
      transaction: transaction,
    );
    if (list == null || list.familyId != familyId) {
      throw FileNotFoundException(message: 'List item not found.');
    }
    if (row.deletedAt != null || !isFresh) {
      return OperationResult(success: true, message: 'Already deleted');
    }

    await session.db.unsafeQuery(
      'SELECT "id" FROM "list_item" WHERE "id" = @itemId AND "deletedAt" IS NULL FOR UPDATE',
      transaction: transaction,
      parameters: QueryParameters.named({'itemId': itemId}),
    );
    final currentRow = await ListItemRow.db.findFirstRow(
      session,
      where: (li) => li.id.equals(itemId) & li.deletedAt.equals(null),
      transaction: transaction,
    );
    if (currentRow == null) {
      return OperationResult(success: true, message: 'Already deleted');
    }

    final now = service.clock.nowUtc();
    await ListItemRow.db.updateRow(
      session,
      currentRow.copyWith(
        deletedAt: now,
        updatedAt: now,
        version: currentRow.version + 1,
      ),
      transaction: transaction,
    );
    await _appendItemHistory(
      service,
      session,
      itemId: itemId,
      actorProfileId: actorProfileId,
      eventType: 'deleted',
      transaction: transaction,
    );
    await _emitListChange(
      service,
      session,
      familyId: familyId,
      entityType: 'list_item',
      entityId: itemId,
      operation: 'deleted',
      tombstone: true,
      transaction: transaction,
    );

    return OperationResult(success: true, message: 'Item deleted');
  });
}

Future<OperationResult> _reorderItemsImpl(
  ListsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required int listId,
  required List<int> orderedItemIds,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
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
            updatedAt: service.clock.nowUtc(),
            version: row.version + 1,
          ),
          transaction: transaction,
        );
      }
    }

    await _emitListChange(
      service,
      session,
      familyId: familyId,
      entityType: 'list',
      entityId: listId,
      transaction: transaction,
    );

    return OperationResult(success: true, message: 'Reordered');
  });
}
