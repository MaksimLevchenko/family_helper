import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'money_goal_formatters.dart';
import 'money_goal_forms.dart';

enum _GoalDetailTab { overview, history, settings }

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
  _GoalDetailTab _currentTab = _GoalDetailTab.overview;

  @override
  void didUpdateWidget(covariant MoneyGoalDetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goal.id != widget.goal.id) {
      _currentTab = _GoalDetailTab.overview;
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
            _GoalHeader(
              goal: goal,
              progress: progress,
            ),
            const SizedBox(height: 12),
            _GoalTabBar(
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
                _GoalDetailTab.overview => _OverviewTab(
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
                _GoalDetailTab.history => _HistoryTab(
                  key: const ValueKey('history-tab'),
                  history: widget.history,
                  isLoading: widget.isHistoryLoading,
                ),
                _GoalDetailTab.settings => _SettingsTab(
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

class _GoalHeader extends StatelessWidget {
  const _GoalHeader({
    required this.goal,
    required this.progress,
  });

  final MoneyGoalDto goal;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final archived = isArchivedGoal(goal);
    final statusLabel = archived
        ? 'Archived'
        : goal.reachedAt != null
        ? 'Reached'
        : 'Active';
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
                    formatGoalProgressLabel(goal),
                    style: TextStyle(color: context.colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _StatusChip(
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

class _GoalTabBar extends StatelessWidget {
  const _GoalTabBar({
    required this.currentTab,
    required this.onChanged,
  });

  final _GoalDetailTab currentTab;
  final ValueChanged<_GoalDetailTab> onChanged;

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
          for (final tab in _GoalDetailTab.values)
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

  final _GoalDetailTab tab;
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
              _GoalDetailTab.overview => 'Overview',
              _GoalDetailTab.history => 'History',
              _GoalDetailTab.settings => 'Settings',
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

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
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
      _CompactMetric(
        label: 'Remaining',
        value: formatRemainingAmount(goal),
      ),
      _CompactMetric(
        label: goal.reachedAt != null ? 'Reached' : 'Updated',
        value: goal.reachedAt != null
            ? formatShortDate(goal.reachedAt!)
            : formatShortDateTime(goal.updatedAt),
      ),
      if (goal.deadlineAt != null)
        _CompactMetric(
          label: 'Deadline',
          value: formatShortDate(goal.deadlineAt!),
        ),
    ];

    final actionButtons = <Widget>[
      if (!archived)
        _CompactActionButton(
          label: 'Add contribution',
          isLoading: isAddingContribution,
          onPressed: onAddContribution,
        ),
      if (!archived)
        _CompactActionButton(
          label: 'Withdraw money',
          variant: _CompactActionVariant.secondary,
          isLoading: isWithdrawingFunds,
          onPressed: onWithdrawFunds,
        ),
      if (!archived)
        _CompactActionButton(
          label: 'Complete and archive',
          variant: _CompactActionVariant.secondary,
          isLoading: isArchivingGoal,
          onPressed: onArchiveGoal,
        ),
      _CompactActionButton(
        label: 'New goal',
        variant: _CompactActionVariant.secondary,
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
                'Progress',
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
            return _ActionMatrix(
              buttons: actionButtons,
              twoColumns: twoColumns,
            );
          },
        ),
      ],
    );
  }
}

class _HistoryTab extends StatefulWidget {
  const _HistoryTab({
    super.key,
    required this.history,
    required this.isLoading,
  });

  final List<MoneyGoalHistoryEntryDto> history;
  final bool isLoading;

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  static const _collapsedItemCount = 5;
  bool _isExpanded = false;

  @override
  void didUpdateWidget(covariant _HistoryTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.history != widget.history) {
      _isExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleHistory =
        _isExpanded || widget.history.length <= _collapsedItemCount
        ? widget.history
        : widget.history.take(_collapsedItemCount).toList();

    return Container(
      key: const Key('money-goal-history-section'),
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
            'Recent activity',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          if (widget.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No contributions or withdrawals yet.',
                style: TextStyle(color: context.colors.textSecondary),
              ),
            )
          else
            Column(
              children: [
                for (var index = 0; index < visibleHistory.length; index++) ...[
                  _GoalHistoryItem(entry: visibleHistory[index]),
                  if (index != visibleHistory.length - 1)
                    const SizedBox(height: 8),
                ],
                if (widget.history.length > _collapsedItemCount) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      key: const Key('goal-history-show-more-button'),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(_isExpanded ? 'Show less' : 'Show more'),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
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
          'Goal settings',
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
          _CompactActionButton(
            label: 'Archive goal',
            variant: _CompactActionVariant.secondary,
            isLoading: isArchivingGoal,
            onPressed: onArchiveGoal,
          ),
          const SizedBox(height: 8),
        ],
        _CompactActionButton(
          label: 'Delete goal',
          variant: _CompactActionVariant.danger,
          isLoading: isDeletingGoal,
          onPressed: onDeleteGoal,
        ),
      ],
    );
  }
}

class _ActionMatrix extends StatelessWidget {
  const _ActionMatrix({
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

class _GoalHistoryItem extends StatelessWidget {
  const _GoalHistoryItem({required this.entry});

  final MoneyGoalHistoryEntryDto entry;

  @override
  Widget build(BuildContext context) {
    final isWithdrawal = isWithdrawalHistoryEntry(entry);
    final amountColor = isWithdrawal
        ? context.colors.danger
        : context.colors.success;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatHistoryHeadline(entry),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  formatShortDateTime(entry.createdAt),
                  style: TextStyle(color: context.colors.textSecondary),
                ),
                if (entry.note != null && entry.note!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.note!,
                    style: TextStyle(color: context.colors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            formatMoneyCents(entry.amountCents, entry.currency),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 132),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

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
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

enum _CompactActionVariant { primary, secondary, danger }

class _CompactActionButton extends StatelessWidget {
  const _CompactActionButton({
    required this.label,
    required this.onPressed,
    this.variant = _CompactActionVariant.primary,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final _CompactActionVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final background = switch (variant) {
      _CompactActionVariant.primary => context.colors.primary,
      _CompactActionVariant.secondary => context.colors.secondary,
      _CompactActionVariant.danger => context.colors.danger,
    };

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: context.colors.background,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
