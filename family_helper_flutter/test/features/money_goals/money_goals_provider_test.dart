import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:family_helper_flutter/features/money_goals/data/money_goals_repository.dart';
import 'package:family_helper_flutter/features/money_goals/providers/money_goals_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestFamilySelectionCubit extends FamilySelectionCubit {
  _TestFamilySelectionCubit(int? initialFamilyId) : super() {
    emit(initialFamilyId);
  }

  @override
  Future<void> bootstrap() async {}

  @override
  Future<void> setFamilyId(int familyId) async {
    emit(familyId);
  }

  @override
  Future<void> clear() async {
    emit(null);
  }
}

class _FakeMoneyGoalsRepository implements MoneyGoalsRepository {
  final listResults = <List<MoneyGoalDto>>[];
  final historyResults = <List<MoneyGoalHistoryEntryDto>>[];
  Completer<MoneyGoalDto>? createCompleter;
  Completer<MoneyGoalDto>? updateCompleter;
  Completer<MoneyContributionDto>? contributionCompleter;
  Completer<MoneyContributionDto>? withdrawCompleter;
  Completer<MoneyGoalDto>? archiveCompleter;
  Completer<OperationResult>? deleteCompleter;
  Completer<List<MoneyGoalHistoryEntryDto>>? historyCompleter;
  MoneyGoalDto? createdGoal;
  int? lastUpsertGoalId;
  String? lastTitle;
  String? lastDescription;
  int? lastTargetAmountCents;
  DateTime? lastDeadlineAt;

