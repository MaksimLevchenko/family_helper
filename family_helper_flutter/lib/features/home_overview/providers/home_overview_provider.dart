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
    required this.isUsingCachedData,
    this.lastSuccessfulSyncAt,
  });

  final int openTasks;
  final int calendarItems;
  final int listItems;
  final int activeGoals;
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
