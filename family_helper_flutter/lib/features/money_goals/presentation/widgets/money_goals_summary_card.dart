import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'money_goal_formatters.dart';

class MoneyGoalsSummaryCard extends StatelessWidget {
  const MoneyGoalsSummaryCard({
    super.key,
    required this.goals,
  });

  final List<MoneyGoalDto> goals;

  @override
  Widget build(BuildContext context) {
    final activeGoals = goals.where((goal) => goal.archivedAt == null).length;
    final archivedGoals = goals.where((goal) => goal.archivedAt != null).length;
    final completedGoals = goals.where((goal) => goal.reachedAt != null).length;
    final totalSaved = goals.fold<int>(
      0,
      (sum, goal) => sum + goal.currentAmountCents,
    );
    final primaryCurrency = goals.isEmpty ? 'RUB' : goals.first.currency;

    return Card(
      key: const Key('money-goals-summary-card'),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goals snapshot',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryMetric(
                  label: 'Active goals',
                  value: '$activeGoals',
                ),
                _SummaryMetric(
                  label: 'Archived',
                  value: '$archivedGoals',
                ),
                _SummaryMetric(
                  label: 'Completed',
                  value: '$completedGoals',
                ),
                _SummaryMetric(
                  label: 'Saved total',
                  value: formatMoneyCents(totalSaved, primaryCurrency),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
