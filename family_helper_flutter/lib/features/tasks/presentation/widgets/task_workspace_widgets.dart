import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../ui_kit/app_button.dart';
import '../../domain/task_form.dart';
import '../../providers/tasks_provider.dart';

enum TaskFilter { allOpen, mine, unassigned, dueSoon, completed }

class TasksToolbar extends StatelessWidget {
  const TasksToolbar({
    super.key,
    required this.state,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.onCreateTask,
  });

  final TasksState state;
  final TaskFilter currentFilter;
  final ValueChanged<TaskFilter> onFilterChanged;
  final VoidCallback? onCreateTask;

  @override
  Widget build(BuildContext context) {
    final openTasks = state.openTasks;
    final overdueCount = openTasks.where(isTaskOverdue).length;
    final dueTodayCount = openTasks.where(isTaskDueToday).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SummaryCard(title: 'Open', value: '${openTasks.length}'),
            SummaryCard(title: 'Due today', value: '$dueTodayCount'),
            SummaryCard(
              title: 'Overdue',
              value: '$overdueCount',
              accentColor: context.colors.warning,
            ),
            SummaryCard(
              title: 'Archive',
              value: '${state.completedTasks.length}',
              accentColor: context.colors.success,
            ),
          ],
        ),
        const SizedBox(height: 12),
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
                      label: Text(taskFilterLabel(filter)),
                      selected: filter == currentFilter,
                      onSelected: (_) => onFilterChanged(filter),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 160,
              child: AppButton(
                label: 'Create task',
                onPressed: onCreateTask,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TasksSidebar extends StatelessWidget {
  const TasksSidebar({
    super.key,
    required this.visibleTasks,
    required this.currentFilter,
    required this.selectedTaskId,
    required this.members,
    required this.currentProfileId,
    required this.isCompletingTask,
    required this.isOffline,
    this.isEmbedded = false,
    required this.onSelectTask,
    required this.onCompleteTask,
  });

  final List<TaskDto> visibleTasks;
  final TaskFilter currentFilter;
  final int? selectedTaskId;
  final List<FamilyMemberDto> members;
  final int? currentProfileId;
  final bool isCompletingTask;
  final bool isOffline;
  final bool isEmbedded;
  final ValueChanged<int> onSelectTask;
  final Future<void> Function(TaskDto task) onCompleteTask;

  @override
  Widget build(BuildContext context) {
    if (visibleTasks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: EmptyText(
            title: currentFilter == TaskFilter.completed
                ? 'Archive is empty'
                : 'No matching tasks',
            message: currentFilter == TaskFilter.completed
                ? 'Completed tasks will appear here.'
                : 'Adjust the filter or create a new task.',
          ),
        ),
      );
    }

    final sections = currentFilter == TaskFilter.completed
        ? [
            TaskSectionData(title: 'Completed archive', tasks: visibleTasks),
          ]
        : groupOpenTasks(visibleTasks);

    return ListView(
      key: const Key('tasks-sidebar'),
      shrinkWrap: isEmbedded,
      physics: isEmbedded
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      children: [
        for (
          var sectionIndex = 0;
          sectionIndex < sections.length;
          sectionIndex++
        )
          if (sections[sectionIndex].tasks.isNotEmpty) ...[
            SectionHeader(
              title: sections[sectionIndex].title,
              subtitle:
                  '${sections[sectionIndex].tasks.length} task${sections[sectionIndex].tasks.length == 1 ? '' : 's'}',
            ),
            const SizedBox(height: 8),
            for (
              var index = 0;
              index < sections[sectionIndex].tasks.length;
              index++
            ) ...[
              TaskListItem(
                task: sections[sectionIndex].tasks[index],
                isSelected:
                    sections[sectionIndex].tasks[index].id == selectedTaskId,
                assigneeName: assigneeName(
                  sections[sectionIndex].tasks[index].assigneeProfileId,
                  members,
                  currentProfileId: currentProfileId,
                ),
                isCompletingTask: isCompletingTask,
                isOffline: isOffline,
                onTap: () =>
                    onSelectTask(sections[sectionIndex].tasks[index].id),
                onComplete:
                    sections[sectionIndex].tasks[index].status == 'completed'
                    ? null
                    : () async {
                        await onCompleteTask(
                          sections[sectionIndex].tasks[index],
                        );
                      },
              ),
              if (index != sections[sectionIndex].tasks.length - 1)
                const SizedBox(height: 8),
            ],
            if (sectionIndex != sections.length - 1) const SizedBox(height: 16),
          ],
      ],
    );
  }
}

