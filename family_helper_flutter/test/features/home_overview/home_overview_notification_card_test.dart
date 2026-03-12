import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/calendar/providers/calendar_provider.dart';
import 'package:family_helper_flutter/features/home_overview/presentation/home_overview_screen.dart';
import 'package:family_helper_flutter/features/lists/providers/lists_provider.dart';
import 'package:family_helper_flutter/features/money_goals/providers/money_goals_provider.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:family_helper_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:family_helper_flutter/features/tasks/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _TasksCubitStub extends Cubit<TasksState> implements TasksCubit {
  _TasksCubitStub() : super(TasksState.initial());

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
  _CalendarCubitStub() : super(CalendarState.initial());

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
  _ListsCubitStub() : super(ListsState.initial());

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
  _MoneyGoalsCubitStub() : super(MoneyGoalsState.initial());

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
  void reset({bool hasSelectedFamily = false}) =>
      emit(MoneyGoalsState.initial(hasSelectedFamily: hasSelectedFamily));

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

  bool requestedPermission = false;
  bool openedSystemSettings = false;

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
  Future<bool> openSystemNotificationSettings() async {
    openedSystemSettings = true;
    return true;
  }

  @override
  Future<NotificationPermissionStatus> requestSystemPermission() async {
    requestedPermission = true;
    emit(
      state.copyWith(permissionStatus: NotificationPermissionStatus.granted),
    );
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

Widget _buildSubject(_NotificationsCubitStub notificationsCubit) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<TasksCubit>.value(value: _TasksCubitStub()),
      BlocProvider<CalendarCubit>.value(value: _CalendarCubitStub()),
      BlocProvider<ListsCubit>.value(value: _ListsCubitStub()),
      BlocProvider<MoneyGoalsCubit>.value(value: _MoneyGoalsCubitStub()),
      BlocProvider<NotificationsCubit>.value(value: notificationsCubit),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const HomeOverviewScreen(),
    ),
  );
}

void main() {
  testWidgets(
    'HomeOverviewScreen shows permission card before notifications are allowed',
    (
      tester,
    ) async {
      final notificationsCubit = _NotificationsCubitStub(
        NotificationsState.initial().copyWith(
          permissionStatus: NotificationPermissionStatus.notDetermined,
        ),
      );

      await tester.pumpWidget(_buildSubject(notificationsCubit));
      await tester.pumpAndSettle();

      expect(find.text('Stay on top of family reminders'), findsOneWidget);
      expect(find.text('Allow notifications'), findsOneWidget);

      await tester.tap(find.text('Allow notifications'));
      await tester.pump();

      expect(notificationsCubit.requestedPermission, isTrue);

      await notificationsCubit.close();
    },
  );

  testWidgets(
    'HomeOverviewScreen hides permission card when notifications are granted',
    (
      tester,
    ) async {
      final notificationsCubit = _NotificationsCubitStub(
        NotificationsState.initial().copyWith(
          permissionStatus: NotificationPermissionStatus.granted,
        ),
      );

      await tester.pumpWidget(_buildSubject(notificationsCubit));
      await tester.pumpAndSettle();

      expect(find.text('Stay on top of family reminders'), findsNothing);
      expect(find.text('Allow notifications'), findsNothing);

      await notificationsCubit.close();
    },
  );
}
