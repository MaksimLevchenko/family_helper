import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';

enum GoalDetailTab { overview, history, settings }

class MoneyGoalDetailTabBar extends StatelessWidget {
  const MoneyGoalDetailTabBar({
    super.key,
    required this.currentTab,
    required this.onChanged,
  });

  final GoalDetailTab currentTab;
  final ValueChanged<GoalDetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          for (final tab in GoalDetailTab.values)
            Expanded(
              child: _TabButton(
                tab: tab,
                isSelected: tab == currentTab,
                onTap: () => onChanged(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final GoalDetailTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? context.colors.background : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: Key('goal-detail-tab-${tab.name}'),
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            switch (tab) {
              GoalDetailTab.overview => context.l10n.commonOverview,
              GoalDetailTab.history => context.l10n.commonHistory,
              GoalDetailTab.settings => context.l10n.commonSettings,
            },
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? context.colors.textPrimary
                  : context.colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