  @override
  Future<MoneyContributionDto> addContribution({
    required String clientOperationId,
    required int familyId,
    required int goalId,
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) {
    final completer = contributionCompleter;
    if (completer != null) {
      return completer.future;
    }

    return Future.value(
      MoneyContributionDto(
        id: 1,
        goalId: goalId,
        profileId: 1,
        amountCents: amountCents,
        currency: currency,
        createdAt: DateTime.utc(2026, 3, 12),
      ),
    );
  }

  @override
  Future<MoneyGoalDto> archiveGoal({
    required String clientOperationId,
    required int familyId,
    required int goalId,
  }) {
    final completer = archiveCompleter;
    if (completer != null) {
      return completer.future;
    }
    return Future.value(
      _goal(
        id: goalId,
        title: 'Archived',
        archivedAt: DateTime.utc(2026, 3, 12),
      ),
    );
  }

  @override
  Future<OperationResult> deleteGoal({
    required String clientOperationId,
    required int familyId,
    required int goalId,
  }) {
    final completer = deleteCompleter;
    if (completer != null) {
      return completer.future;
    }
    return Future.value(
      OperationResult(success: true, message: 'Goal deleted'),
    );
  }

  @override
  Future<List<MoneyGoalDto>> listGoals({required int familyId}) async {
    if (listResults.isEmpty) {
      return const [];
    }
    return listResults.removeAt(0);
  }

  @override
  Future<List<MoneyGoalHistoryEntryDto>> listGoalHistory({
    required int familyId,
    required int goalId,
    int limit = 50,
  }) {
    final completer = historyCompleter;
    if (completer != null) {
      return completer.future;
    }
    if (historyResults.isEmpty) {
      return Future.value(const []);
    }
    return Future.value(historyResults.removeAt(0));
  }

  @override
  Future<MoneyGoalDto> upsertGoal({
    required String clientOperationId,
    int? goalId,
    required int familyId,
    required String title,
    String? description,
    required int targetAmountCents,
    String currency = 'RUB',
    DateTime? deadlineAt,
  }) {
    lastUpsertGoalId = goalId;
    lastTitle = title;
    lastDescription = description;
    lastTargetAmountCents = targetAmountCents;
    lastDeadlineAt = deadlineAt;

    final completer = goalId == null ? createCompleter : updateCompleter;
    if (completer != null) {
      return completer.future;
    }

    return Future.value(
      createdGoal ??
          _goal(
            id: goalId ?? 99,
            title: title,
            targetAmountCents: targetAmountCents,
            currency: currency,
            deadlineAt: deadlineAt,
          ).copyWith(description: description),
    );
  }

  @override
  Future<MoneyContributionDto> withdrawFunds({
    required String clientOperationId,
    required int familyId,
    required int goalId,
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) {
    final completer = withdrawCompleter;
    if (completer != null) {
      return completer.future;
    }

    return Future.value(
      MoneyContributionDto(
        id: 2,
        goalId: goalId,
        profileId: 1,
        amountCents: -amountCents,
        currency: currency,
        createdAt: DateTime.utc(2026, 3, 12),
      ),
    );
  }
}

void main() {
  group('MoneyGoalsCubit', () {
    test('auto-selects the first goal after load', () async {
      final repository = _FakeMoneyGoalsRepository()
        ..listResults.add([
          _goal(id: 1, title: 'Emergency fund'),
          _goal(id: 2, title: 'Vacation'),
        ]);
      final familySelectionCubit = _TestFamilySelectionCubit(null);
      final cubit = MoneyGoalsCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
      );

      await familySelectionCubit.setFamilyId(42);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      expect(cubit.state.currentGoalId, 1);
      expect(cubit.state.selectedGoal?.title, 'Emergency fund');

      await cubit.close();
      await familySelectionCubit.close();
    });

    test(
      'preserves selected goal across reload when it still exists',
      () async {
        final repository = _FakeMoneyGoalsRepository()
          ..listResults.add([
            _goal(id: 1, title: 'Emergency fund'),
            _goal(id: 2, title: 'Vacation'),
          ])
          ..listResults.add([
            _goal(id: 1, title: 'Emergency fund'),
            _goal(id: 2, title: 'Vacation', currentAmountCents: 25000),
          ]);
        final familySelectionCubit = _TestFamilySelectionCubit(null);
        final cubit = MoneyGoalsCubit(
          repository: repository,
          familySelectionCubit: familySelectionCubit,
        );

        await familySelectionCubit.setFamilyId(42);
        await Future<void>.delayed(const Duration(milliseconds: 1));
        cubit.setCurrentGoal(2);

        await cubit.reload();

        expect(cubit.state.currentGoalId, 2);
        expect(cubit.state.selectedGoal?.currentAmountCents, 25000);

        await cubit.close();
        await familySelectionCubit.close();
      },
    );

    test('loads history for the selected goal', () async {
      final repository = _FakeMoneyGoalsRepository()
        ..listResults.add([
          _goal(id: 1, title: 'Emergency fund'),
          _goal(id: 2, title: 'Vacation'),
        ])
        ..historyResults.add([
          _history(
            id: 1,
            goalId: 1,
            actorDisplayName: 'User 00000000',
            amountCents: 15000,
          ),
        ])
        ..historyResults.add([
          _history(
            id: 2,
            goalId: 2,
            actorDisplayName: 'Anna',
            amountCents: -5000,
          ),
        ]);
      final familySelectionCubit = _TestFamilySelectionCubit(null);
      final cubit = MoneyGoalsCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
      );

      await familySelectionCubit.setFamilyId(42);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      expect(cubit.state.currentGoalId, 1);
      expect(cubit.state.history.single.actorDisplayName, 'User 00000000');

      cubit.setCurrentGoal(2);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      expect(cubit.state.currentGoalId, 2);
      expect(cubit.state.history.single.actorDisplayName, 'Anna');
      expect(cubit.state.history.single.amountCents, -5000);

      await cubit.close();
      await familySelectionCubit.close();
    });

    test('updates current goal and preserves selection', () async {
      final repository = _FakeMoneyGoalsRepository()
        ..listResults.add([
          _goal(
            id: 1,
            title: 'Emergency fund',
            targetAmountCents: 100000,
          ).copyWith(description: 'Initial'),
        ])
        ..historyResults.add(const [])
        ..listResults.add([
          _goal(
            id: 1,
            title: 'Emergency reserve',
            targetAmountCents: 150000,
            deadlineAt: DateTime.utc(2026, 8, 1),
          ).copyWith(description: 'Updated'),
        ])
        ..historyResults.add(const []);
      final familySelectionCubit = _TestFamilySelectionCubit(null);
      final cubit = MoneyGoalsCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
      );

      await familySelectionCubit.setFamilyId(42);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final updated = await cubit.updateCurrentGoal(
        title: 'Emergency reserve',
        targetAmountCents: 150000,
        description: 'Updated',
        deadlineAt: DateTime.utc(2026, 8, 1),
      );

      expect(updated, isTrue);
      expect(repository.lastUpsertGoalId, 1);
      expect(repository.lastTitle, 'Emergency reserve');
      expect(repository.lastDescription, 'Updated');
      expect(repository.lastTargetAmountCents, 150000);
      expect(cubit.state.currentGoalId, 1);
      expect(cubit.state.selectedGoal?.title, 'Emergency reserve');
      expect(cubit.state.isUpdatingGoal, isFalse);

      await cubit.close();
      await familySelectionCubit.close();
    });

    test('clears selection when reload returns no goals', () async {
      final repository = _FakeMoneyGoalsRepository()
        ..listResults.add([
          _goal(id: 1, title: 'Emergency fund'),
        ])
        ..listResults.add(const []);
      final familySelectionCubit = _TestFamilySelectionCubit(null);
      final cubit = MoneyGoalsCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
      );

      await familySelectionCubit.setFamilyId(42);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      await cubit.reload();

      expect(cubit.state.goals, isEmpty);
      expect(cubit.state.currentGoalId, isNull);

      await cubit.close();
      await familySelectionCubit.close();
    });

