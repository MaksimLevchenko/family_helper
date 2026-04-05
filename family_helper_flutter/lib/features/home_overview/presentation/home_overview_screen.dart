import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../calendar/providers/calendar_provider.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../lists/providers/lists_provider.dart';
import '../../money_goals/providers/money_goals_provider.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../../tasks/providers/tasks_provider.dart';
import '../providers/home_overview_provider.dart';
import 'widgets/family_dashboard.dart';
import 'widgets/home_overview_support_widgets.dart';
import 'widgets/no_family_home_state.dart';

const _wideLayoutBreakpoint = 720.0;
const _maxWidthBreakpoint = 1100.0;
const _maxContentWidth = 1280.0;

class HomeOverviewScreen extends StatelessWidget {
  const HomeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final familyId = context.watch<FamilySelectionCubit>().state;
    final familyState =
        context.watch<FamilyMembersCubit?>()?.state ??
        FamilyMembersState.initial(familyId: familyId);
    final hasFamily = familyId != null;
    final tasks = context.watch<TasksCubit>().state;
    final calendar = context.watch<CalendarCubit>().state;
    final lists = context.watch<ListsCubit>().state;
    final goals = context.watch<MoneyGoalsCubit>().state;
    final notifications = context.watch<NotificationsCubit>().state;

    final overview = computeOverview(
      tasks: tasks,
      calendar: calendar,
      lists: lists,
      goals: goals,
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: serverStatusAppBar(context, title: Text(context.l10n.homeTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
            final maxWidth = constraints.maxWidth >= _maxWidthBreakpoint
                ? _maxContentWidth
                : double.infinity;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: hasFamily
                    ? FamilyDashboard(
                        overview: overview,
                        familyState: familyState,
                        notifications: notifications,
                        isWide: isWide,
                        summaryItems: _summaryItems(context, overview),
                      )
                    : NoFamilyHomeState(isWide: isWide),
              ),
            );
          },
        ),
      ),
    );
  }

  List<HomeSummaryItem> _summaryItems(
    BuildContext context,
    HomeOverviewState overview,
  ) {
    final l10n = context.l10n;
    return [
      HomeSummaryItem(
        title: l10n.homeTasks,
        value: '${overview.openTasks}',
        description: l10n.homeTasksDescription,
        icon: Icons.task_alt_rounded,
        route: AppRoutes.tasks,
        key: 'tasks',
      ),
      HomeSummaryItem(
        title: l10n.homeCalendar,
        value: '${overview.calendarItems}',
        description: l10n.homeCalendarDescription,
        icon: Icons.calendar_month_rounded,
        route: AppRoutes.calendar,
        key: 'calendar',
      ),
      HomeSummaryItem(
        title: l10n.homeLists,
        value: '${overview.listItems}',
        description: l10n.homeListsDescription,
        icon: Icons.list_alt_rounded,
        route: AppRoutes.lists,
        key: 'lists',
      ),
      HomeSummaryItem(
        title: l10n.homeGoals,
        value: '${overview.activeGoals}',
        description: l10n.homeGoalsDescription,
        icon: Icons.savings_rounded,
        route: AppRoutes.goals,
        key: 'goals',
      ),
    ];
  }
}
