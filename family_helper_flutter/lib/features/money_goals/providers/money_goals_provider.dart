import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_defaults.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/money_goals_repository.dart';

class MoneyGoalsState {
  const MoneyGoalsState({
    required this.isInitialLoading,
    required this.isCreatingGoal,
    required this.isUpdatingGoal,
    required this.isAddingContribution,
    required this.isWithdrawingFunds,
    required this.isArchivingGoal,
    required this.isDeletingGoal,
    required this.isHistoryLoading,
    required this.hasSelectedFamily,
    required this.goals,
    required this.history,
    this.currentGoalId,
    this.error,
  });

  final bool isInitialLoading;
  final bool isCreatingGoal;
  final bool isUpdatingGoal;
  final bool isAddingContribution;
  final bool isWithdrawingFunds;
  final bool isArchivingGoal;
  final bool isDeletingGoal;
  final bool isHistoryLoading;
  final bool hasSelectedFamily;
  final List<MoneyGoalDto> goals;
  final List<MoneyGoalHistoryEntryDto> history;
  final int? currentGoalId;
  final String? error;

  factory MoneyGoalsState.initial({bool hasSelectedFamily = false}) {
    return MoneyGoalsState(
      isInitialLoading: hasSelectedFamily,
      isCreatingGoal: false,
      isUpdatingGoal: false,
      isAddingContribution: false,
      isWithdrawingFunds: false,
      isArchivingGoal: false,
      isDeletingGoal: false,
      isHistoryLoading: false,
      hasSelectedFamily: hasSelectedFamily,
      goals: const [],
      history: const [],
    );
  }

  MoneyGoalsState copyWith({
    bool? isInitialLoading,
    bool? isCreatingGoal,
    bool? isUpdatingGoal,
    bool? isAddingContribution,
    bool? isWithdrawingFunds,
    bool? isArchivingGoal,
    bool? isDeletingGoal,
    bool? isHistoryLoading,
    bool? hasSelectedFamily,
    List<MoneyGoalDto>? goals,
    List<MoneyGoalHistoryEntryDto>? history,
    Object? currentGoalId = _unset,
    Object? error = _unset,
    bool clearError = false,
  }) {
    return MoneyGoalsState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isCreatingGoal: isCreatingGoal ?? this.isCreatingGoal,
      isUpdatingGoal: isUpdatingGoal ?? this.isUpdatingGoal,
      isAddingContribution: isAddingContribution ?? this.isAddingContribution,
      isWithdrawingFunds: isWithdrawingFunds ?? this.isWithdrawingFunds,
      isArchivingGoal: isArchivingGoal ?? this.isArchivingGoal,
      isDeletingGoal: isDeletingGoal ?? this.isDeletingGoal,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      hasSelectedFamily: hasSelectedFamily ?? this.hasSelectedFamily,
      goals: goals ?? this.goals,
      history: history ?? this.history,
      currentGoalId: currentGoalId == _unset
          ? this.currentGoalId
          : currentGoalId as int?,
      error: clearError
          ? null
          : (error == _unset ? this.error : error as String?),
    );
  }

  List<MoneyGoalDto> get activeGoals {
    return goals.where((goal) => goal.archivedAt == null).toList();
  }

  List<MoneyGoalDto> get archivedGoals {
    return goals.where((goal) => goal.archivedAt != null).toList();
  }

  MoneyGoalDto? get selectedGoal {
    final goalId = currentGoalId;
    if (goalId == null) {
      return null;
    }

    for (final goal in goals) {
      if (goal.id == goalId) {
        return goal;
      }
    }
    return null;
  }
}

const _unset = Object();

class MoneyGoalsCubit extends Cubit<MoneyGoalsState> {
  MoneyGoalsCubit({
    required MoneyGoalsRepository repository,
    required FamilySelectionCubit familySelectionCubit,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       super(
         MoneyGoalsState.initial(
           hasSelectedFamily: familySelectionCubit.state != null,
         ),
       ) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });

