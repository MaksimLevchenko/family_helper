import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../calendar/providers/calendar_provider.dart';
import '../../lists/providers/lists_provider.dart';
import '../../money_goals/providers/money_goals_provider.dart';
import '../../tasks/providers/tasks_provider.dart';
import '../providers/home_overview_provider.dart';

class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tasks = context.watch<TasksCubit>().state;
    final calendar = context.watch<CalendarCubit>().state;
    final lists = context.watch<ListsCubit>().state;
    final goals = context.watch<MoneyGoalsCubit>().state;

    final overview = computeOverview(
      tasks: tasks,
      calendar: calendar,
      lists: lists,
      goals: goals,
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Overview')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTile(
            title: 'Open tasks',
            subtitle: '${overview.openTasks}',
          ),
          AppTile(
            title: 'Calendar instances',
            subtitle: '${overview.calendarItems}',
          ),
          AppTile(
            title: 'Pending list items',
            subtitle: '${overview.listItems}',
          ),
          AppTile(
            title: 'Active money goals',
            subtitle: '${overview.activeGoals}',
          ),
          const SizedBox(height: 12),
          const AppBanner(
            text: 'Realtime invalidation and sync are active for selected family.',
          ),
        ],
      ),
    );
  }
}
