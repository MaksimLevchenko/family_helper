import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../money_goals/presentation/widgets/money_goal_formatters.dart';
import 'home_overview_support_widgets.dart';

class GoalSpotlightCard extends StatelessWidget {
  const GoalSpotlightCard({super.key, required this.goal});

  final MoneyGoalDto? goal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (goal == null) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeSavingsSpotlight,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              HomeOverviewSectionEmptyState(
                title: l10n.homeNoGoalsTitle,
                message: l10n.homeNoGoalsMessage,
              ),
            ],
          ),
        ),
      );
    }

    final progress = goalProgressValue(goal!);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeSavingsSpotlight,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              goal!.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatGoalProgressLabel(context, goal!),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: progress,
                backgroundColor: scheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                HomeOverviewMetaBadge(label: formatProgressPercent(progress)),
                HomeOverviewMetaBadge(
                  label: l10n.homeGoalLeft(formatRemainingAmount(goal!)),
                ),
              ],
            ),
            if (goal!.deadlineAt != null) ...[
              const SizedBox(height: 12),
              Text(
                l10n.homeDeadline(formatShortDate(context, goal!.deadlineAt!)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => context.go(AppRoutes.goals),
              child: Text(l10n.homeOpenGoals),
            ),
          ],
        ),
      ),
    );
  }
}
