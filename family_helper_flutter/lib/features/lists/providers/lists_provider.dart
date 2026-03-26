import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_snapshot_store.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/lists_repository.dart';

class ListsState {
  const ListsState({
    required this.isLoadingLists,
    required this.isLoadingItems,
    required this.lists,
    required this.items,
    this.selectedListId,
    this.pendingActionItemId,
    this.isUsingCachedData = false,
    this.lastSuccessfulSyncAt,
    this.error,
  });

  final bool isLoadingLists;
  final bool isLoadingItems;
  final List<FamilyListDto> lists;
  final List<ListItemDto> items;
  final int? selectedListId;
  final int? pendingActionItemId;
  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
  final String? error;

  factory ListsState.initial() {
    return const ListsState(
      isLoadingLists: false,
      isLoadingItems: false,
      lists: [],
      items: [],
    );
  }

  bool get isLoading => isLoadingLists || isLoadingItems;

  FamilyListDto? get selectedList {
    final selectedListId = this.selectedListId;
    if (selectedListId == null) {
      return null;
    }
    for (final list in lists) {
      if (list.id == selectedListId) {
        return list;
      }
    }
    return null;
  }

  ListsState copyWith({
    bool? isLoadingLists,
    bool? isLoadingItems,
    List<FamilyListDto>? lists,
    List<ListItemDto>? items,
    int? selectedListId,
    int? pendingActionItemId,
    bool? isUsingCachedData,
    DateTime? lastSuccessfulSyncAt,
    String? error,
    bool clearError = false,
    bool clearSelectedList = false,
    bool clearPendingActionItem = false,
    bool clearLastSuccessfulSyncAt = false,
  }) {
    return ListsState(
      isLoadingLists: isLoadingLists ?? this.isLoadingLists,
      isLoadingItems: isLoadingItems ?? this.isLoadingItems,
      lists: lists ?? this.lists,
      items: items ?? this.items,
      selectedListId: clearSelectedList
          ? null
          : (selectedListId ?? this.selectedListId),
      pendingActionItemId: clearPendingActionItem
          ? null
          : (pendingActionItemId ?? this.pendingActionItemId),
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      lastSuccessfulSyncAt: clearLastSuccessfulSyncAt
          ? null
          : (lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ListsCubit extends Cubit<ListsState> {
  ListsCubit({
    required ListsRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    OfflineSnapshotStore? snapshotStore,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _snapshotStore = snapshotStore,
       super(ListsState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
    if (_familySelectionCubit.state != null) {
      unawaited(_handleFamilyChanged(_familySelectionCubit.state));
    }
  }

  final ListsRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final OfflineSnapshotStore? _snapshotStore;
  StreamSubscription<int?>? _familySub;

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset();
    if (familyId == null) {
      return;
    }
    await _restoreSnapshot(familyId);
    await loadLists();
  }

  void reset() {
    emit(ListsState.initial());
  }

  void setCurrentList(int listId) {
    unawaited(selectList(listId));
  }

  Future<void> selectList(int listId) async {
    if (state.selectedListId == listId && state.items.isNotEmpty) {
      return;
    }

    emit(
      state.copyWith(
        selectedListId: listId,
        items: const [],
        clearError: true,
        clearPendingActionItem: true,
      ),
    );
    await loadItemsForSelectedList();
  }

  Future<void> reload() async {
    await loadLists();
  }

  Future<void> loadLists({
    int? preferredSelectedListId,
    bool loadSelectedItems = true,
    bool showLoading = true,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(
        state.copyWith(
          isLoadingLists: false,
          isLoadingItems: false,
          lists: const [],
          items: const [],
          clearSelectedList: true,
          clearPendingActionItem: true,
        ),
      );
      return;
    }

    if (showLoading) {
      emit(
        state.copyWith(
          isLoadingLists: true,
          clearError: true,
          clearPendingActionItem: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          clearError: true,
          clearPendingActionItem: true,
        ),
      );
    }

    try {
      final lists = await _repository.listFamilyLists(familyId: familyId);
      final nextSelectedListId = _resolveSelectedListId(
        lists,
        preferredSelectedListId: preferredSelectedListId,
      );

      final syncedAt = DateTime.now().toUtc();
      if (nextSelectedListId == null) {
        await _writeSnapshot(
          familyId: familyId,
          lists: lists,
          selectedListId: null,
          items: const [],
          syncedAt: syncedAt,
        );
        emit(
          state.copyWith(
            isLoadingLists: false,
            isLoadingItems: false,
            lists: lists,
            items: const [],
            clearSelectedList: true,
            isUsingCachedData: false,
            lastSuccessfulSyncAt: syncedAt,
            clearError: true,
            clearPendingActionItem: true,
          ),
        );
        return;
      }

      final shouldShowItemsLoading =
          state.selectedListId != nextSelectedListId || state.items.isEmpty;
      emit(
        state.copyWith(
          isLoadingLists: false,
          lists: lists,
          selectedListId: nextSelectedListId,
          items: shouldShowItemsLoading ? const [] : state.items,
          clearError: true,
          clearPendingActionItem: true,
        ),
      );
      if (loadSelectedItems) {
        await loadItemsForSelectedList(showLoading: shouldShowItemsLoading);
      } else {
        await _writeSnapshot(
          familyId: familyId,
          lists: lists,
          selectedListId: nextSelectedListId,
          items: state.items,
          syncedAt: syncedAt,
        );
        emit(
          state.copyWith(
            isUsingCachedData: false,
            lastSuccessfulSyncAt: syncedAt,
            clearError: true,
          ),
        );
      }
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.loadLists',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'selectedListId': state.selectedListId,
        },
      );
      emit(
        state.copyWith(
          isLoadingLists: false,
          isUsingCachedData: state.lists.isNotEmpty || state.items.isNotEmpty,
          error: '$error',
        ),
      );
    }
  }

  Future<void> loadItemsForSelectedList({bool showLoading = true}) async {
    final familyId = _familySelectionCubit.state;
    final listId = state.selectedListId;
    if (familyId == null || listId == null) {
      emit(
        state.copyWith(
          isLoadingItems: false,
          items: const [],
          clearPendingActionItem: true,
        ),
      );
      return;
    }

    if (showLoading) {
      emit(
        state.copyWith(
          isLoadingItems: true,
          clearError: true,
        ),
      );
    } else {
      emit(state.copyWith(clearError: true));
    }

    try {
      final items = await _repository.listItems(
        familyId: familyId,
        listId: listId,
      );
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(
        familyId: familyId,
        lists: state.lists,
        selectedListId: listId,
        items: items,
        syncedAt: syncedAt,
      );
      emit(
        state.copyWith(
          isLoadingItems: false,
          items: items,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
          clearPendingActionItem: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.loadItemsForSelectedList',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
        },
      );
      emit(
        state.copyWith(
          isLoadingItems: false,
          isUsingCachedData: state.lists.isNotEmpty || state.items.isNotEmpty,
          error: '$error',
          clearPendingActionItem: true,
        ),
      );
    }
  }

  Future<void> createList(
    String title, {
    String listType = AppDefaults.defaultListType,
  }) async {
    final familyId = _familySelectionCubit.state;
    final normalizedTitle = title.trim();
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }
    if (normalizedTitle.isEmpty) {
      emit(state.copyWith(error: 'List title cannot be empty'));
      return;
    }

    emit(state.copyWith(isLoadingLists: true, clearError: true));

    try {
      final list = await _repository.upsertList(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        title: normalizedTitle,
        listType: listType,
      );
      await loadLists(
        preferredSelectedListId: list.id,
        showLoading: false,
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.createList',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isLoadingLists: false, error: '$error'));
    }
  }

  Future<void> updateSelectedList({
    required String title,
    required String listType,
  }) async {
    final familyId = _familySelectionCubit.state;
    final listId = state.selectedListId;
    final normalizedTitle = title.trim();
    if (familyId == null || listId == null) {
      emit(state.copyWith(error: 'Family/list is not selected'));
      return;
    }
    if (normalizedTitle.isEmpty) {
      emit(state.copyWith(error: 'List title cannot be empty'));
      return;
    }

    emit(state.copyWith(isLoadingLists: true, clearError: true));

    try {
      await _repository.upsertList(
        clientOperationId: OperationId.next(),
        listId: listId,
        familyId: familyId,
        title: normalizedTitle,
        listType: listType,
      );
      await loadLists(
        preferredSelectedListId: listId,
        showLoading: false,
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.updateSelectedList',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
        },
      );
      emit(state.copyWith(isLoadingLists: false, error: '$error'));
    }
  }

  Future<void> deleteSelectedList() async {
    final familyId = _familySelectionCubit.state;
    final listId = state.selectedListId;
    if (familyId == null || listId == null) {
      emit(state.copyWith(error: 'Family/list is not selected'));
      return;
    }

    emit(state.copyWith(isLoadingLists: true, clearError: true));

    try {
      await _repository.deleteList(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        listId: listId,
      );
      await loadLists(showLoading: false);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.deleteSelectedList',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
        },
      );
      emit(state.copyWith(isLoadingLists: false, error: '$error'));
    }
  }