class TaskDetailPane extends StatelessWidget {
  const TaskDetailPane({
    super.key,
    required this.task,
    required this.history,
    required this.isHistoryLoading,
    required this.isBusy,
    required this.members,
    required this.currentProfileId,
    required this.isOffline,
    required this.onEditTask,
    required this.onCompleteTask,
  });

  final TaskDto? task;
  final List<TaskHistoryEntryDto> history;
  final bool isHistoryLoading;
  final bool isBusy;
  final List<FamilyMemberDto> members;
  final int? currentProfileId;
  final bool isOffline;
  final VoidCallback? onEditTask;
  final Future<void> Function()? onCompleteTask;

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Card(
        key: const Key('tasks-empty-detail'),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: EmptyText(
            title: 'Pick a task',
            message:
                'Select a task from the list to inspect details, history, and actions.',
          ),
        ),
      );
    }

    return Card(
      key: const Key('tasks-detail-card'),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                        task!.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        task!.status == 'completed'
                            ? 'Completed archive item'
                            : 'Open family task',
                        style: TextStyle(color: context.colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                StatusBadge(task: task!),
              ],
            ),
            if (task!.description != null &&
                task!.description!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                task!.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetaChip(label: 'Priority: ${priorityLabel(task!.priority)}'),
                MetaChip(
                  label:
                      'Assignee: ${assigneeName(task!.assigneeProfileId, members, currentProfileId: currentProfileId)}',
                ),
                MetaChip(label: task!.isPersonal ? 'Personal' : 'Shared'),
                MetaChip(label: dueChipLabel(task!.dueAt)),
                if (task!.recurrenceRrule != null)
                  MetaChip(
                    label:
                        'Repeats ${TaskRecurrencePresetX.fromTask(task!).label.toLowerCase()}',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: 160,
                  child: AppButton(
                    label: 'Complete',
                    onPressed: onCompleteTask == null || isBusy || isOffline
                        ? null
                        : () async {
                            await onCompleteTask!();
                          },
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: AppButton(
                    label: 'Edit task',
                    variant: AppButtonVariant.secondary,
                    onPressed: onEditTask == null || isBusy ? null : onEditTask,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('History', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SizedBox(
              height: 240,
              child: isHistoryLoading
                  ? const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : history.isEmpty
                  ? const EmptyText(
                      title: 'No history yet',
                      message: 'Task updates and completions will appear here.',
                    )
                  : ListView.separated(
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        return HistoryRow(entry: history[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
    required this.isSelected,
    required this.assigneeName,
    required this.isCompletingTask,
    required this.isOffline,
    required this.onTap,
    required this.onComplete,
  });

  final TaskDto task;
  final bool isSelected;
  final String assigneeName;
  final bool isCompletingTask;
  final bool isOffline;
  final VoidCallback onTap;
  final Future<void> Function()? onComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? context.colors.surfaceMuted : null,
      child: ListTile(
        key: Key('task-list-item-${task.id}'),
        onTap: onTap,
        title: Text(task.title),
        subtitle: Text(
          '$assigneeName - ${priorityLabel(task.priority)} - ${shortDueLabel(task)}',
        ),
        trailing: task.status == 'completed'
            ? const Icon(Icons.archive_outlined)
            : Checkbox(
                value: false,
                onChanged: isCompletingTask || isOffline || onComplete == null
                    ? null
                    : (_) async {
                        await onComplete!();
                      },
              ),
      ),
    );
  }
}

class HistoryRow extends StatelessWidget {
  const HistoryRow({super.key, required this.entry});

  final TaskHistoryEntryDto entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: context.colors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${entry.actorDisplayName} - ${historyLabel(entry.eventType)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(entry.details),
              const SizedBox(height: 4),
              Text(
                formatTaskDateTime(entry.createdAt),
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.task});

  final TaskDto task;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == 'completed';
    final color = isCompleted ? context.colors.success : context.colors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isCompleted ? 'Completed' : 'Open',
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class MetaChip extends StatelessWidget {
  const MetaChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.accentColor,
  });

  final String title;
  final String value;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? context.colors.primary;
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: context.colors.textSecondary)),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: context.colors.textSecondary)),
      ],
    );
  }
}

class NoFamilyTasksView extends StatelessWidget {
  const NoFamilyTasksView({super.key, required this.onOpenFamily});

  final VoidCallback onOpenFamily;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EmptyText(
              title: 'Choose a family first',
              message:
                  'Tasks are tied to the selected family. Open family settings to create or join one.',
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Open family settings',
              onPressed: onOpenFamily,
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyText extends StatelessWidget {
  const EmptyText({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.textSecondary),
        ),
      ],
    );
  }
}

class TaskSectionData {
  const TaskSectionData({
    required this.title,
    required this.tasks,
  });

