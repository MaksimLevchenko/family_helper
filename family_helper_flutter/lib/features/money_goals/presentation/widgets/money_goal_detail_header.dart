import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import 'money_goal_detail_support_widgets.dart';
import 'money_goal_formatters.dart';

class MoneyGoalDetailHeader extends StatelessWidget {
  const MoneyGoalDetailHeader({
    super.key,
    required this.goal,
    required this.progress,
  });

  final MoneyGoalDto goal;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final archived = isArchivedGoal(goal);
    final statusLabel = archived
        ? context.l10n.moneyGoalsStatusArchived
        : goal.reachedAt != null
        ? context.l10n.moneyGoalsStatusReached
        : context.l10n.moneyGoalsStatusActive;
    final statusColor = archived
        ? context.colors.border
        : goal.reachedAt != null
        ? context.colors.success
        : context.colors.warning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatGoalProgressLabel(context, goal),
                    style: TextStyle(color: context.colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            MoneyGoalStatusChip(
              label: statusLabel,
              color: statusColor,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              formatProgressPercent(progress),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: context.colors.surfaceMuted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
