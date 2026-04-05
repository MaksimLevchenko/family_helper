import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../calendar/providers/calendar_provider.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../lists/providers/lists_provider.dart';
import '../../money_goals/providers/money_goals_provider.dart';
import '../../tasks/providers/tasks_provider.dart';
import 'notification_target.dart';

class NotificationNavigationService {
  const NotificationNavigationService._();

  static Future<void> openTarget(
    BuildContext context,
    NotificationOpenTarget target,
  ) async {
    final familySelectionCubit = context.read<FamilySelectionCubit>();
    final tasksCubit = context.read<TasksCubit>();
    final listsCubit = context.read<ListsCubit>();
    final moneyGoalsCubit = context.read<MoneyGoalsCubit>();
    final calendarCubit = context.read<CalendarCubit>();
    final goRouter = GoRouter.of(context);
    if (familySelectionCubit.state != target.familyId) {
      await familySelectionCubit.setFamilyId(target.familyId);
      await Future<void>.delayed(Duration.zero);
    }

    final route = _resolveRoute(target);
    goRouter.go(route);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    switch (target.entityType) {
      case 'task':
        tasksCubit.setCurrentTask(target.entityId);
        return;
      case 'list':
        try {
          await listsCubit.selectList(target.entityId);
        } catch (_) {
          return;
        }
        return;
      case 'goal':
        moneyGoalsCubit.setCurrentGoal(target.entityId);
        return;
      case 'calendar':
        calendarCubit.selectDay(
          target.occurrenceStart ?? DateTime.now(),
        );
        return;
      default:
        return;
    }
  }

  static String routeForTarget(NotificationOpenTarget target) {
    return _resolveRoute(target);
  }

  static String _resolveRoute(NotificationOpenTarget target) {
    final explicitRoute = target.route?.trim();
    if (explicitRoute != null && explicitRoute.isNotEmpty) {
      return explicitRoute;
    }
    return defaultRouteForNotificationEntityType(target.entityType) ??
        defaultRouteForNotificationEntityType('notification')!;
  }
}