  final String title;
  final List<TaskDto> tasks;
}

List<TaskDto> visibleTasksForFilter(
  TasksState state,
  int? currentProfileId,
  TaskFilter filter,
) {
  final now = DateTime.now().toUtc();
  final openTasks = state.openTasks;
  return switch (filter) {
    TaskFilter.allOpen => openTasks,
    TaskFilter.mine =>
      openTasks
          .where((task) => task.assigneeProfileId == currentProfileId)
          .toList(),
    TaskFilter.unassigned =>
      openTasks.where((task) => task.assigneeProfileId == null).toList(),
    TaskFilter.dueSoon =>
      openTasks
          .where(
            (task) =>
                task.dueAt != null &&
                !task.dueAt!.isAfter(now.add(const Duration(days: 7))),
          )
          .toList(),
    TaskFilter.completed =>
      state.completedTasks..sort((left, right) {
        final leftCompleted =
            left.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final rightCompleted =
            right.completedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return rightCompleted.compareTo(leftCompleted);
      }),
  };
}

TaskDto? resolvedSelectedTask(TasksState state, List<TaskDto> visibleTasks) {
  final selected = state.selectedTask;
  if (selected != null && visibleTasks.any((task) => task.id == selected.id)) {
    return selected;
  }
  return visibleTasks.isEmpty ? null : visibleTasks.first;
}

List<TaskSectionData> groupOpenTasks(List<TaskDto> tasks) {
  final overdue = <TaskDto>[];
  final today = <TaskDto>[];
  final upcoming = <TaskDto>[];
  final noDueDate = <TaskDto>[];

  for (final task in tasks) {
    if (task.dueAt == null) {
      noDueDate.add(task);
    } else if (isTaskOverdue(task)) {
      overdue.add(task);
    } else if (isTaskDueToday(task)) {
      today.add(task);
    } else {
      upcoming.add(task);
    }
  }

  overdue.sort(sortByDueThenUpdate);
  today.sort(sortByDueThenUpdate);
  upcoming.sort(sortByDueThenUpdate);
  noDueDate.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));

  return [
    TaskSectionData(title: 'Overdue', tasks: overdue),
    TaskSectionData(title: 'Today', tasks: today),
    TaskSectionData(title: 'Upcoming', tasks: upcoming),
    TaskSectionData(title: 'No due date', tasks: noDueDate),
  ];
}

int sortByDueThenUpdate(TaskDto left, TaskDto right) {
  final leftDue = left.dueAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  final rightDue = right.dueAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  final dueCompare = leftDue.compareTo(rightDue);
  if (dueCompare != 0) {
    return dueCompare;
  }
  return right.updatedAt.compareTo(left.updatedAt);
}

bool isTaskOverdue(TaskDto task) {
  if (task.dueAt == null) {
    return false;
  }
  final now = DateTime.now().toUtc();
  return task.dueAt!.isBefore(DateTime.utc(now.year, now.month, now.day));
}

bool isTaskDueToday(TaskDto task) {
  if (task.dueAt == null) {
    return false;
  }
  return DateUtils.isSameDay(task.dueAt!.toLocal(), DateTime.now());
}

String taskFilterLabel(TaskFilter filter) {
  return switch (filter) {
    TaskFilter.allOpen => 'All open',
    TaskFilter.mine => 'Mine',
    TaskFilter.unassigned => 'Unassigned',
    TaskFilter.dueSoon => 'Due soon',
    TaskFilter.completed => 'Completed archive',
  };
}

String priorityLabel(String value) {
  return TaskPriorityOptionX.fromWireValue(value).label;
}

String historyLabel(String value) {
  return switch (value) {
    'created' => 'Created',
    'updated' => 'Updated',
    'completed' => 'Completed',
    _ => value,
  };
}

String assigneeName(
  int? profileId,
  List<FamilyMemberDto> members, {
  required int? currentProfileId,
}) {
  if (profileId == null) {
    return 'Unassigned';
  }
  for (final member in members) {
    if (member.profileId == profileId) {
      return member.profileId == currentProfileId
          ? '${member.displayName} (You)'
          : member.displayName;
    }
  }
  return profileId == currentProfileId ? 'You' : 'User #$profileId';
}

String shortDueLabel(TaskDto task) {
  return task.dueAt == null ? 'No due date' : formatTaskDateTime(task.dueAt!);
}

String dueChipLabel(DateTime? dueAt) {
  return dueAt == null ? 'No due date' : 'Due ${formatTaskDateTime(dueAt)}';
}

String formatTaskDateTime(DateTime value) {
  final local = value.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$month/$day ${local.year} $hour:$minute';
}
