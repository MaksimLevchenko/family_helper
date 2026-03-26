import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/routing/app_routes.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/calendar/domain/calendar_event_form.dart';
import 'package:family_helper_flutter/features/calendar/providers/calendar_provider.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:family_helper_flutter/features/home_overview/presentation/home_overview_screen.dart';
import 'package:family_helper_flutter/features/lists/providers/lists_provider.dart';
import 'package:family_helper_flutter/features/money_goals/providers/money_goals_provider.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:family_helper_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:family_helper_flutter/features/tasks/domain/task_form.dart';
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
  void reset({bool hasSelectedFamily = false}) {
    emit(TasksState.initial(hasSelectedFamily: hasSelectedFamily));
  }

  @override
  Future<TaskDto?> saveTask(TaskForm form, {int? taskId}) async => null;

  @override
  void setCurrentTask(int? taskId) {}

  @override
  void setReminderSyncing(bool value) {}
}

class _CalendarCubitStub extends Cubit<CalendarState> implements CalendarCubit {
  _CalendarCubitStub(super.initialState);

  @override
  List<CalendarInstanceDto> agendaForDay(DateTime day) => const [];

  @override
  Future<void> deleteOccurrence(CalendarInstanceDto instance) async {}

  @override
  Future<void> deleteSeries({
    required CalendarInstanceDto instance,
    required CalendarMutationScope scope,
  }) async {}

  @override
  Map<DateTime, List<CalendarInstanceDto>> eventsByDay() => const {};

  @override
  Future<CalendarEventDto> loadEvent(int eventId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> reload() async {}

  @override
  void reset() => emit(CalendarState.initial());

  @override
  Future<CalendarEventDto?> saveSeries({
    required CalendarEventForm form,
    int? eventId,
    CalendarMutationScope scope = CalendarMutationScope.all,
    DateTime? anchorOccurrenceStart,
  }) async => null;

  @override
  Future<void> saveOccurrence({
    required CalendarInstanceDto instance,
    required CalendarEventForm form,
  }) async {}

  @override
  void selectDay(DateTime day) {}

  @override
  Future<void> setVisibleMonth(DateTime month) async {}
}

class _ListsCubitStub extends Cubit<ListsState> implements ListsCubit {
  _ListsCubitStub(super.initialState);

  @override
  Future<void> addItem({
    required String title,
    double qty = 1,
    String? unit,
    String? note,
    int? priceCents,
  }) async {}

  @override
  Future<void> createList(String title, {String listType = 'shopping'}) async {}

  @override
  Future<void> deleteItem(ListItemDto item) async {}

  @override
  Future<void> deleteSelectedList() async {}

  @override
  Future<void> loadItemsForSelectedList({bool showLoading = true}) async {}

  @override
  Future<void> loadLists({
    int? preferredSelectedListId,
    bool loadSelectedItems = true,
    bool showLoading = true,
  }) async {}

  @override
  Future<void> reload() async {}

  @override
  Future<void> reorderDescending() async {}

  @override
  void reset() => emit(ListsState.initial());

  @override
  void setCurrentList(int listId) {}

  @override
  Future<void> selectList(int listId) async {}

  @override
  Future<void> toggleBought(ListItemDto item) async {}

  @override
  Future<void> updateItem(
    ListItemDto item, {
    required String title,
    required double qty,
    String? unit,
    String? note,
    int? priceCents,
  }) async {}

  @override
  Future<void> updateSelectedList({
    required String title,
    required String listType,
  }) async {}
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
  Future<ReminderActionResult> replaceEntityReminder({
    required String notificationType,
    required String entityType,
    required int entityId,
    DateTime? remindAt,
    required String payloadJson,
    required String title,
    required String body,
  }) async => ReminderActionResult.successResult;

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
        calendarState: CalendarState.initial(),
        listsState: const ListsState(
          isLoadingLists: false,
          isLoadingItems: false,
          lists: [],
          items: [],
        ),
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
        calendarState: CalendarState.initial(),
        listsState: const ListsState(
          isLoadingLists: false,
          isLoadingItems: false,
          lists: [],
          items: [],
        ),
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
