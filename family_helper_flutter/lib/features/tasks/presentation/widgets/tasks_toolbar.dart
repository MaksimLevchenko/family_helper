import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/app_button.dart';
import '../../providers/tasks_provider.dart';
import 'task_filter.dart';
import 'task_workspace_common_widgets.dart';
import 'task_workspace_utils.dart';

class TasksToolbar extends StatelessWidget {
  const TasksToolbar({
    super.key,
    required this.state,
    this.isCompact = false,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.onCreateTask,
  });

  final TasksState state;
  final bool isCompact;
  final TaskFilter currentFilter;
  final ValueChanged<TaskFilter> onFilterChanged;
  final VoidCallback? onCreateTask;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final openTasks = state.openTasks;
    final overdueCount = openTasks.where(isTaskOverdue).length;
    final dueTodayCount = openTasks.where(isTaskDueToday).length;
    final summaryCards = [
      SummaryCard(
        title: l10n.tasksSummaryOpen,
        value: '${openTasks.length}',
        isCompact: isCompact,
      ),
      SummaryCard(
        title: l10n.tasksSummaryDueToday,
        value: '$dueTodayCount',
        isCompact: isCompact,
      ),
      SummaryCard(
        title: l10n.tasksSummaryOverdue,
        value: '$overdueCount',
        accentColor: context.colors.warning,
        isCompact: isCompact,
      ),
      SummaryCard(
        title: l10n.tasksSummaryArchive,
        value: '${state.completedTasks.length}',
        accentColor: context.colors.success,
        isCompact: isCompact,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isCompact)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var index = 0; index < summaryCards.length; index++) ...[
                  summaryCards[index],
                  if (index != summaryCards.length - 1)
                    const SizedBox(width: 8),
                ],
              ],
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: summaryCards,
          ),
        SizedBox(height: isCompact ? 10 : 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final filter in TaskFilter.values)
                    ChoiceChip(
                      key: Key('tasks-filter-${filter.name}'),
                      label: Text(taskFilterLabel(context, filter)),
                      selected: filter == currentFilter,
                      onSelected: (_) => onFilterChanged(filter),
                    ),
                ],
              ),
            ),
            SizedBox(width: isCompact ? 8 : 12),
            SizedBox(
              width: isCompact ? 136 : 160,
              child: AppButton(
                label: l10n.taskEditorCreateAction,
                onPressed: onCreateTask,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
