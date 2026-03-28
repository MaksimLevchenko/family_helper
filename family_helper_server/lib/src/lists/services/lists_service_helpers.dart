part of 'lists_service.dart';

Future<FamilyListDto> _findList(
  ListsService service,
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
  ListsService service,
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
      createdAt: service.clock.nowUtc(),
    ),
    transaction: transaction,
  );
}

Future<void> _emitListChange(
  ListsService service,
  Session session, {
  required int familyId,
  required String entityType,
  required int entityId,
  String operation = 'upserted',
  bool tombstone = false,
  Transaction? transaction,
}) async {
  await service.changeFeed.appendChange(
    session,
    feature: 'lists',
    entityType: entityType,
    entityId: entityId,
    operation: operation,
    familyId: familyId,
    version: 1,
    tombstone: tombstone,
    transaction: transaction,
  );

  await service.realtime.publish(
    session,
    familyId: familyId,
    event: FamilyRealtimeEvent(
      familyId: familyId,
      feature: 'lists',
      entityType: entityType,
      entityId: entityId,
      eventType: operation == 'deleted' ? 'lists.deleted' : 'lists.updated',
      changedAt: service.clock.nowUtc(),
    ),
  );
}

Future<String?> _buyerDisplayNameForRow(
  ListsService service,
  Session session,
  ListItemRow row, {
  Transaction? transaction,
}) async {
  final buyerProfileId = row.boughtByProfileId;
  if (buyerProfileId == null) {
    return null;
  }

  final profile = await AppProfileRow.db.findById(
    session,
    buyerProfileId,
    transaction: transaction,
  );
  return profile?.displayName ?? 'User #$buyerProfileId';
}

FamilyListDto _mapList(
  FamilyListRow row, {
  int? pendingItemsCount,
}) {
  return FamilyListDto(
    id: row.id!,
    familyId: row.familyId,
    title: row.title,
    listType: row.listType,
    createdByProfileId: row.createdByProfileId,
    pendingItemsCount: pendingItemsCount,
    updatedAt: row.updatedAt,
    version: row.version,
  );
}

ListItemDto _mapItem(
  ListItemRow row, {
  String? boughtByDisplayName,
}) {
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
    boughtByDisplayName: boughtByDisplayName,
    boughtAt: row.boughtAt,
    updatedAt: row.updatedAt,
    version: row.version,
  );
}
