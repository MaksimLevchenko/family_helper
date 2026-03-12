import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'money_goal_formatters.dart';

class MoneyGoalListItem extends StatelessWidget {
  const MoneyGoalListItem({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  final MoneyGoalDto goal;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = goalProgressValue(goal);

    return Card(
      key: Key('goal-list-item-${goal.id}'),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? context.colors.primary : context.colors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formatProgressPercent(progress),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                formatGoalProgressLabel(goal),
                style: TextStyle(color: context.colors.textSecondary),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: context.colors.surfaceMuted,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _GoalMetaChip(
                    label: isArchivedGoal(goal)
                        ? 'Archived'
                        : goal.reachedAt != null
                        ? 'Reached'
                        : 'Remaining ${formatRemainingAmount(goal)}',
                    color: isArchivedGoal(goal)
                        ? context.colors.border
                        : goal.reachedAt != null
                        ? context.colors.success
                        : context.colors.warning,
                    textColor: context.colors.textPrimary,
                  ),
                  if (goal.deadlineAt != null)
                    _GoalMetaChip(
                      label: 'Deadline ${formatShortDate(goal.deadlineAt!)}',
                      color: context.colors.surfaceMuted,
                      textColor: context.colors.textPrimary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalMetaChip extends StatelessWidget {
  const _GoalMetaChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
