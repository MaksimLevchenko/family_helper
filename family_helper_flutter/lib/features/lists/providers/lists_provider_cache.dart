part of 'lists_provider.dart';

Future<void> _restoreListsSnapshot(ListsCubit cubit, int familyId) async {
  final snapshotStore = cubit._snapshotStore;
  if (snapshotStore == null) {
    return;
  }

  try {
    final snapshot = await snapshotStore.read(_listsCacheKey(familyId));
    if (snapshot == null || cubit.isClosed) {
      return;
    }

    final lists = (snapshot.payload['lists'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(FamilyListDto.fromJson)
        .toList();
    final items = (snapshot.payload['items'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ListItemDto.fromJson)
        .toList();
    cubit._emitState(
      cubit.state.copyWith(
        isLoadingLists: false,
        isLoadingItems: false,
        lists: lists,
        selectedListId: snapshot.payload['selectedListId'] as int?,
        items: items,
        isUsingCachedData: true,
        lastSuccessfulSyncAt: snapshot.updatedAt,
        clearError: true,
      ),
    );
  } catch (error, stackTrace) {
    AppErrorLogger.logHandled(
      scope: 'lists.restoreSnapshot',
      error: error,
      stackTrace: stackTrace,
      context: {'familyId': familyId},
    );
  }
}

Future<void> _writeListsSnapshot(
  ListsCubit cubit, {
  required int familyId,
  required List<FamilyListDto> lists,
  required int? selectedListId,
  required List<ListItemDto> items,
  required DateTime syncedAt,
}) async {
  final snapshotStore = cubit._snapshotStore;
  if (snapshotStore == null) {
    return;
  }

  try {
    await snapshotStore.write(_listsCacheKey(familyId), {
      'lists': lists.map((list) => list.toJson()).toList(),
      'selectedListId': selectedListId,
      'items': items.map((item) => item.toJson()).toList(),
    }, updatedAt: syncedAt);
  } catch (error, stackTrace) {
    AppErrorLogger.logHandled(
      scope: 'lists.writeSnapshot',
      error: error,
      stackTrace: stackTrace,
      context: {
        'familyId': familyId,
        'selectedListId': selectedListId,
        'listsCount': lists.length,
        'itemsCount': items.length,
      },
    );
  }
}

String _listsCacheKey(int familyId) => 'lists/family/$familyId';

int? _resolveListsSelectedListId(
  List<FamilyListDto> lists, {
  int? preferredSelectedListId,
  int? currentSelectedListId,
}) {
  if (lists.isEmpty) {
    return null;
  }

  final preferredId = preferredSelectedListId ?? currentSelectedListId;
  if (preferredId != null && lists.any((list) => list.id == preferredId)) {
    return preferredId;
  }
  return lists.first.id;
}
