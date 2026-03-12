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
  });

  final int openTasks;
  final int calendarItems;
  final int listItems;
  final int activeGoals;
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
    listItems: lists.items.where((item) => !item.isBought).length,
    activeGoals: goals.activeGoals.length,
  );
}
