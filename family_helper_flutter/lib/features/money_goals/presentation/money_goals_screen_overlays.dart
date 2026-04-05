part of 'money_goals_screen.dart';

Widget _buildMoneyGoalsSections(BuildContext context, MoneyGoalsState state) {
  final activeGoals = state.activeGoals;
  final archivedGoals = state.archivedGoals;

  if (activeGoals.isEmpty && archivedGoals.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _SectionHeader(
        title: context.l10n.moneyGoalsSummaryActiveGoals,
        subtitle: context.l10n.moneyGoalsGoalCount(activeGoals.length),
      ),
      const SizedBox(height: 12),
      if (activeGoals.isEmpty)
        _InlineEmptySection(
          message: context.l10n.moneyGoalsNoActiveGoalsMessage,
        )
      else
        _ExpandableGoalList(
          goals: activeGoals,
          currentGoalId: state.currentGoalId,
          onSelectGoal: (goalId) {
            context.read<MoneyGoalsCubit>().setCurrentGoal(goalId);
          },
        ),
      if (archivedGoals.isNotEmpty) ...[
        const SizedBox(height: 16),
        _SectionHeader(
          title: context.l10n.moneyGoalsArchivedSection,
          subtitle: context.l10n.moneyGoalsGoalCount(archivedGoals.length),
        ),
        const SizedBox(height: 8),
        _ExpandableGoalList(
          goals: archivedGoals,
          currentGoalId: state.currentGoalId,
          onSelectGoal: (goalId) {
            context.read<MoneyGoalsCubit>().setCurrentGoal(goalId);
          },
        ),
      ],
    ],
  );
}

Future<void> _showCreateGoalOverlay(
  BuildContext context, {
  required bool isWide,
  required bool isOffline,
}) async {
  if (isOffline) {
    _showOfflineMessage(context);
    return;
  }
  await _showAdaptiveOverlay(
    context,
    isWide: isWide,
    child: BlocBuilder<MoneyGoalsCubit, MoneyGoalsState>(
      builder: (context, state) {
        return MoneyGoalCreateForm(
          isSubmitting: state.isCreatingGoal,
          onSubmit:
              ({
                required String title,
                required int targetAmountCents,
              }) {
                return context.read<MoneyGoalsCubit>().createGoal(
                  title: title,
                  targetAmountCents: targetAmountCents,
                );
              },
        );
      },
    ),
  );
}

Future<void> _showContributionOverlay(
  BuildContext context,
  MoneyGoalDto goal, {
  required bool isWide,
  required bool isOffline,
}) async {
  if (isOffline) {
    _showOfflineMessage(context);
    return;
  }
  await _showAdaptiveOverlay(
    context,
    isWide: isWide,
    child: BlocBuilder<MoneyGoalsCubit, MoneyGoalsState>(
      builder: (context, state) {
        return MoneyGoalContributionForm(
          goalTitle: goal.title,
          isSubmitting: state.isAddingContribution,
          onSubmit: ({required int amountCents}) {
            return context.read<MoneyGoalsCubit>().addContribution(
              amountCents: amountCents,
            );
          },
        );
      },
    ),
  );
}

Future<void> _showWithdrawOverlay(
  BuildContext context,
  MoneyGoalDto goal, {
  required bool isWide,
  required bool isOffline,
}) async {
  if (isOffline) {
    _showOfflineMessage(context);
    return;
  }
  await _showAdaptiveOverlay(
    context,
    isWide: isWide,
    child: BlocBuilder<MoneyGoalsCubit, MoneyGoalsState>(
      builder: (context, state) {
        return MoneyGoalWithdrawForm(
          goalTitle: goal.title,
          isSubmitting: state.isWithdrawingFunds,
          onSubmit: ({required int amountCents}) {
            return context.read<MoneyGoalsCubit>().withdrawFunds(
              amountCents: amountCents,
            );
          },
        );
      },
    ),
  );
}

Future<void> _showArchiveGoalOverlay(
  BuildContext context,
  MoneyGoalDto goal, {
  required bool isWide,
  required bool isOffline,
}) async {
  if (isOffline) {
    _showOfflineMessage(context);
    return;
  }
  await _showAdaptiveOverlay(
    context,
    isWide: isWide,
    child: BlocBuilder<MoneyGoalsCubit, MoneyGoalsState>(
      builder: (context, state) {
        return MoneyGoalConfirmAction(
          title: context.l10n.moneyGoalsArchiveGoalConfirmTitle,
          description: context.l10n.moneyGoalsArchiveGoalConfirmDescription(
            goal.title,
          ),
          confirmLabel: context.l10n.moneyGoalsArchiveGoalAction,
          isLoading: state.isArchivingGoal,
          onConfirm: () => context.read<MoneyGoalsCubit>().archiveCurrentGoal(),
        );
      },
    ),
  );
}

Future<void> _showDeleteGoalOverlay(
  BuildContext context,
  MoneyGoalDto goal, {
  required bool isWide,
  required bool isOffline,
}) async {
  if (isOffline) {
    _showOfflineMessage(context);
    return;
  }
  await _showAdaptiveOverlay(
    context,
    isWide: isWide,
    child: BlocBuilder<MoneyGoalsCubit, MoneyGoalsState>(
      builder: (context, state) {
        return MoneyGoalConfirmAction(
          title: context.l10n.moneyGoalsDeleteGoalConfirmTitle,
          description: context.l10n.moneyGoalsDeleteGoalConfirmDescription(
            goal.title,
          ),
          confirmLabel: context.l10n.moneyGoalsDeleteGoalAction,
          confirmVariant: AppButtonVariant.danger,
          isLoading: state.isDeletingGoal,
          onConfirm: () => context.read<MoneyGoalsCubit>().deleteCurrentGoal(),
        );
      },
    ),
  );
}

Future<void> _showAdaptiveOverlay(
  BuildContext context, {
  required bool isWide,
  required Widget child,
}) async {
  final cubit = context.read<MoneyGoalsCubit>();
  if (isWide) {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider<MoneyGoalsCubit>.value(
          value: cubit,
          child: Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: child,
              ),
            ),
          ),
        );
      },
    );
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return BlocProvider<MoneyGoalsCubit>.value(
        value: cubit,
        child: AppModalSheet(
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: child,
        ),
      );
    },
  );
}

void _showOfflineMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(context.l10n.calendarOfflineMessage),
    ),
  );
}
