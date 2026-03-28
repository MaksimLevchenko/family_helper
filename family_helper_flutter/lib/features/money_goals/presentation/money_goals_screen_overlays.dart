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
        title: 'Active goals',
        subtitle:
            '${activeGoals.length} goal${activeGoals.length == 1 ? '' : 's'}',
      ),
      const SizedBox(height: 12),
      if (activeGoals.isEmpty)
        const _InlineEmptySection(
          message: 'No active goals. Archived goals stay below.',
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
          title: 'Archive',
          subtitle:
              '${archivedGoals.length} goal${archivedGoals.length == 1 ? '' : 's'}',
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
          title: 'Complete and archive goal',
          description:
              'This will move "${goal.title}" to the archive and keep it in history.',
          confirmLabel: 'Archive goal',
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
          title: 'Delete goal',
          description:
              'Delete "${goal.title}" permanently from active goals and archive.',
          confirmLabel: 'Delete goal',
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
    const SnackBar(
      content: Text(
        'Server unavailable. This action will work again when connection is restored.',
      ),
    ),
  );
}
