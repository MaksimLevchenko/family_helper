import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import 'money_goal_detail_header.dart';
import 'money_goal_detail_tabs.dart';
import 'money_goal_formatters.dart';
import 'money_goal_history_tab.dart';
import 'money_goal_overview_tab.dart';
import 'money_goal_settings_tab.dart';

class MoneyGoalDetailCard extends StatefulWidget {
  const MoneyGoalDetailCard({
    super.key,
    required this.goal,
    required this.history,
    required this.isHistoryLoading,
    required this.isUpdatingGoal,
    required this.isAddingContribution,
    required this.isWithdrawingFunds,
    required this.isCreatingGoal,
    required this.isArchivingGoal,
    required this.isDeletingGoal,
    required this.onAddContribution,
    required this.onWithdrawFunds,
    required this.onArchiveGoal,
    required this.onDeleteGoal,
    required this.onCreateGoal,
    required this.onUpdateGoal,
  });

  final MoneyGoalDto goal;
  final List<MoneyGoalHistoryEntryDto> history;
  final bool isHistoryLoading;
  final bool isUpdatingGoal;
  final bool isAddingContribution;
  final bool isWithdrawingFunds;
  final bool isCreatingGoal;
  final bool isArchivingGoal;
  final bool isDeletingGoal;
  final VoidCallback onAddContribution;
  final VoidCallback onWithdrawFunds;
  final VoidCallback onArchiveGoal;
  final VoidCallback onDeleteGoal;
  final VoidCallback onCreateGoal;
  final Future<bool> Function({
    required String title,
    required int targetAmountCents,
    String? description,
    DateTime? deadlineAt,
    required String currency,
  })
  onUpdateGoal;

  @override
  State<MoneyGoalDetailCard> createState() => _MoneyGoalDetailCardState();
}

class _MoneyGoalDetailCardState extends State<MoneyGoalDetailCard> {
  GoalDetailTab _currentTab = GoalDetailTab.overview;

  @override
  void didUpdateWidget(covariant MoneyGoalDetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goal.id != widget.goal.id) {
      _currentTab = GoalDetailTab.overview;
    }
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final progress = goalProgressValue(goal);
    final archived = isArchivedGoal(goal);

    return Card(
      key: const Key('money-goal-detail-card'),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MoneyGoalDetailHeader(
              goal: goal,
              progress: progress,
            ),
            const SizedBox(height: 12),
            MoneyGoalDetailTabBar(
              currentTab: _currentTab,
              onChanged: (tab) {
                setState(() {
                  _currentTab = tab;
                });
              },
            ),
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: switch (_currentTab) {
                GoalDetailTab.overview => MoneyGoalOverviewTab(
                  key: const ValueKey('overview-tab'),
                  goal: goal,
                  archived: archived,
                  progress: progress,
                  isAddingContribution: widget.isAddingContribution,
                  isWithdrawingFunds: widget.isWithdrawingFunds,
                  isCreatingGoal: widget.isCreatingGoal,
                  isArchivingGoal: widget.isArchivingGoal,
                  onAddContribution: widget.onAddContribution,
                  onWithdrawFunds: widget.onWithdrawFunds,
                  onArchiveGoal: widget.onArchiveGoal,
                  onCreateGoal: widget.onCreateGoal,
                ),
                GoalDetailTab.history => MoneyGoalHistoryTab(
                  key: const ValueKey('history-tab'),
                  history: widget.history,
                  isLoading: widget.isHistoryLoading,
                ),
                GoalDetailTab.settings => MoneyGoalSettingsTab(
                  key: ValueKey('settings-tab-${goal.id}-${goal.version}'),
                  goal: goal,
                  isUpdatingGoal: widget.isUpdatingGoal,
                  isArchivingGoal: widget.isArchivingGoal,
                  isDeletingGoal: widget.isDeletingGoal,
                  onUpdateGoal: widget.onUpdateGoal,
                  onArchiveGoal: widget.onArchiveGoal,
                  onDeleteGoal: widget.onDeleteGoal,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
