import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import 'money_goal_detail_support_widgets.dart';
import 'money_goal_formatters.dart';
import 'money_goal_settings_tab.dart';

class MoneyGoalOverviewTab extends StatelessWidget {
  const MoneyGoalOverviewTab({
    super.key,
    required this.goal,
    required this.archived,
    required this.progress,
    required this.isAddingContribution,
    required this.isWithdrawingFunds,
    required this.isCreatingGoal,
    required this.isArchivingGoal,
    required this.onAddContribution,
    required this.onWithdrawFunds,
    required this.onArchiveGoal,
    required this.onCreateGoal,
  });

  final MoneyGoalDto goal;
  final bool archived;
  final double progress;
  final bool isAddingContribution;
  final bool isWithdrawingFunds;
  final bool isCreatingGoal;
  final bool isArchivingGoal;
  final VoidCallback onAddContribution;
  final VoidCallback onWithdrawFunds;
  final VoidCallback onArchiveGoal;
  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    final metaCards = <Widget>[
      MoneyGoalCompactMetric(
        label: context.l10n.moneyGoalsRemainingLabel,
        value: formatRemainingAmount(goal),
      ),
      MoneyGoalCompactMetric(
        label: goal.reachedAt != null
            ? context.l10n.moneyGoalsStatusReached
            : context.l10n.listsMetricUpdated,
        value: goal.reachedAt != null
            ? formatShortDate(context, goal.reachedAt!)
            : formatShortDateTime(context, goal.updatedAt),
      ),
      if (goal.deadlineAt != null)
        MoneyGoalCompactMetric(
          label: context.l10n.moneyGoalsDeadlineLabel,
          value: formatShortDate(context, goal.deadlineAt!),
        ),
    ];

    final actionButtons = <Widget>[
      if (!archived)
        MoneyGoalCompactActionButton(
          label: context.l10n.moneyGoalsAddContributionAction,
          isLoading: isAddingContribution,
          onPressed: onAddContribution,
        ),
      if (!archived)
        MoneyGoalCompactActionButton(
          label: context.l10n.moneyGoalsWithdrawAction,
          variant: MoneyGoalCompactActionVariant.secondary,
          isLoading: isWithdrawingFunds,
          onPressed: onWithdrawFunds,
        ),
      if (!archived)
        MoneyGoalCompactActionButton(
          label: context.l10n.moneyGoalsCompleteAndArchive,
          variant: MoneyGoalCompactActionVariant.secondary,
          isLoading: isArchivingGoal,
          onPressed: onArchiveGoal,
        ),
      MoneyGoalCompactActionButton(
        label: context.l10n.moneyGoalsNewGoal,
        variant: MoneyGoalCompactActionVariant.secondary,
        isLoading: isCreatingGoal,
        onPressed: onCreateGoal,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (goal.description != null &&
            goal.description!.trim().isNotEmpty) ...[
          Text(
            goal.description!,
            style: TextStyle(color: context.colors.textSecondary),
          ),
          const SizedBox(height: 12),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: metaCards,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colors.surfaceMuted,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.moneyGoalsProgressTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: context.colors.background,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth >= 520;
            return MoneyGoalActionMatrix(
              buttons: actionButtons,
              twoColumns: twoColumns,
            );
          },
        ),
      ],
    );
  }
}
