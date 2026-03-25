import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/routing/app_routes.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/calendar/providers/calendar_provider.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:family_helper_flutter/features/home_overview/presentation/home_overview_screen.dart';
import 'package:family_helper_flutter/features/lists/providers/lists_provider.dart';
import 'package:family_helper_flutter/features/money_goals/providers/money_goals_provider.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:family_helper_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:family_helper_flutter/features/tasks/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _TasksCubitStub extends Cubit<TasksState> implements TasksCubit {
  _TasksCubitStub(super.initialState);

  @override
  Future<void> complete(TaskDto task) async {}

  @override
  Future<TaskDto?> createTask({
    required String title,
    required bool isPersonal,
    DateTime? dueAt,
    bool recurringOnComplete = false,
  }) async => null;

  @override
  Future<void> reload() async {}

  @override
  void reset() => emit(TasksState.initial());
}

class _CalendarCubitStub extends Cubit<CalendarState> implements CalendarCubit {
  _CalendarCubitStub(super.initialState);

  @override
  Future<void> cancelOccurrence(CalendarInstanceDto instance) async {}

  @override
  Future<CalendarEventDto?> createEvent({
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    String? rrule,
  }) async => null;

  @override
  Future<void> reload() async {}

  @override
  void reset() => emit(CalendarState.initial());
}

class _ListsCubitStub extends Cubit<ListsState> implements ListsCubit {
  _ListsCubitStub(super.initialState);

  @override
  Future<void> addItem({
    required String title,
    double qty = 1,
    String? unit,
    int? priceCents,
  }) async {}

  @override
  Future<void> createList(String title, {String listType = 'shopping'}) async {}

  @override
  Future<void> reload() async {}

  @override
  Future<void> reorderDescending() async {}

  @override
  void reset() => emit(ListsState.initial());

  @override
  void setCurrentList(int listId) {}

  @override
  Future<void> toggleBought(ListItemDto item) async {}
}

class _MoneyGoalsCubitStub extends Cubit<MoneyGoalsState>
    implements MoneyGoalsCubit {
  _MoneyGoalsCubitStub(super.initialState);

  @override
  Future<bool> addContribution({
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) async => true;

  @override
  Future<bool> archiveCurrentGoal() async => true;

  @override
  Future<bool> createGoal({
    required String title,
    required int targetAmountCents,
    String currency = 'RUB',
  }) async => true;

  @override
  Future<bool> updateCurrentGoal({
    required String title,
    required int targetAmountCents,
    String? description,
    DateTime? deadlineAt,
    String currency = 'RUB',
  }) async => true;

  @override
  Future<bool> deleteCurrentGoal() async => true;

  @override
  Future<void> reload() async {}

  @override
  void reset({bool hasSelectedFamily = false}) {
    emit(MoneyGoalsState.initial(hasSelectedFamily: hasSelectedFamily));
  }

  @override
  void setCurrentGoal(int goalId) {}

  @override
  Future<bool> withdrawFunds({
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) async => true;
}

class _NotificationsCubitStub extends Cubit<NotificationsState>
    implements NotificationsCubit {
  _NotificationsCubitStub(super.initialState);

  @override
  Future<ReminderActionResult> ensureReminder({
    required String notificationType,
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async => ReminderActionResult.successResult;

  @override
  bool isPreferenceEnabled(String notificationType) => false;

  @override
  Future<void> loadPreferences() async {}

  @override
  Future<bool> openSystemNotificationSettings() async => true;

  @override
  Future<NotificationPermissionStatus> requestSystemPermission() async {
    return state.permissionStatus;
  }

  @override
  Future<NotificationPermissionStatus> requestSystemPermissionIfNeeded() async {
    return state.permissionStatus;
  }

  @override
  Future<void> refreshPermissionStatus() async {}

  @override
  Future<void> registerPushToken({
    required String token,
    String? platform,
  }) async {}

  @override
  Future<void> reloadReminders({String? status}) async {}

  @override
  void reset({bool preserveAccountSettings = false}) {
    emit(NotificationsState.initial());
  }

  @override
  Future<ReminderActionResult> scheduleReminder({
    required String entityType,
    required int entityId,
    required DateTime remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async => ReminderActionResult.successResult;

  @override
  Future<bool> setPreference({
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) async => true;
}

class _TestFamilySelectionCubit extends FamilySelectionCubit {
  _TestFamilySelectionCubit(int? initialFamilyId) : super() {
    emit(initialFamilyId);
  }

  @override
  Future<void> bootstrap() async {}
}

Widget _buildSubject({
  required int? familyId,
  required TasksState tasksState,
  required CalendarState calendarState,
  required ListsState listsState,
  required MoneyGoalsState moneyGoalsState,
}) {
  final router = GoRouter(
    initialLocation: AppRoutes.overview,
    routes: [
      GoRoute(
        path: AppRoutes.overview,
        builder: (context, state) => const HomeOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.family,
        builder: (context, state) =>
            const Scaffold(body: Text('Family settings page')),
      ),
    ],
  );

  return MultiBlocProvider(
    providers: [
      BlocProvider<FamilySelectionCubit>(
        create: (_) => _TestFamilySelectionCubit(familyId),
      ),
      BlocProvider<TasksCubit>(create: (_) => _TasksCubitStub(tasksState)),
      BlocProvider<CalendarCubit>(
        create: (_) => _CalendarCubitStub(calendarState),
      ),
      BlocProvider<ListsCubit>(create: (_) => _ListsCubitStub(listsState)),
      BlocProvider<MoneyGoalsCubit>(
        create: (_) => _MoneyGoalsCubitStub(moneyGoalsState),
      ),
      BlocProvider<NotificationsCubit>(
        create: (_) => _NotificationsCubitStub(NotificationsState.initial()),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light(),
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows empty state and CTA when no family is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildSubject(
        familyId: null,
        tasksState: TasksState.initial(),
        calendarState: const CalendarState(isLoading: false, instances: []),
        listsState: const ListsState(isLoading: false, items: []),
        moneyGoalsState: MoneyGoalsState.initial(hasSelectedFamily: false),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No family yet'), findsOneWidget);
    expect(find.text('Add family'), findsOneWidget);
    expect(find.text('Open tasks'), findsNothing);
    expect(find.text('Stay on top of family reminders'), findsNothing);
  });

  testWidgets('opens family settings from the no-family CTA', (tester) async {
    await tester.pumpWidget(
      _buildSubject(
        familyId: null,
        tasksState: TasksState.initial(),
        calendarState: CalendarState.initial(),
        listsState: ListsState.initial(),
        moneyGoalsState: MoneyGoalsState.initial(hasSelectedFamily: false),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add family'));
    await tester.pumpAndSettle();

    expect(find.text('Family settings page'), findsOneWidget);
  });

  testWidgets('shows overview content when a family is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildSubject(
        familyId: 42,
        tasksState: TasksState.initial(),
        calendarState: const CalendarState(isLoading: false, instances: []),
        listsState: const ListsState(isLoading: false, items: []),
        moneyGoalsState: MoneyGoalsState.initial(
          hasSelectedFamily: true,
        ).copyWith(isInitialLoading: false),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Open tasks'), findsOneWidget);
    expect(find.text('No family yet'), findsNothing);
  });
}
