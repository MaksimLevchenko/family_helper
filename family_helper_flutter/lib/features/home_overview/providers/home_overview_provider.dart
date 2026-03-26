import 'package:family_helper_client/family_helper_client.dart';

import '../../calendar/providers/calendar_provider.dart';
import '../../lists/providers/lists_provider.dart';
import '../../money_goals/providers/money_goals_provider.dart';
import '../../tasks/providers/tasks_provider.dart';

class HomeOverviewState {
  const HomeOverviewState({
    required this.openTasks,
    required this.calendarItems,
    required this.listItems,
    required this.activeGoals,
    required this.upcomingEvents,
    required this.priorityTasks,
    required this.featuredListPendingItems,
    required this.isUsingCachedData,
    this.featuredGoal,
    this.featuredList,
    this.lastSuccessfulSyncAt,
  });

  final int openTasks;
  final int calendarItems;
  final int listItems;
  final int activeGoals;
  final List<CalendarInstanceDto> upcomingEvents;
  final List<TaskDto> priorityTasks;
  final MoneyGoalDto? featuredGoal;
  final FamilyListDto? featuredList;
  final int featuredListPendingItems;
  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
}

HomeOverviewState computeOverview({
  required TasksState tasks,
  required CalendarState calendar,
  required ListsState lists,
  required MoneyGoalsState goals,
}) {
  return HomeOverviewState(
    openTasks: tasks.tasks.where((task) => task.status != 'completed').length,
    calendarItems: calendar.instances.length,
    listItems: lists.lists.isEmpty
        ? lists.items.where((item) => !item.isBought).length
        : lists.lists
              .map((list) => list.pendingItemsCount ?? 0)
              .fold<int>(0, (sum, count) => sum + count),
    activeGoals: goals.activeGoals.length,
    upcomingEvents: _upcomingEvents(calendar),
    priorityTasks: _priorityTasks(tasks),
    featuredGoal: goals.activeGoals.isEmpty ? null : goals.activeGoals.first,
    featuredList: _featuredList(lists),
    featuredListPendingItems: _featuredListPendingItems(lists),
    isUsingCachedData:
        tasks.isUsingCachedData ||
        calendar.isUsingCachedData ||
        lists.isUsingCachedData ||
        goals.isUsingCachedData,
    lastSuccessfulSyncAt: _latestTimestamp([
      tasks.lastSuccessfulSyncAt,
      calendar.lastSuccessfulSyncAt,
      lists.lastSuccessfulSyncAt,
      goals.lastSuccessfulSyncAt,
    ]),
  );
}

DateTime? _latestTimestamp(List<DateTime?> values) {
  DateTime? latest;
  for (final value in values) {
    if (value == null) {
      continue;
    }
    if (latest == null || value.isAfter(latest)) {
      latest = value;
    }
  }
  return latest;
}

List<CalendarInstanceDto> _upcomingEvents(CalendarState calendar) {
  final now = DateTime.now().toUtc();
  final upcoming =
      calendar.instances
          .where(
            (instance) =>
                !instance.cancelled && !instance.occurrenceStart.isBefore(now),
          )
          .toList()
        ..sort(
          (left, right) =>
              left.occurrenceStart.compareTo(right.occurrenceStart),
        );
  return upcoming.take(3).toList(growable: false);
}

List<TaskDto> _priorityTasks(TasksState tasks) {
  final sorted = tasks.openTasks.toList()
    ..sort((left, right) {
      final rankCompare = _taskUrgencyRank(
        left,
      ).compareTo(_taskUrgencyRank(right));
      if (rankCompare != 0) {
        return rankCompare;
      }

      final leftDue = left.dueAt;
      final rightDue = right.dueAt;
      if (leftDue != null && rightDue != null) {
        final dueCompare = leftDue.compareTo(rightDue);
        if (dueCompare != 0) {
          return dueCompare;
        }
      } else if (leftDue != null) {
        return -1;
      } else if (rightDue != null) {
        return 1;
      }

      return right.updatedAt.compareTo(left.updatedAt);
    });
  return sorted.take(3).toList(growable: false);
}

int _taskUrgencyRank(TaskDto task) {
  if (_isTaskOverdue(task)) {
    return 0;
  }
  if (_isTaskDueToday(task)) {
    return 1;
  }
  if (task.dueAt != null) {
    return 2;
  }
  return 3;
}

bool _isTaskOverdue(TaskDto task) {
  final dueAt = task.dueAt;
  if (dueAt == null) {
    return false;
  }

  final now = DateTime.now().toUtc();
  return dueAt.isBefore(DateTime.utc(now.year, now.month, now.day));
}

bool _isTaskDueToday(TaskDto task) {
  final dueAt = task.dueAt;
  if (dueAt == null) {
    return false;
  }

  final localDue = dueAt.toLocal();
  final localNow = DateTime.now();
  return localDue.year == localNow.year &&
      localDue.month == localNow.month &&
      localDue.day == localNow.day;
}

FamilyListDto? _featuredList(ListsState lists) {
  final selectedList = lists.selectedList;
  if (selectedList != null) {
    return selectedList;
  }

  if (lists.lists.isEmpty) {
    return null;
  }

  final sortedLists = lists.lists.toList()
    ..sort((left, right) {
      final pendingCompare = (right.pendingItemsCount ?? 0).compareTo(
        left.pendingItemsCount ?? 0,
      );
      if (pendingCompare != 0) {
        return pendingCompare;
      }
      return right.updatedAt.compareTo(left.updatedAt);
    });
  return sortedLists.first;
}

int _featuredListPendingItems(ListsState lists) {
  final selectedList = lists.selectedList;
  if (selectedList != null) {
    if (lists.items.isNotEmpty) {
      return lists.items.where((item) => !item.isBought).length;
    }
    return selectedList.pendingItemsCount ?? 0;
  }

  return _featuredList(lists)?.pendingItemsCount ?? 0;
}
