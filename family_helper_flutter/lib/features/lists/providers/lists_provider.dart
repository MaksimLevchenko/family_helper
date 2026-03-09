import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/lists_repository.dart';

class ListsState {
  const ListsState({
    required this.isLoading,
    required this.items,
    this.currentListId,
    this.error,
  });

  final bool isLoading;
  final List<ListItemDto> items;
  final int? currentListId;
  final String? error;

  factory ListsState.initial() {
    return const ListsState(isLoading: false, items: []);
  }

  ListsState copyWith({
    bool? isLoading,
    List<ListItemDto>? items,
    int? currentListId,
    String? error,
    bool clearError = false,
  }) {
    return ListsState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      currentListId: currentListId ?? this.currentListId,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ListsCubit extends Cubit<ListsState> {
  ListsCubit({
    required ListsRepository repository,
    required FamilySelectionCubit familySelectionCubit,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       super(ListsState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
  }

  final ListsRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  StreamSubscription<int?>? _familySub;

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset();
    if (familyId == null || state.currentListId == null) {
      return;
    }
    await reload();
  }

  void reset() {
    emit(ListsState.initial());
  }

  void setCurrentList(int listId) {
    emit(state.copyWith(currentListId: listId, clearError: true));
    unawaited(reload());
  }

  Future<void> reload() async {
    final familyId = _familySelectionCubit.state;
    final listId = state.currentListId;
    if (familyId == null || listId == null) {
      emit(state.copyWith(isLoading: false, items: const []));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final items = await _repository.listItems(
        familyId: familyId,
        listId: listId,
      );
      emit(
        state.copyWith(
          isLoading: false,
          items: items,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.reload',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'listId': listId,
        },
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> createList(
    String title, {
    String listType = AppDefaults.defaultListType,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final list = await _repository.upsertList(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        title: title,
        listType: listType,
      );

      final items = await _repository.listItems(
        familyId: familyId,
        listId: list.id,
      );
      emit(
        state.copyWith(
          isLoading: false,
          currentListId: list.id,
          items: items,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'lists.createList',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> addItem({
    required String title,
    double qty = 1,
    String? unit,
    int? priceCents,
  }) async {
    final familyId = _familySelectionCubit.state;
    final listId = state.currentListId;
    if (familyId == null || listId == null) {
      emit(state.copyWith(error: 'Family/list is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _repository.addItem(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        listId: listId,
        title: title,
        qty: qty,
        unit: unit,
        priceCents: priceCents,
      );

      await reload();
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
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> toggleBought(ListItemDto item) async {
    final familyId = _familySelectionCubit.state;
    final listId = state.currentListId;
    if (familyId == null || listId == null) {
      emit(state.copyWith(error: 'Family/list is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _repository.toggleBought(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        itemId: item.id,
      );

      await reload();
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
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> reorderDescending() async {
    final familyId = _familySelectionCubit.state;
    final listId = state.currentListId;
    if (familyId == null || listId == null || state.items.isEmpty) {
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

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

      await reload();
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
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
