import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/money_goals/presentation/money_goals_screen.dart';
import 'package:family_helper_flutter/features/money_goals/providers/money_goals_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestMoneyGoalsCubit extends Cubit<MoneyGoalsState>
    implements MoneyGoalsCubit {
  _TestMoneyGoalsCubit(super.initialState);

  int createGoalCalls = 0;
  int updateGoalCalls = 0;
  int addContributionCalls = 0;
  int withdrawFundsCalls = 0;
  int archiveGoalCalls = 0;
  int deleteGoalCalls = 0;
  String? createdTitle;
  String? updatedTitle;
  String? updatedDescription;
  int? createdTargetAmountCents;
  int? updatedTargetAmountCents;
  int? contributedAmountCents;
  int? withdrawnAmountCents;

  @override
  Future<bool> addContribution({
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) async {
    final goalId = state.currentGoalId;
    if (goalId == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }

    addContributionCalls++;
    contributedAmountCents = amountCents;
    return true;
  }

  @override
  Future<bool> archiveCurrentGoal() async {
    archiveGoalCalls++;
    final goal = state.selectedGoal;
    if (goal == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }
    emit(
      state.copyWith(
        goals: state.goals
            .map(
              (item) => item.id == goal.id
                  ? item.copyWith(archivedAt: DateTime.utc(2026, 3, 12, 15))
                  : item,
            )
            .toList(),
      ),
    );
    return true;
  }

  @override
  Future<bool> createGoal({
    required String title,
    required int targetAmountCents,
    String currency = 'RUB',
  }) async {
    createGoalCalls++;
    createdTitle = title;
    createdTargetAmountCents = targetAmountCents;
    return true;
  }

  @override
  Future<bool> updateCurrentGoal({
    required String title,
    required int targetAmountCents,
    String? description,
    DateTime? deadlineAt,
    String currency = 'RUB',
  }) async {
    final goal = state.selectedGoal;
    if (goal == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }

    updateGoalCalls++;
    updatedTitle = title;
    updatedDescription = description;
    updatedTargetAmountCents = targetAmountCents;
    emit(
      state.copyWith(
        goals: state.goals
            .map(
              (item) => item.id == goal.id
                  ? item.copyWith(
                      title: title,
                      description: description,
                      targetAmountCents: targetAmountCents,
                      deadlineAt: deadlineAt,
                    )
                  : item,
            )
            .toList(),
      ),
    );
    return true;
  }

  @override
  Future<bool> deleteCurrentGoal() async {
    final goalId = state.currentGoalId;
    if (goalId == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }
    deleteGoalCalls++;
    final updatedGoals = state.goals
        .where((goal) => goal.id != goalId)
        .toList();
    emit(
      state.copyWith(
        goals: updatedGoals,
        currentGoalId: updatedGoals.isEmpty ? null : updatedGoals.first.id,
      ),
    );
    return true;
  }

  @override
  Future<void> reload() async {}

  @override
  void reset({bool hasSelectedFamily = false}) {
    emit(MoneyGoalsState.initial(hasSelectedFamily: hasSelectedFamily));
  }

  @override
  void setCurrentGoal(int goalId) {
    emit(state.copyWith(currentGoalId: goalId));
  }

  @override
  Future<bool> withdrawFunds({
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) async {
    final goal = state.selectedGoal;
    if (goal == null) {
      emit(state.copyWith(error: 'Family/goal is not selected'));
      return false;
    }

    withdrawFundsCalls++;
    withdrawnAmountCents = amountCents;
    emit(
      state.copyWith(
        goals: state.goals
            .map(
              (item) => item.id == goal.id
                  ? item.copyWith(
                      currentAmountCents: item.currentAmountCents - amountCents,
                    )
                  : item,
            )
            .toList(),
      ),
    );
    return true;
  }
}

void main() {
  Widget buildSubject(_TestMoneyGoalsCubit cubit) {
    return BlocProvider<MoneyGoalsCubit>.value(
      value: cubit,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const MoneyGoalsScreen(),
      ),
    );
  }

  void setNarrowSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('MoneyGoalsScreen narrow layout', () {
    testWidgets('shows create-first-goal empty state', (tester) async {
      setNarrowSurface(tester);
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(isInitialLoading: false),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('money-goals-narrow-layout')),
        findsOneWidget,
      );
      expect(find.text('No goals yet'), findsOneWidget);
      expect(find.text('Create first goal'), findsOneWidget);
      expect(find.byKey(const Key('money-goals-summary-card')), findsOneWidget);

      await cubit.close();
    });

    testWidgets('renders selected goal detail card', (tester) async {
      setNarrowSurface(tester);
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          goals: [
            _goal(id: 1, title: 'Emergency fund', currentAmountCents: 25000),
          ],
          history: [
            _history(
              id: 1,
              goalId: 1,
              actorDisplayName: 'Alex',
              amountCents: 25000,
            ),
          ],
          currentGoalId: 1,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('money-goal-detail-card')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const Key('money-goal-detail-card')),
          matching: find.text('Emergency fund'),
        ),
        findsOneWidget,
      );
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Add contribution'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('renders contribution and withdrawal history rows', (
      tester,
    ) async {
      setNarrowSurface(tester);
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          goals: [
            _goal(id: 1, title: 'Emergency fund', currentAmountCents: 25000),
          ],
          history: [
            _history(
              id: 1,
              goalId: 1,
              actorDisplayName: 'Alex',
              amountCents: 25000,
            ),
            _history(
              id: 2,
              goalId: 1,
              actorDisplayName: 'Maria',
              amountCents: -5000,
            ),
          ],
          currentGoalId: 1,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('goal-detail-tab-history')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('money-goal-history-section')),
        findsOneWidget,
      );
      expect(find.text('Alex added 250.00 RUB'), findsOneWidget);
      expect(find.text('Maria withdrew 50.00 RUB'), findsOneWidget);
      expect(find.text('-50.00 RUB'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('opens create flow and validates amount input', (tester) async {
      setNarrowSurface(tester);
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(isInitialLoading: false),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create first goal'));
      await tester.pumpAndSettle();

      expect(find.text('Create a new goal'), findsOneWidget);

      await tester.tap(find.text('Create goal').last);
      await tester.pump();

      expect(find.text('Enter a goal title'), findsOneWidget);
      expect(find.text('Enter a valid amount'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('create-goal-title-field')),
        'Vacation',
      );
      await tester.enterText(
        find.byKey(const Key('create-goal-amount-field')),
        '1234.50',
      );

      await tester.tap(find.text('Create goal').last);
      await tester.pumpAndSettle();

      expect(cubit.createGoalCalls, 1);
      expect(cubit.createdTitle, 'Vacation');
      expect(cubit.createdTargetAmountCents, 123450);

      await cubit.close();
    });

    testWidgets('requires selected goal before showing contribution flow', (
      tester,
    ) async {
      setNarrowSurface(tester);
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          goals: [
            _goal(id: 1, title: 'Emergency fund'),
          ],
          currentGoalId: null,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.text('Pick a goal'), findsOneWidget);
      expect(find.text('Add contribution'), findsNothing);

      await cubit.close();
    });

    testWidgets('shows archived goals in archive section', (tester) async {
      setNarrowSurface(tester);
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          goals: [
            _goal(id: 1, title: 'Emergency fund'),
            _goal(
              id: 2,
              title: 'Vacation',
              archivedAt: DateTime.utc(2026, 3, 12, 15),
            ),
          ],
          currentGoalId: 1,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Archive'),
        300,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Archive'), findsOneWidget);
      expect(find.text('Vacation'), findsOneWidget);
      expect(find.text('Archived'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('opens withdraw flow and submits amount', (tester) async {
      tester.view.physicalSize = const Size(390, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          goals: [
            _goal(id: 1, title: 'Emergency fund', currentAmountCents: 25000),
          ],
          currentGoalId: 1,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Withdraw money'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('withdraw-goal-amount-field')),
        '50.00',
      );
      await tester.tap(find.text('Withdraw money').last);
      await tester.pumpAndSettle();

      expect(cubit.withdrawFundsCalls, 1);
      expect(cubit.withdrawnAmountCents, 5000);

      await cubit.close();
    });

    testWidgets('settings tab pre-fills fields and saves updates', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          goals: [
            _goal(
              id: 1,
              title: 'Emergency fund',
              targetAmountCents: 250000,
            ).copyWith(description: 'Family reserve'),
          ],
          currentGoalId: 1,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('goal-detail-tab-settings')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('goal-settings-title-field')),
        findsOneWidget,
      );
      expect(find.text('Family reserve'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('goal-settings-title-field')),
        '',
      );
      await tester.enterText(
        find.byKey(const Key('goal-settings-amount-field')),
        '',
      );
      await tester.tap(find.text('Save changes'));
      await tester.pump();

      expect(find.text('Enter a goal title'), findsOneWidget);
      expect(find.text('Enter a valid amount'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('goal-settings-title-field')),
        'Emergency reserve',
      );
      await tester.enterText(
        find.byKey(const Key('goal-settings-amount-field')),
        '3200.00',
      );
      await tester.enterText(
        find.byKey(const Key('goal-settings-description-field')),
        'Updated reserve',
      );
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();

      expect(cubit.updateGoalCalls, 1);
      expect(cubit.updatedTitle, 'Emergency reserve');
      expect(cubit.updatedTargetAmountCents, 320000);
      expect(cubit.updatedDescription, 'Updated reserve');

      await cubit.close();
    });

    testWidgets('archived goal keeps history and delete but disables editing', (
      tester,
    ) async {
      setNarrowSurface(tester);
      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          goals: [
            _goal(
              id: 1,
              title: 'Vacation',
              archivedAt: DateTime.utc(2026, 3, 12, 15),
            ).copyWith(description: 'Past trip'),
          ],
          currentGoalId: 1,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.text('Add contribution'), findsNothing);

      await tester.tap(find.byKey(const Key('goal-detail-tab-settings')));
      await tester.pumpAndSettle();

      final titleField = tester.widget<TextFormField>(
        find.byKey(const Key('goal-settings-title-field')),
      );
      expect(titleField.enabled, isFalse);
      expect(find.text('Archive goal'), findsNothing);
      expect(find.text('Delete goal'), findsOneWidget);

      await cubit.close();
    });
  });

  group('MoneyGoalsScreen wide layout', () {
    testWidgets('shows two-pane layout and updates detail on selection', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final cubit = _TestMoneyGoalsCubit(
        MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          goals: [
            _goal(id: 1, title: 'Emergency fund'),
            _goal(id: 2, title: 'Vacation'),
          ],
          currentGoalId: 1,
        ),
      );

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('money-goals-wide-layout')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const Key('money-goal-detail-card')),
          matching: find.text('Emergency fund'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('goal-list-item-2')));
      await tester.pumpAndSettle();

      expect(cubit.state.currentGoalId, 2);
      expect(
        find.descendant(
          of: find.byKey(const Key('money-goal-detail-card')),
          matching: find.text('Vacation'),
        ),
        findsOneWidget,
      );

      await cubit.close();
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
  DateTime? archivedAt,
}) {
  return MoneyGoalDto(
    id: id,
    familyId: 42,
    title: title,
    targetAmountCents: targetAmountCents,
    currentAmountCents: currentAmountCents,
    currency: 'RUB',
    archivedAt: archivedAt,
    updatedAt: DateTime.utc(2026, 3, 12, 12),
    version: 1,
  );
}
