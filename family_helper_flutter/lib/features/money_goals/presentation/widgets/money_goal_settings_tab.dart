import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import 'money_goal_detail_support_widgets.dart';
import 'money_goal_formatters.dart';
import 'money_goal_forms.dart';

class MoneyGoalSettingsTab extends StatelessWidget {
  const MoneyGoalSettingsTab({
    super.key,
    required this.goal,
    required this.isUpdatingGoal,
    required this.isArchivingGoal,
    required this.isDeletingGoal,
    required this.onUpdateGoal,
    required this.onArchiveGoal,
    required this.onDeleteGoal,
  });

  final MoneyGoalDto goal;
  final bool isUpdatingGoal;
  final bool isArchivingGoal;
  final bool isDeletingGoal;
  final Future<bool> Function({
    required String title,
    required int targetAmountCents,
    String? description,
    DateTime? deadlineAt,
    required String currency,
  })
  onUpdateGoal;
  final VoidCallback onArchiveGoal;
  final VoidCallback onDeleteGoal;

  @override
  Widget build(BuildContext context) {
    final archived = isArchivedGoal(goal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.moneyGoalsGoalSettingsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        MoneyGoalSettingsForm(
          goal: goal,
          isSubmitting: isUpdatingGoal,
          isReadOnly: archived,
          onSubmit: onUpdateGoal,
        ),
        const SizedBox(height: 12),
        if (!archived) ...[
          MoneyGoalCompactActionButton(
            label: context.l10n.moneyGoalsArchiveGoalAction,
            variant: MoneyGoalCompactActionVariant.secondary,
            isLoading: isArchivingGoal,
            onPressed: onArchiveGoal,
          ),
          const SizedBox(height: 8),
        ],
        MoneyGoalCompactActionButton(
          label: context.l10n.moneyGoalsDeleteGoalAction,
          variant: MoneyGoalCompactActionVariant.danger,
          isLoading: isDeletingGoal,
          onPressed: onDeleteGoal,
        ),
      ],
    );
  }
}

class MoneyGoalActionMatrix extends StatelessWidget {
  const MoneyGoalActionMatrix({
    super.key,
    required this.buttons,
    required this.twoColumns,
  });

  final List<Widget> buttons;
  final bool twoColumns;

  @override
  Widget build(BuildContext context) {
    if (!twoColumns) {
      return Column(
        children: [
          for (var index = 0; index < buttons.length; index++) ...[
            buttons[index],
            if (index != buttons.length - 1) const SizedBox(height: 8),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (var index = 0; index < buttons.length; index += 2) {
      final left = buttons[index];
      final right = index + 1 < buttons.length ? buttons[index + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(child: left),
            if (right != null) ...[
              const SizedBox(width: 8),
              Expanded(child: right),
            ] else
              const Spacer(),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (var index = 0; index < rows.length; index++) ...[
          rows[index],
          if (index != rows.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}
