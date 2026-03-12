import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../ui_kit/ui_kit.dart';
import '../providers/money_goals_provider.dart';
import 'widgets/money_goal_detail_card.dart';
import 'widgets/money_goal_forms.dart';
import 'widgets/money_goal_formatters.dart';
import 'widgets/money_goal_list_item.dart';
import 'widgets/money_goals_summary_card.dart';

class MoneyGoalsScreen extends StatefulWidget {
  const MoneyGoalsScreen({super.key});

  @override
  State<MoneyGoalsScreen> createState() => _MoneyGoalsScreenState();
}

class _MoneyGoalsScreenState extends State<MoneyGoalsScreen> {
  static const _wideLayoutBreakpoint = 720.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Money Goals')),
      body: BlocBuilder<MoneyGoalsCubit, MoneyGoalsState>(
        builder: (context, state) {
          if (state.hasSelectedFamily &&
              state.isInitialLoading &&
              state.goals.isEmpty) {
            return const SafeArea(
              child: LoadingState(label: 'Loading goals...'),
            );
          }

          if (state.hasSelectedFamily &&
              state.error != null &&
              state.goals.isEmpty) {
            return SafeArea(
              child: ErrorState(
                message: state.error!,
                onRetry: () => context.read<MoneyGoalsCubit>().reload(),
              ),
            );
          }

          if (!state.hasSelectedFamily) {
            return SafeArea(
              child: _NoFamilySelectedView(
                onOpenFamily: () {
                  context.go(AppRoutes.family);
                },
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
                  return isWide
                      ? _buildWideLayout(context, state)
                      : _buildNarrowLayout(context, state);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context, MoneyGoalsState state) {
    return ListView(
      key: const Key('money-goals-narrow-layout'),
      children: [
        if (state.error != null) ...[
          AppBanner(text: state.error!, isError: true),
          const SizedBox(height: 10),
        ],
        MoneyGoalsSummaryCard(goals: state.goals),
        const SizedBox(height: 8),
        _buildDetailSection(context, state, isWide: false),
        const SizedBox(height: 16),
        _buildGoalSections(context, state),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context, MoneyGoalsState state) {
    return Column(
      key: const Key('money-goals-wide-layout'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.error != null) ...[
          AppBanner(text: state.error!, isError: true),
          const SizedBox(height: 10),
        ],
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 320,
                child: _GoalsSidebar(
                  state: state,
                  onSelectGoal: (goalId) {
                    context.read<MoneyGoalsCubit>().setCurrentGoal(goalId);
                  },
                  onCreateGoal: () {
                    _showCreateGoalOverlay(context, isWide: true);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MoneyGoalsSummaryCard(goals: state.goals),
                      const SizedBox(height: 12),
                      _buildDetailSection(context, state, isWide: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    MoneyGoalsState state, {
    required bool isWide,
  }) {
    final selectedGoal = state.selectedGoal;

    if (selectedGoal != null) {
      return MoneyGoalDetailCard(
        goal: selectedGoal,
        history: state.history,
        isHistoryLoading: state.isHistoryLoading,
        isUpdatingGoal: state.isUpdatingGoal,
        isAddingContribution: state.isAddingContribution,
        isWithdrawingFunds: state.isWithdrawingFunds,
        isCreatingGoal: state.isCreatingGoal,
        isArchivingGoal: state.isArchivingGoal,
        isDeletingGoal: state.isDeletingGoal,
        onAddContribution: isArchivedGoal(selectedGoal)
            ? () {}
            : () => _showContributionOverlay(
                context,
                selectedGoal,
                isWide: isWide,
              ),
        onWithdrawFunds: isArchivedGoal(selectedGoal)
            ? () {}
            : () => _showWithdrawOverlay(
                context,
                selectedGoal,
                isWide: isWide,
              ),
        onArchiveGoal: isArchivedGoal(selectedGoal)
            ? () {}
            : () => _showArchiveGoalOverlay(
                context,
                selectedGoal,
                isWide: isWide,
              ),
        onDeleteGoal: () => _showDeleteGoalOverlay(
          context,
          selectedGoal,
          isWide: isWide,
        ),
        onCreateGoal: () => _showCreateGoalOverlay(context, isWide: isWide),
        onUpdateGoal:
            ({
              required String title,
              required int targetAmountCents,
              String? description,
              DateTime? deadlineAt,
              required String currency,
            }) {
              return context.read<MoneyGoalsCubit>().updateCurrentGoal(
                title: title,
                targetAmountCents: targetAmountCents,
                description: description,
                deadlineAt: deadlineAt,
                currency: currency,
              );
            },
      );
    }

    if (state.goals.isEmpty) {
      return _EmptyDetailCard(
        title: 'No goals yet',
        message: 'Create your first savings goal and start tracking progress.',
        buttonLabel: 'Create first goal',
        isLoading: state.isCreatingGoal,
        onPressed: () => _showCreateGoalOverlay(context, isWide: isWide),
      );
    }

    return _EmptyDetailCard(
      title: 'Pick a goal',
      message:
          'Select a goal from the active list or archive to inspect progress and actions.',
      buttonLabel: 'Create another goal',
      isLoading: state.isCreatingGoal,
      onPressed: () => _showCreateGoalOverlay(context, isWide: isWide),
    );
  }

  Widget _buildGoalSections(BuildContext context, MoneyGoalsState state) {
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
          ..._buildGoalListItems(
            context,
            activeGoals,
            state.currentGoalId,
          ),
        if (archivedGoals.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionHeader(
            title: 'Archive',
            subtitle:
                '${archivedGoals.length} goal${archivedGoals.length == 1 ? '' : 's'}',
          ),
          const SizedBox(height: 8),
          ..._buildGoalListItems(
            context,
            archivedGoals,
            state.currentGoalId,
          ),
        ],
      ],
    );
  }

  List<Widget> _buildGoalListItems(
    BuildContext context,
    List<MoneyGoalDto> goals,
    int? currentGoalId,
  ) {
    return [
      for (final goal in goals) ...[
        MoneyGoalListItem(
          goal: goal,
          isSelected: goal.id == currentGoalId,
          onTap: () => context.read<MoneyGoalsCubit>().setCurrentGoal(goal.id),
        ),
        const SizedBox(height: 8),
      ],
    ]..removeLast();
  }

  Future<void> _showCreateGoalOverlay(
    BuildContext context, {
    required bool isWide,
  }) async {
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
  }) async {
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
  }) async {
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
  }) async {
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
            onConfirm: () =>
                context.read<MoneyGoalsCubit>().archiveCurrentGoal(),
          );
        },
      ),
    );
  }

  Future<void> _showDeleteGoalOverlay(
    BuildContext context,
    MoneyGoalDto goal, {
    required bool isWide,
  }) async {
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
            onConfirm: () =>
                context.read<MoneyGoalsCubit>().deleteCurrentGoal(),
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
      showDragHandle: true,
      builder: (sheetContext) {
        return BlocProvider<MoneyGoalsCubit>.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              8,
              12,
              MediaQuery.of(sheetContext).viewInsets.bottom + 12,
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class _GoalsSidebar extends StatelessWidget {
  const _GoalsSidebar({
    required this.state,
    required this.onSelectGoal,
    required this.onCreateGoal,
  });

  final MoneyGoalsState state;
  final ValueChanged<int> onSelectGoal;
  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    final activeGoals = state.activeGoals;
    final archivedGoals = state.archivedGoals;

    if (activeGoals.isEmpty && archivedGoals.isEmpty) {
      return _EmptyGoalsList(onCreateGoal: onCreateGoal);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Goals',
          subtitle:
              '${activeGoals.length} active, ${archivedGoals.length} archived',
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [
              if (activeGoals.isNotEmpty) ...[
                Text(
                  'Active',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                ..._sidebarItems(
                  activeGoals,
                  state.currentGoalId,
                  onSelectGoal,
                ),
              ],
              if (archivedGoals.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'Archive',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                ..._sidebarItems(
                  archivedGoals,
                  state.currentGoalId,
                  onSelectGoal,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _sidebarItems(
    List<MoneyGoalDto> goals,
    int? currentGoalId,
    ValueChanged<int> onSelectGoal,
  ) {
    return [
      for (final goal in goals) ...[
        MoneyGoalListItem(
          goal: goal,
          isSelected: goal.id == currentGoalId,
          onTap: () => onSelectGoal(goal.id),
        ),
        const SizedBox(height: 8),
      ],
    ]..removeLast();
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _InlineEmptySection extends StatelessWidget {
  const _InlineEmptySection({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(message),
      ),
    );
  }
}

class _NoFamilySelectedView extends StatelessWidget {
  const _NoFamilySelectedView({required this.onOpenFamily});

  final VoidCallback onOpenFamily;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _EmptyMessage(
              title: 'Choose a family first',
              message:
                  'Goals are tied to the selected family. Open family settings to create or join one.',
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Open family settings',
              onPressed: onOpenFamily,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDetailCard extends StatelessWidget {
  const _EmptyDetailCard({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.isLoading,
    required this.onPressed,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: const Key('money-goals-empty-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EmptyMessage(title: title, message: message),
            const SizedBox(height: 12),
            AppButton(
              label: buttonLabel,
              isLoading: isLoading,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGoalsList extends StatelessWidget {
  const _EmptyGoalsList({required this.onCreateGoal});

  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _EmptyMessage(
              title: 'No goals yet',
              message: 'Create your first goal from the detail pane.',
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Create first goal',
              onPressed: onCreateGoal,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