    if (_familySelectionCubit.state != null) {
      unawaited(_handleFamilyChanged(_familySelectionCubit.state));
    }
  }

  final MoneyGoalsRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  StreamSubscription<int?>? _familySub;
  int _historyRequestId = 0;

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset(hasSelectedFamily: familyId != null);
    if (familyId == null) {
      return;
    }
    await reload();
  }

  void reset({bool hasSelectedFamily = false}) {
    emit(MoneyGoalsState.initial(hasSelectedFamily: hasSelectedFamily));
  }

  void setCurrentGoal(int goalId) {
    if (state.currentGoalId == goalId) {
      return;
    }

    emit(
      state.copyWith(
        currentGoalId: goalId,
        history: const [],
        isHistoryLoading: true,
        clearError: true,
      ),
    );
    unawaited(_loadHistoryForGoal(goalId));
  }

  Future<void> reload() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(MoneyGoalsState.initial());
      return;
    }

    emit(
      state.copyWith(
        hasSelectedFamily: true,
        isInitialLoading: state.goals.isEmpty,
        clearError: true,
      ),
    );

    try {
      final goals = await _repository.listGoals(familyId: familyId);
      final nextState = _buildLoadedState(goals);
      emit(nextState);
      await _loadHistoryForGoal(nextState.currentGoalId);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'moneyGoals.reload',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isInitialLoading: false, error: '$error'));
    }
  }

  Future<bool> createGoal({
    required String title,
    required int targetAmountCents,
    String currency = AppDefaults.defaultCurrency,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return false;
    }

    emit(
      state.copyWith(
        hasSelectedFamily: true,
        isCreatingGoal: true,
        clearError: true,
      ),
    );

    try {
      final goal = await _repository.upsertGoal(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        title: title,
        targetAmountCents: targetAmountCents,
        currency: currency,
      );

      final goals = await _repository.listGoals(familyId: familyId);
      final nextState = _buildLoadedState(goals, preferredGoalId: goal.id);
      emit(nextState);
      await _loadHistoryForGoal(nextState.currentGoalId);
      return true;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'moneyGoals.createGoal',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isCreatingGoal: false, error: '$error'));
      return false;
    }
  }

  Future<bool> updateCurrentGoal({
    required String title,
    required int targetAmountCents,
    String? description,
    DateTime? deadlineAt,
    String currency = AppDefaults.defaultCurrency,
  }) async {
    final familyId = _familySelectionCubit.state;
    final goal = state.selectedGoal;
    if (familyId == null || goal == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }
    if (goal.archivedAt != null) {
      emit(state.copyWith(error: 'Archived goals cannot be edited'));
      return false;
    }

    emit(
      state.copyWith(
        hasSelectedFamily: true,
        isUpdatingGoal: true,
        clearError: true,
      ),
    );

    try {
      final normalizedDescription = description?.trim();
      await _repository.upsertGoal(
        clientOperationId: OperationId.next(),
        goalId: goal.id,
        familyId: familyId,
        title: title,
        description:
            normalizedDescription == null || normalizedDescription.isEmpty
            ? null
            : normalizedDescription,
        targetAmountCents: targetAmountCents,
        currency: currency,
        deadlineAt: deadlineAt,
      );

      final goals = await _repository.listGoals(familyId: familyId);
      final nextState = _buildLoadedState(goals, preferredGoalId: goal.id);
      emit(nextState);
      await _loadHistoryForGoal(nextState.currentGoalId);
      return true;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'moneyGoals.updateGoal',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'goalId': goal.id,
        },
      );
      emit(state.copyWith(isUpdatingGoal: false, error: '$error'));
      return false;
    }
  }

  Future<bool> addContribution({
    required int amountCents,
    String currency = AppDefaults.defaultCurrency,
    String? note,
  }) async {
    return _mutateContribution(
      scope: 'moneyGoals.addContribution',
      startState: state.copyWith(
        isAddingContribution: true,
        clearError: true,
      ),
      call:
          ({
            required int familyId,
            required int goalId,
          }) {
            return _repository.addContribution(
              clientOperationId: OperationId.next(),
              familyId: familyId,
              goalId: goalId,
              amountCents: amountCents,
              currency: currency,
              note: note,
            );
          },
      onError: () => state.copyWith(isAddingContribution: false),
    );
  }

  Future<bool> withdrawFunds({
    required int amountCents,
    String currency = AppDefaults.defaultCurrency,
    String? note,
  }) async {
    return _mutateContribution(
      scope: 'moneyGoals.withdrawFunds',
      startState: state.copyWith(
        isWithdrawingFunds: true,
        clearError: true,
      ),
      call:
          ({
            required int familyId,
            required int goalId,
          }) {
            return _repository.withdrawFunds(
              clientOperationId: OperationId.next(),
              familyId: familyId,
              goalId: goalId,
              amountCents: amountCents,
              currency: currency,
              note: note,
            );
          },
      onError: () => state.copyWith(isWithdrawingFunds: false),
    );
  }

  Future<bool> archiveCurrentGoal() async {
    final familyId = _familySelectionCubit.state;
    final goalId = state.currentGoalId;
    if (familyId == null || goalId == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }

    emit(state.copyWith(isArchivingGoal: true, clearError: true));

    try {
      await _repository.archiveGoal(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        goalId: goalId,
      );

      final goals = await _repository.listGoals(familyId: familyId);
      final nextState = _buildLoadedState(goals, preferredGoalId: goalId);
      emit(nextState);
      await _loadHistoryForGoal(nextState.currentGoalId);
      return true;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'moneyGoals.archiveGoal',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'goalId': goalId,
        },
      );
      emit(state.copyWith(isArchivingGoal: false, error: '$error'));
      return false;
    }
  }

  Future<bool> deleteCurrentGoal() async {
    final familyId = _familySelectionCubit.state;
    final goalId = state.currentGoalId;
    if (familyId == null || goalId == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }

    emit(state.copyWith(isDeletingGoal: true, clearError: true));

    try {
      await _repository.deleteGoal(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        goalId: goalId,
      );

      final goals = await _repository.listGoals(familyId: familyId);
      final nextState = _buildLoadedState(
        goals,
        preferredGoalId: goals.any((goal) => goal.id == goalId) ? goalId : null,
      );
      emit(nextState);
      await _loadHistoryForGoal(nextState.currentGoalId);
      return true;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'moneyGoals.deleteGoal',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'goalId': goalId,
        },
      );
      emit(state.copyWith(isDeletingGoal: false, error: '$error'));
      return false;
    }
  }

  Future<bool> _mutateContribution({
    required String scope,
    required MoneyGoalsState startState,
    required Future<MoneyContributionDto> Function({
      required int familyId,
      required int goalId,
    })
    call,
    required MoneyGoalsState Function() onError,
  }) async {
    final familyId = _familySelectionCubit.state;
    final goalId = state.currentGoalId;
    if (familyId == null || goalId == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }

    emit(startState);

    try {
      await call(familyId: familyId, goalId: goalId);

      final goals = await _repository.listGoals(familyId: familyId);
      final nextState = _buildLoadedState(goals, preferredGoalId: goalId);
      emit(nextState);
      await _loadHistoryForGoal(nextState.currentGoalId);
      return true;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: scope,
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'goalId': goalId,
        },
      );
      emit(onError().copyWith(error: '$error'));
      return false;
    }
  }

  MoneyGoalsState _buildLoadedState(
    List<MoneyGoalDto> goals, {
    int? preferredGoalId,
  }) {
    final selectedGoalId = _resolveCurrentGoalId(
      goals,
      preferredGoalId: preferredGoalId,
    );

    return state.copyWith(
      isInitialLoading: false,
      isCreatingGoal: false,
      isUpdatingGoal: false,
      isAddingContribution: false,
      isWithdrawingFunds: false,
      isArchivingGoal: false,
      isDeletingGoal: false,
      isHistoryLoading: selectedGoalId != null,
      hasSelectedFamily: true,
      goals: goals,
      history: selectedGoalId == state.currentGoalId ? state.history : const [],
      currentGoalId: selectedGoalId,
      clearError: true,
    );
  }

  int? _resolveCurrentGoalId(
    List<MoneyGoalDto> goals, {
    int? preferredGoalId,
  }) {
    if (goals.isEmpty) {
      return null;
    }

    if (preferredGoalId != null &&
        goals.any((goal) => goal.id == preferredGoalId)) {
      return preferredGoalId;
    }

    final currentGoalId = state.currentGoalId;
    if (currentGoalId != null &&
        goals.any((goal) => goal.id == currentGoalId)) {
      return currentGoalId;
    }

    return goals.first.id;
  }

  Future<void> _loadHistoryForGoal(int? goalId) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null || goalId == null) {
      ++_historyRequestId;
      emit(
        state.copyWith(
          history: const [],
          isHistoryLoading: false,
        ),
      );
      return;
    }

    final requestId = ++_historyRequestId;
    if (!state.isHistoryLoading || state.currentGoalId != goalId) {
      emit(
        state.copyWith(
          currentGoalId: goalId,
          history: const [],
          isHistoryLoading: true,
          clearError: true,
        ),
      );
    }

    try {
      final history = await _repository.listGoalHistory(
        familyId: familyId,
        goalId: goalId,
      );

      if (isClosed ||
          requestId != _historyRequestId ||
          state.currentGoalId != goalId) {
        return;
      }

      emit(
        state.copyWith(
          history: history,
          isHistoryLoading: false,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'moneyGoals.listGoalHistory',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'goalId': goalId,
        },
      );

      if (isClosed ||
          requestId != _historyRequestId ||
          state.currentGoalId != goalId) {
        return;
      }

      emit(
        state.copyWith(
          history: const [],
          isHistoryLoading: false,
          error: '$error',
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
