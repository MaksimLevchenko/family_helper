import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/money_goals_repository.dart';

class MoneyGoalsState {
  const MoneyGoalsState({
    required this.isLoading,
    required this.goals,
    this.currentGoalId,
    this.error,
  });

  final bool isLoading;
  final List<MoneyGoalDto> goals;
  final int? currentGoalId;
  final String? error;

  factory MoneyGoalsState.initial() {
    return const MoneyGoalsState(isLoading: false, goals: []);
  }

  MoneyGoalsState copyWith({
    bool? isLoading,
    List<MoneyGoalDto>? goals,
    int? currentGoalId,
    String? error,
    bool clearError = false,
  }) {
    return MoneyGoalsState(
      isLoading: isLoading ?? this.isLoading,
      goals: goals ?? this.goals,
      currentGoalId: currentGoalId ?? this.currentGoalId,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MoneyGoalsCubit extends Cubit<MoneyGoalsState> {
  MoneyGoalsCubit({
    required MoneyGoalsRepository repository,
    required FamilySelectionCubit familySelectionCubit,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       super(MoneyGoalsState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((_) {
      emit(const MoneyGoalsState(isLoading: false, goals: []));
      unawaited(reload());
    });
    unawaited(reload());
  }

  final MoneyGoalsRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  StreamSubscription<int?>? _familySub;

  void setCurrentGoal(int goalId) {
    emit(state.copyWith(currentGoalId: goalId, clearError: true));
  }

  Future<void> reload() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(const MoneyGoalsState(isLoading: false, goals: []));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final goals = await _repository.listGoals(familyId: familyId);
      emit(
        state.copyWith(
          isLoading: false,
          goals: goals,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> createGoal({
    required String title,
    required int targetAmountCents,
    String currency = 'RUB',
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final goal = await _repository.upsertGoal(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        title: title,
        targetAmountCents: targetAmountCents,
        currency: currency,
      );

      final goals = await _repository.listGoals(familyId: familyId);
      emit(
        state.copyWith(
          isLoading: false,
          goals: goals,
          currentGoalId: goal.id,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> addContribution({
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) async {
    final familyId = _familySelectionCubit.state;
    final goalId = state.currentGoalId;
    if (familyId == null || goalId == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _repository.addContribution(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        goalId: goalId,
        amountCents: amountCents,
        currency: currency,
        note: note,
      );

      await reload();
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