    test('keeps no-family state distinct from empty goals', () async {
      final repository = _FakeMoneyGoalsRepository();
      final familySelectionCubit = _TestFamilySelectionCubit(null);
      final cubit = MoneyGoalsCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
      );

      await cubit.reload();

      expect(cubit.state.hasSelectedFamily, isFalse);
      expect(cubit.state.goals, isEmpty);
      expect(cubit.state.currentGoalId, isNull);

      await cubit.close();
      await familySelectionCubit.close();
    });

    test('goal action loading flags stay independent', () async {
      final createCompleter = Completer<MoneyGoalDto>();
      final contributionCompleter = Completer<MoneyContributionDto>();
      final withdrawCompleter = Completer<MoneyContributionDto>();
      final archiveCompleter = Completer<MoneyGoalDto>();
      final deleteCompleter = Completer<OperationResult>();
      final repository = _FakeMoneyGoalsRepository()
        ..listResults.add([
          _goal(id: 1, title: 'Emergency fund'),
        ])
        ..listResults.add([
          _goal(id: 1, title: 'Emergency fund'),
          _goal(id: 2, title: 'Vacation'),
        ])
        ..listResults.add([
          _goal(id: 1, title: 'Emergency fund', currentAmountCents: 15000),
          _goal(id: 2, title: 'Vacation'),
        ])
        ..listResults.add([
          _goal(id: 1, title: 'Emergency fund', currentAmountCents: 5000),
          _goal(id: 2, title: 'Vacation'),
        ])
        ..listResults.add([
          _goal(
            id: 1,
            title: 'Emergency fund',
            currentAmountCents: 5000,
            archivedAt: DateTime.utc(2026, 3, 12, 15),
          ),
          _goal(id: 2, title: 'Vacation'),
        ])
        ..listResults.add([
          _goal(id: 2, title: 'Vacation'),
        ])
        ..createCompleter = createCompleter
        ..contributionCompleter = contributionCompleter
        ..withdrawCompleter = withdrawCompleter
        ..archiveCompleter = archiveCompleter
        ..deleteCompleter = deleteCompleter;
      final familySelectionCubit = _TestFamilySelectionCubit(null);
      final cubit = MoneyGoalsCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
      );

      await familySelectionCubit.setFamilyId(42);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final createFuture = cubit.createGoal(
        title: 'Vacation',
        targetAmountCents: 500000,
      );

      expect(cubit.state.isCreatingGoal, isTrue);
      expect(cubit.state.isUpdatingGoal, isFalse);
      expect(cubit.state.isAddingContribution, isFalse);
      expect(cubit.state.isInitialLoading, isFalse);
      expect(cubit.state.isWithdrawingFunds, isFalse);
      expect(cubit.state.isArchivingGoal, isFalse);
      expect(cubit.state.isDeletingGoal, isFalse);

      createCompleter.complete(_goal(id: 2, title: 'Vacation'));
      await createFuture;

      expect(cubit.state.isCreatingGoal, isFalse);
      expect(cubit.state.isUpdatingGoal, isFalse);
      expect(cubit.state.currentGoalId, 2);

      cubit.setCurrentGoal(1);
      final contributionFuture = cubit.addContribution(amountCents: 15000);

      expect(cubit.state.isAddingContribution, isTrue);
      expect(cubit.state.isCreatingGoal, isFalse);
      expect(cubit.state.isInitialLoading, isFalse);
      expect(cubit.state.isWithdrawingFunds, isFalse);

      contributionCompleter.complete(
        MoneyContributionDto(
          id: 1,
          goalId: 1,
          profileId: 1,
          amountCents: 15000,
          currency: 'RUB',
          createdAt: DateTime.utc(2026, 3, 12),
        ),
      );
      await contributionFuture;

      expect(cubit.state.isAddingContribution, isFalse);
      expect(cubit.state.selectedGoal?.currentAmountCents, 15000);

      final withdrawFuture = cubit.withdrawFunds(amountCents: 10000);

      expect(cubit.state.isWithdrawingFunds, isTrue);
      expect(cubit.state.isAddingContribution, isFalse);
      expect(cubit.state.isArchivingGoal, isFalse);

      withdrawCompleter.complete(
        MoneyContributionDto(
          id: 2,
          goalId: 1,
          profileId: 1,
          amountCents: -10000,
          currency: 'RUB',
          createdAt: DateTime.utc(2026, 3, 12),
        ),
      );
      await withdrawFuture;

      expect(cubit.state.isWithdrawingFunds, isFalse);
      expect(cubit.state.selectedGoal?.currentAmountCents, 5000);

      final archiveFuture = cubit.archiveCurrentGoal();

      expect(cubit.state.isArchivingGoal, isTrue);
      expect(cubit.state.isDeletingGoal, isFalse);

      archiveCompleter.complete(
        _goal(
          id: 1,
          title: 'Emergency fund',
          currentAmountCents: 5000,
          archivedAt: DateTime.utc(2026, 3, 12, 15),
        ),
      );
      await archiveFuture;

      expect(cubit.state.isArchivingGoal, isFalse);
      expect(cubit.state.selectedGoal?.archivedAt, isNotNull);

      final deleteFuture = cubit.deleteCurrentGoal();

      expect(cubit.state.isDeletingGoal, isTrue);
      expect(cubit.state.isArchivingGoal, isFalse);

      deleteCompleter.complete(
        OperationResult(success: true, message: 'Goal deleted'),
      );
      await deleteFuture;

      expect(cubit.state.isDeletingGoal, isFalse);
      expect(cubit.state.currentGoalId, 2);

      await cubit.close();
      await familySelectionCubit.close();
    });
  });
}

MoneyGoalHistoryEntryDto _history({
  required int id,
  required int goalId,
  required String actorDisplayName,
  required int amountCents,
}) {
  return MoneyGoalHistoryEntryDto(
    id: id,
    goalId: goalId,
    profileId: id,
    actorDisplayName: actorDisplayName,
    amountCents: amountCents,
    currency: 'RUB',
    createdAt: DateTime.utc(2026, 3, 12, 14),
  );
}

MoneyGoalDto _goal({
  required int id,
  required String title,
  int targetAmountCents = 100000,
  int currentAmountCents = 0,
  String currency = 'RUB',
  DateTime? deadlineAt,
  DateTime? reachedAt,
  DateTime? archivedAt,
}) {
  return MoneyGoalDto(
    id: id,
    familyId: 42,
    title: title,
    targetAmountCents: targetAmountCents,
    currentAmountCents: currentAmountCents,
    currency: currency,
    deadlineAt: deadlineAt,
    reachedAt: reachedAt,
    archivedAt: archivedAt,
    updatedAt: DateTime.utc(2026, 3, 12, 12),
    version: 1,
  );
}
