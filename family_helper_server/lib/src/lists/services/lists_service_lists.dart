part of 'lists_service.dart';

Future<List<FamilyListDto>> _listFamilyListsImpl(
  ListsService service,
  Session session, {
  required int familyId,
}) async {
  await service.rbac.ensureFamilyRole(
    session,
    familyId: familyId,
    minRole: 'member',
  );

  final rows = await FamilyListRow.db.find(
    session,
    where: (t) => t.familyId.equals(familyId) & t.deletedAt.equals(null),
    orderByList: (t) => [
      Order(column: t.updatedAt, orderDescending: true),
      Order(column: t.id, orderDescending: true),
    ],
  );

  final listIds = rows.map((row) => row.id!).toSet();
  final items = listIds.isEmpty
      ? const <ListItemRow>[]
      : await ListItemRow.db.find(
          session,
          where: (t) => t.listId.inSet(listIds) & t.deletedAt.equals(null),
        );
  final pendingItemsByListId = <int, int>{};
  for (final item in items) {
    if (item.isBought) {
      continue;
    }
    pendingItemsByListId.update(
      item.listId,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  return rows
      .map(
        (row) => _mapList(
          row,
          pendingItemsCount: pendingItemsByListId[row.id!] ?? 0,
        ),
      )
      .toList();
}

Future<FamilyListDto> _upsertListImpl(
  ListsService service,
  Session session, {
  required String clientOperationId,
  int? listId,
  required int familyId,
  required String title,
  required String listType,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final profileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'lists.upsertList',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    if (!isFresh && listId != null) {
      return _findList(service, session, listId, transaction: transaction);
    }
    if (!isFresh) {
      final binding = await service.idempotency.getBinding(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.upsertList',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (binding?.resourceType == 'family_list') {
        return _findList(
          service,
          session,
          binding!.resourceId,
          transaction: transaction,
        );
      }
    }

    final now = service.clock.nowUtc();
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
      await service.idempotency.bindResource(
        session,
        actorAuthUserId: authUserId,
        action: 'lists.upsertList',
        clientOperationId: clientOperationId,
        resourceType: 'family_list',
        resourceId: dto.id,
        transaction: transaction,
      );
      await _emitListChange(
        service,
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
    if (row == null) {
      throw FileNotFoundException(message: 'List not found.');
    }
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

    final updated = await _findList(
      service,
      session,
      listId,
      transaction: transaction,
    );
    await _emitListChange(
      service,
      session,
      familyId: familyId,
      entityType: 'list',
      entityId: updated.id,
      transaction: transaction,
    );
    return updated;
  });
}

Future<OperationResult> _deleteListImpl(
  ListsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required int listId,
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
      action: 'lists.deleteList',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    final row = await FamilyListRow.db.findById(
      session,
      listId,
      transaction: transaction,
    );
    if (row == null || row.familyId != familyId) {
      throw FileNotFoundException(message: 'List not found.');
    }
    if (row.deletedAt != null || !isFresh) {
      return OperationResult(success: true, message: 'Already deleted');
    }

    await session.db.unsafeQuery(
      'SELECT "id" FROM "family_list" WHERE "id" = @listId AND "deletedAt" IS NULL FOR UPDATE',
      transaction: transaction,
      parameters: QueryParameters.named({'listId': listId}),
    );
    final currentRow = await FamilyListRow.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(listId) &
          t.familyId.equals(familyId) &
          t.deletedAt.equals(null),
      transaction: transaction,
    );
    if (currentRow == null) {
      return OperationResult(success: true, message: 'Already deleted');
    }

    final now = service.clock.nowUtc();
    await FamilyListRow.db.updateRow(
      session,
      currentRow.copyWith(
        deletedAt: now,
        updatedAt: now,
        version: currentRow.version + 1,
      ),
      transaction: transaction,
    );

    final items = await ListItemRow.db.find(
      session,
      where: (t) => t.listId.equals(listId) & t.deletedAt.equals(null),
      transaction: transaction,
    );
    for (final item in items) {
      await ListItemRow.db.updateRow(
        session,
        item.copyWith(
          deletedAt: now,
          updatedAt: now,
          version: item.version + 1,
        ),
        transaction: transaction,
      );
    }

    await _emitListChange(
      service,
      session,
      familyId: familyId,
      entityType: 'list',
      entityId: listId,
      operation: 'deleted',
      tombstone: true,
      transaction: transaction,
    );

    return OperationResult(success: true, message: 'List deleted');
  });
}

Future<List<ListItemDto>> _listItemsImpl(
  ListsService service,
  Session session, {
  required int familyId,
  required int listId,
}) async {
  await service.rbac.ensureFamilyRole(
    session,
    familyId: familyId,
    minRole: 'member',
  );

  final list = await FamilyListRow.db.findById(session, listId);
  if (list == null || list.familyId != familyId || list.deletedAt != null) {
    return const <ListItemDto>[];
  }

  final rows = await ListItemRow.db.find(
    session,
    where: (li) => li.listId.equals(listId) & li.deletedAt.equals(null),
    orderByList: (li) => [
      Order(column: li.positionIndex),
      Order(column: li.id),
    ],
  );

  final buyerProfileIds = rows
      .map((row) => row.boughtByProfileId)
      .whereType<int>()
      .toSet();
  final profilesById = buyerProfileIds.isEmpty
      ? const <int, AppProfileRow>{}
      : {
          for (final profile in await AppProfileRow.db.find(
            session,
            where: (t) => t.id.inSet(buyerProfileIds),
          ))
            profile.id!: profile,
        };

  return rows
      .map(
        (row) => _mapItem(
          row,
          boughtByDisplayName: row.boughtByProfileId == null
              ? null
              : (profilesById[row.boughtByProfileId!]?.displayName ??
                    'User #${row.boughtByProfileId}'),
        ),
      )
      .toList();
}
