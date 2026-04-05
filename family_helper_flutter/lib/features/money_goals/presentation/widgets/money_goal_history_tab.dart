import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import 'money_goal_formatters.dart';

class MoneyGoalHistoryTab extends StatefulWidget {
  const MoneyGoalHistoryTab({
    super.key,
    required this.history,
    required this.isLoading,
  });

  final List<MoneyGoalHistoryEntryDto> history;
  final bool isLoading;

  @override
  State<MoneyGoalHistoryTab> createState() => _MoneyGoalHistoryTabState();
}

class _MoneyGoalHistoryTabState extends State<MoneyGoalHistoryTab> {
  static const _collapsedItemCount = 5;
  bool _isExpanded = false;

  @override
  void didUpdateWidget(covariant MoneyGoalHistoryTab oldWidget) {
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
            context.l10n.moneyGoalsRecentActivityTitle,
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
                context.l10n.moneyGoalsNoHistoryYet,
                style: TextStyle(color: context.colors.textSecondary),
              ),
            )
          else
            Column(
              children: [
                for (var index = 0; index < visibleHistory.length; index++) ...[
                  _MoneyGoalHistoryItem(entry: visibleHistory[index]),
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
                      child: Text(
                        _isExpanded
                            ? context.l10n.commonShowLess
                            : context.l10n.commonShowMore,
                      ),
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

class _MoneyGoalHistoryItem extends StatelessWidget {
  const _MoneyGoalHistoryItem({required this.entry});

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
                  formatHistoryHeadline(context, entry),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  formatShortDateTime(context, entry.createdAt),
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