  Future<void> addItem({
    required String title,
    double qty = 1,
    String? unit,
    String? note,
    int? priceCents,
  }) async {
    final familyId = _familySelectionCubit.state;
    final listId = state.selectedListId;
    final normalizedTitle = title.trim();
    if (familyId == null || listId == null) {
      emit(state.copyWith(error: 'Family/list is not selected'));
      return;
    }
    if (normalizedTitle.isEmpty) {
      emit(state.copyWith(error: 'Item title cannot be empty'));
      return;
    }

    emit(state.copyWith(isLoadingItems: true, clearError: true));

    try {
      await _repository.addItem(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        listId: listId,
        title: normalizedTitle,
        qty: qty,
        unit: unit,
        note: note,
        priceCents: priceCents,
      );
      await loadLists(
        preferredSelectedListId: listId,
        showLoading: false,
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.addItem',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
        },
      );
      emit(state.copyWith(isLoadingItems: false, error: '$error'));
    }
  }

  Future<void> updateItem(
    ListItemDto item, {
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
  }) async {
    final familyId = _familySelectionCubit.state;
    final listId = state.selectedListId;
    final normalizedTitle = title.trim();
    if (familyId == null || listId == null) {
      emit(state.copyWith(error: 'Family/list is not selected'));
      return;
    }
    if (normalizedTitle.isEmpty) {
      emit(state.copyWith(error: 'Item title cannot be empty'));
      return;
    }

    emit(
      state.copyWith(
        pendingActionItemId: item.id,
        clearError: true,
      ),
    );

    try {
      await _repository.updateItem(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        itemId: item.id,
        title: normalizedTitle,
        qty: qty,
        unit: unit,
        note: note,
        priceCents: priceCents,
      );
      await loadItemsForSelectedList(showLoading: false);
      await loadLists(
        preferredSelectedListId: listId,
        loadSelectedItems: false,
        showLoading: false,
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.updateItem',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
          'itemId': item.id,
        },
      );
      emit(
        state.copyWith(
          error: '$error',
          clearPendingActionItem: true,
        ),
      );
    }
  }

  Future<void> toggleBought(ListItemDto item) async {
    final familyId = _familySelectionCubit.state;
    final listId = state.selectedListId;
    if (familyId == null || listId == null) {
      emit(state.copyWith(error: 'Family/list is not selected'));
      return;
    }

    emit(
      state.copyWith(
        pendingActionItemId: item.id,
        clearError: true,
      ),
    );

    try {
      await _repository.toggleBought(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        itemId: item.id,
      );
      await loadItemsForSelectedList(showLoading: false);
      await loadLists(
        preferredSelectedListId: listId,
        loadSelectedItems: false,
        showLoading: false,
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.toggleBought',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
          'itemId': item.id,
        },
      );
      emit(
        state.copyWith(
          error: '$error',
          clearPendingActionItem: true,
        ),
      );
    }
  }

  Future<void> deleteItem(ListItemDto item) async {
    final familyId = _familySelectionCubit.state;
    final listId = state.selectedListId;
    if (familyId == null || listId == null) {
      emit(state.copyWith(error: 'Family/list is not selected'));
      return;
    }

    emit(
      state.copyWith(
        pendingActionItemId: item.id,
        clearError: true,
      ),
    );

    try {
      await _repository.deleteItem(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        itemId: item.id,
      );
      await loadLists(
        preferredSelectedListId: listId,
        showLoading: false,
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.deleteItem',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
          'itemId': item.id,
        },
      );
      emit(
        state.copyWith(
          error: '$error',
          clearPendingActionItem: true,
        ),
      );
    }
  }

  Future<void> reorderDescending() async {
    final familyId = _familySelectionCubit.state;
    final listId = state.selectedListId;
    if (familyId == null || listId == null || state.items.isEmpty) {
      return;
    }

    emit(state.copyWith(isLoadingItems: true, clearError: true));

    try {
      final orderedIds = state.items
          .map((e) => e.id)
          .toList()
          .reversed
          .toList();
      await _repository.reorderItems(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        listId: listId,
        orderedItemIds: orderedIds,
      );

      await loadItemsForSelectedList(showLoading: false);
      emit(state.copyWith(isLoadingItems: false, clearError: true));
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.reorderDescending',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
          'itemsCount': state.items.length,
        },
      );
      emit(state.copyWith(isLoadingItems: false, error: '$error'));
    }
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }

  Future<void> _restoreSnapshot(int familyId) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      final snapshot = await snapshotStore.read(_cacheKey(familyId));
      if (snapshot == null || isClosed) {
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
      emit(
        state.copyWith(
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

  Future<void> _writeSnapshot({
    required int familyId,
    required List<FamilyListDto> lists,
    required int? selectedListId,
    required List<ListItemDto> items,
    required DateTime syncedAt,
  }) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      await snapshotStore.write(_cacheKey(familyId), {
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

  String _cacheKey(int familyId) => 'lists/family/$familyId';

  int? _resolveSelectedListId(
    List<FamilyListDto> lists, {
    int? preferredSelectedListId,
  }) {
    if (lists.isEmpty) {
      return null;
    }

    final preferredId = preferredSelectedListId ?? state.selectedListId;
    if (preferredId != null && lists.any((list) => list.id == preferredId)) {
      return preferredId;
    }
    return lists.first.id;
  }
}
