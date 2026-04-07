import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/task_form.dart';
import '../../providers/tasks_provider.dart';
import 'task_filter.dart';

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

List<TaskSectionData> groupOpenTasks(
  BuildContext context,
  List<TaskDto> tasks,
) {
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
    TaskSectionData(title: context.l10n.tasksSectionOverdue, tasks: overdue),
    TaskSectionData(title: context.l10n.tasksSectionToday, tasks: today),
    TaskSectionData(title: context.l10n.tasksSectionUpcoming, tasks: upcoming),
    TaskSectionData(
      title: context.l10n.tasksSectionNoDueDate,
      tasks: noDueDate,
    ),
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

String taskFilterLabel(BuildContext context, TaskFilter filter) {
  return switch (filter) {
    TaskFilter.allOpen => context.l10n.tasksFilterAllOpen,
    TaskFilter.mine => context.l10n.tasksFilterMine,
    TaskFilter.unassigned => context.l10n.tasksFilterUnassigned,
    TaskFilter.dueSoon => context.l10n.tasksFilterDueSoon,
    TaskFilter.completed => context.l10n.tasksFilterCompletedArchive,
  };
}

String priorityLabel(BuildContext context, String value) {
  final l10n = context.l10n;
  return switch (TaskPriorityOptionX.fromWireValue(value)) {
    TaskPriorityOption.low => l10n.taskPriorityLow,
    TaskPriorityOption.normal => l10n.taskPriorityNormal,
    TaskPriorityOption.high => l10n.taskPriorityHigh,
  };
}

String historyLabel(BuildContext context, String value) {
  return switch (value) {
    'created' => context.l10n.tasksHistoryCreated,
    'updated' => context.l10n.tasksHistoryUpdated,
    'completed' => context.l10n.tasksHistoryCompleted,
    'deleted' => context.l10n.tasksHistoryDeleted,
    _ => value,
  };
}

String historyDetailsLabel(BuildContext context, String value) {
  return switch (value) {
    'Task created' => context.l10n.tasksHistoryDetailsCreated,
    'Task updated' => context.l10n.tasksHistoryDetailsUpdated,
    'Task completed' => context.l10n.tasksHistoryDetailsCompleted,
    'Task deleted' => context.l10n.tasksHistoryDetailsDeleted,
    'Task created from recurrence' =>
      context.l10n.tasksHistoryDetailsCreatedFromRecurrence,
    _ => value,
  };
}

String assigneeName(
  BuildContext context,
  int? profileId,
  List<FamilyMemberDto> members, {
  required int? currentProfileId,
}) {
  if (profileId == null) {
    return context.l10n.taskEditorUnassigned;
  }
  for (final member in members) {
    if (member.profileId == profileId) {
      return member.profileId == currentProfileId
          ? context.l10n.tasksAssigneeMemberYou(member.displayName)
          : member.displayName;
    }
  }
  return profileId == currentProfileId
      ? context.l10n.tasksAssigneeYou
      : context.l10n.tasksAssigneeUser(profileId);
}

FamilyMemberDto? memberForProfileId(
  int? profileId,
  List<FamilyMemberDto> members,
) {
  if (profileId == null) {
    return null;
  }
  for (final member in members) {
    if (member.profileId == profileId) {
      return member;
    }
  }
  return null;
}

String taskRecurrenceLabel(BuildContext context, TaskRecurrencePreset preset) {
  final l10n = context.l10n;
  return switch (preset) {
    TaskRecurrencePreset.none => l10n.taskRepeatNone,
    TaskRecurrencePreset.daily => l10n.taskRepeatDaily,
    TaskRecurrencePreset.weekly => l10n.taskRepeatWeekly,
    TaskRecurrencePreset.monthly => l10n.taskRepeatMonthly,
  };
}

String shortDueLabel(BuildContext context, TaskDto task) {
  return task.dueAt == null
      ? context.l10n.tasksNoDueDate
      : formatTaskDateTime(context, task.dueAt!);
}

String dueChipLabel(BuildContext context, DateTime? dueAt) {
  return dueAt == null
      ? context.l10n.tasksNoDueDate
      : context.l10n.tasksDueChip(formatTaskDateTime(context, dueAt));
}

String formatTaskDateTime(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMd(locale).add_Hm().format(value.toLocal());
}
