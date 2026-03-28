import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/auth_profile/data/profile_repository.dart';
import 'package:family_helper_flutter/features/auth_profile/providers/profile_provider.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:family_helper_flutter/features/notifications/providers/notifications_provider.dart';
import 'package:family_helper_flutter/features/tasks/domain/task_form.dart';
import 'package:family_helper_flutter/features/tasks/presentation/tasks_screen.dart';
import 'package:family_helper_flutter/features/tasks/presentation/widgets/task_workspace_widgets.dart';
import 'package:family_helper_flutter/features/tasks/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProfileRepository implements ProfileRepositoryContract {
  _FakeProfileRepository(this.profile);

  final ProfileDto profile;

  @override
  Future<ProfileDto> me() async => profile;

  @override
  Future<ProfileDto> update({
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool clearAvatarMedia = false,
    bool? analyticsOptIn,
  }) async {
    return profile.copyWith(
      displayName: displayName ?? profile.displayName,
      timezone: timezone ?? profile.timezone,
      avatarMediaId: clearAvatarMedia
          ? null
          : (avatarMediaId ?? profile.avatarMediaId),
      analyticsOptIn: analyticsOptIn ?? profile.analyticsOptIn,
      updatedAt: DateTime.utc(2026, 3, 26, 10),
    );
  }
}

class _TestFamilySelectionCubit extends FamilySelectionCubit {
  _TestFamilySelectionCubit(int? initialFamilyId) : super() {
    emit(initialFamilyId);
  }

  @override
  Future<void> bootstrap() async {}
}

class _FamilyMembersCubitStub extends Cubit<FamilyMembersState>
    implements FamilyMembersCubit {
  _FamilyMembersCubitStub(super.initialState);

  @override
  Future<void> acceptInvite(String tokenOrCode) async {}

  @override
  Future<FamilyInviteDto?> createInvite({
    required String inviteType,
    String? email,
  }) async => null;

  @override
  Future<FamilyDto?> createFamily(String title) async => null;

  @override
  Future<void> leaveFamily() async {}

  @override
  Future<void> loadMembers() async {}

  @override
  Future<FamilyDto?> renameFamily(String title) async => null;

  @override
  void reset() => emit(FamilyMembersState.initial(familyId: state.familyId));

  @override
  Future<void> transferOwnership({required int newOwnerProfileId}) async {}
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
  bool isPreferenceEnabled(String notificationType) => true;

  @override
  Future<void> loadPreferences() async {}

  @override
  Future<bool> openSystemNotificationSettings() async => true;

  @override
  Future<void> markAllNotificationsRead() async {}

  @override
  Future<void> markNotificationRead(int notificationId) async {}

  @override
  Future<NotificationPermissionStatus> requestSystemPermission() async {
    return state.permissionStatus;
  }

  @override
  Future<NotificationPermissionStatus> requestSystemPermissionIfNeeded() async {
    return state.permissionStatus;
  }

  @override
  Future<ReminderActionResult> scheduleDebugNotification() async {
    return const ReminderActionResult(
      success: true,
      message: 'Test push sent. It should arrive shortly.',
    );
  }

  @override
  Future<void> refreshPermissionStatus() async {}

  @override
  Future<void> registerPushToken({
    required String token,
    String? platform,
  }) async {}

  @override
  Future<void> reloadInbox({
    bool unreadOnly = false,
    DateTime? before,
    bool append = false,
    int limit = 50,
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
  }) async {
    return ReminderActionResult.successResult;
  }

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

class _TasksCubitStub extends Cubit<TasksState> implements TasksCubit {
  _TasksCubitStub(super.initialState);

  TaskForm? lastSavedForm;

  @override
  Future<void> complete(TaskDto task) async {
    final updatedTasks = state.tasks
        .map(
          (item) => item.id == task.id
              ? item.copyWith(
                  status: 'completed',
                  completedAt: DateTime.utc(2026, 3, 26, 12),
                )
              : item,
        )
        .toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  @override
  Future<bool> deleteCurrentTask() async {
    final currentTaskId = state.currentTaskId;
    if (currentTaskId == null) {
      return false;
    }
    final remainingTasks = state.tasks
        .where((task) => task.id != currentTaskId)
        .toList();
    emit(
      state.copyWith(
        tasks: remainingTasks,
        currentTaskId: remainingTasks.isEmpty ? null : remainingTasks.first.id,
        history: remainingTasks.isEmpty
            ? const []
            : [
                _history(
                  id: 900 + remainingTasks.first.id,
                  taskId: remainingTasks.first.id,
                  eventType: 'created',
                ),
              ],
      ),
    );
    return true;
  }

  @override
  Future<TaskDto?> createTask({
    required String title,
    required bool isPersonal,
    DateTime? dueAt,
    bool recurringOnComplete = false,
  }) async {
    return saveTask(
      TaskForm.create().copyWith(
        title: title,
        isPersonal: isPersonal,
        dueAt: dueAt,
        recurrencePreset: recurringOnComplete
            ? TaskRecurrencePreset.daily
            : TaskRecurrencePreset.none,
      ),
    );
  }

  @override
  Future<void> reload() async {}

  @override
  void reset({bool hasSelectedFamily = false}) {
    emit(TasksState.initial(hasSelectedFamily: hasSelectedFamily));
  }

  @override
  Future<TaskDto?> saveTask(TaskForm form, {int? taskId}) async {
    lastSavedForm = form;
    final nextTask = TaskDto(
      id: taskId ?? 999,
      familyId: 42,
      title: form.title.trim(),
      description: form.normalizedDescription,
      isPersonal: form.isPersonal,
      priority: form.priorityValue,
      status: 'open',
      dueAt: form.dueAt,
      recurrenceMode: form.recurrenceMode,
      recurrenceRrule: form.recurrenceRrule,
      assigneeProfileId: form.assigneeProfileId,
      updatedAt: DateTime.utc(2026, 3, 26, 12),
      version: 1,
    );
    emit(
      state.copyWith(
        tasks: [
          ...state.tasks.where((task) => task.id != nextTask.id),
          nextTask,
        ],
        currentTaskId: nextTask.id,
      ),
    );
    return nextTask;
  }

  @override
  void setCurrentTask(int? taskId) {
    emit(state.copyWith(currentTaskId: taskId));
  }

  @override
  void setReminderSyncing(bool value) {
    emit(state.copyWith(isReminderSyncing: value));
  }
}

void main() {
  Widget buildSubject({
    required _TasksCubitStub tasksCubit,
    required _FamilyMembersCubitStub familyMembersCubit,
    NotificationsState notificationsState = const NotificationsState(
      isLoading: false,
      reminders: [],
      preferences: [],
      permissionStatus: NotificationPermissionStatus.granted,
    ),
    int? familyId = 42,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FamilySelectionCubit>(
          create: (_) => _TestFamilySelectionCubit(familyId),
        ),
        BlocProvider<FamilyMembersCubit>(
          create: (_) => familyMembersCubit,
        ),
        BlocProvider<ProfileBloc>(
          create: (_) =>
              ProfileBloc(repository: _FakeProfileRepository(_profile()))
                ..add(const ProfileLoadRequested()),
        ),
        BlocProvider<TasksCubit>(create: (_) => tasksCubit),
        BlocProvider<NotificationsCubit>(
          create: (_) => _NotificationsCubitStub(notificationsState),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const TasksScreen(),
      ),
    );
  }

  void setSurface(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets(
    'renders grouped open sections and archive filter on narrow layout',
    (
      tester,
    ) async {
      setSurface(tester, const Size(390, 1200));
      final now = DateTime.now();
      final tasksCubit = _TasksCubitStub(
        TasksState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          isInitialLoading: false,
          tasks: [
            _task(
              id: 1,
              title: 'Past due task',
              dueAt: DateTime(
                now.year,
                now.month,
                now.day - 1,
                9,
              ).toUtc(),
            ),
            _task(
              id: 2,
              title: 'Today task',
              dueAt: DateTime(now.year, now.month, now.day, 12).toUtc(),
            ),
            _task(
              id: 3,
              title: 'Upcoming task',
              dueAt: DateTime(
                now.year,
                now.month,
                now.day + 3,
                12,
              ).toUtc(),
            ),
            _task(id: 4, title: 'Anytime task'),
            _task(
              id: 5,
              title: 'Filed away',
              status: 'completed',
              completedAt: DateTime.utc(2026, 3, 26, 10),
            ),
          ],
          history: [_history(id: 1, taskId: 1, eventType: 'created')],
          currentTaskId: 1,
        ),
      );

      await tester.pumpWidget(
        buildSubject(
          tasksCubit: tasksCubit,
          familyMembersCubit: _FamilyMembersCubitStub(
            FamilyMembersState.initial(familyId: 42).copyWith(
              isLoading: false,
              members: [_member()],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final narrowScrollable = find
          .descendant(
            of: find.byKey(const Key('tasks-narrow-layout')),
            matching: find.byType(Scrollable),
          )
          .first;

      expect(find.byKey(const Key('tasks-narrow-layout')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(SectionHeader),
          matching: find.text('Overdue'),
        ),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.text('Today'),
        300,
        scrollable: narrowScrollable,
      );
      expect(find.text('Today'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Upcoming'),
        300,
        scrollable: narrowScrollable,
      );
      expect(find.text('Upcoming'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('No due date'),
        300,
        scrollable: narrowScrollable,
      );
      expect(find.text('No due date'), findsOneWidget);

      await tester.tap(find.byKey(const Key('tasks-filter-completed')));
      await tester.pumpAndSettle();

      expect(find.text('Completed archive'), findsWidgets);
      expect(find.text('Filed away'), findsWidgets);
    },
  );

  testWidgets(
    'renders history in wide layout and disables editing for archive item',
    (
      tester,
    ) async {
      setSurface(tester, const Size(1280, 900));
      final tasksCubit = _TasksCubitStub(
        TasksState.initial(
          hasSelectedFamily: true,
        ).copyWith(
          isInitialLoading: false,
          tasks: [
            _task(id: 1, title: 'Open task'),
            _task(
              id: 2,
              title: 'Completed task',
              status: 'completed',
              completedAt: DateTime.utc(2026, 3, 26, 9),
            ),
          ],
          history: [
            _history(
              id: 2,
              taskId: 2,
              eventType: 'completed',
              details: 'Task completed',
            ),
          ],
          currentTaskId: 2,
        ),
      );

      await tester.pumpWidget(
        buildSubject(
          tasksCubit: tasksCubit,
          familyMembersCubit: _FamilyMembersCubitStub(
            FamilyMembersState.initial(familyId: 42).copyWith(
              isLoading: false,
              members: [_member()],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tasks-wide-layout')), findsOneWidget);
      await tester.tap(find.byKey(const Key('tasks-filter-completed')));
      await tester.pumpAndSettle();

      expect(find.text('Completed archive item'), findsOneWidget);
      expect(find.text('Alex - Completed'), findsOneWidget);

      final editButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Edit task'),
      );
      expect(editButton.onPressed, isNull);
    },
  );

  testWidgets('delete action removes the selected task after confirmation', (
    tester,
  ) async {
    setSurface(tester, const Size(1280, 900));
    final tasksCubit = _TasksCubitStub(
      TasksState.initial(
        hasSelectedFamily: true,
      ).copyWith(
        isInitialLoading: false,
        tasks: [
          _task(id: 1, title: 'Trash'),
          _task(id: 2, title: 'Dishes'),
        ],
        history: [_history(id: 1, taskId: 1, eventType: 'created')],
        currentTaskId: 1,
      ),
    );

    await tester.pumpWidget(
      buildSubject(
        tasksCubit: tasksCubit,
        familyMembersCubit: _FamilyMembersCubitStub(
          FamilyMembersState.initial(familyId: 42).copyWith(
            isLoading: false,
            members: [_member()],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('task-detail-delete-button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Delete "Trash" permanently from active tasks and archive.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('task-delete-confirm-button')));
    await tester.pumpAndSettle();

    expect(find.text('Trash'), findsNothing);
    expect(find.text('Dishes'), findsWidgets);
    expect(tasksCubit.state.currentTaskId, 2);
  });

  testWidgets(
    'task editor hides assignee for personal tasks and disables reminder without deadline',
    (
      tester,
    ) async {
      setSurface(tester, const Size(390, 1200));
      final tasksCubit = _TasksCubitStub(
        TasksState.initial(
          hasSelectedFamily: true,
        ).copyWith(isInitialLoading: false),
      );

      await tester.pumpWidget(
        buildSubject(
          tasksCubit: tasksCubit,
          familyMembersCubit: _FamilyMembersCubitStub(
            FamilyMembersState.initial(familyId: 42).copyWith(
              isLoading: false,
              members: [_member()],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create task'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('task-editor-assignee-field')),
        findsOneWidget,
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('task-editor-assignee-field')), findsNothing);

      final reminderField = tester.widget<ReminderPresetField>(
        find.byKey(const Key('task-editor-reminder-field')),
      );
      final recurrenceField = tester
          .widget<DropdownButtonFormField<TaskRecurrencePreset>>(
            find.byKey(const Key('task-editor-recurrence-field')),
          );

      expect(reminderField.enabled, isFalse);
      expect(recurrenceField.onChanged, isNull);

      await tester.enterText(
        find.byKey(const Key('task-editor-title-field')),
        'Pay utilities',
      );
      await tester.tap(find.text('Create task').last);
      await tester.pumpAndSettle();

      expect(tasksCubit.lastSavedForm, isNotNull);
      expect(tasksCubit.lastSavedForm!.dueAt, isNull);
    },
  );
}

TaskDto _task({
  required int id,
  required String title,
  String status = 'open',
  DateTime? dueAt,
  DateTime? completedAt,
}) {
  return TaskDto(
    id: id,
    familyId: 42,
    title: title,
    description: 'Task notes',
    isPersonal: false,
    priority: 'normal',
    status: status,
    dueAt: dueAt,
    assigneeProfileId: 7,
    completedAt: completedAt,
    updatedAt: DateTime.utc(2026, 3, 26, 8, id),
    version: 1,
  );
}

TaskHistoryEntryDto _history({
  required int id,
  required int taskId,
  required String eventType,
  String details = 'Task created',
}) {
  return TaskHistoryEntryDto(
    id: id,
    taskId: taskId,
    profileId: 7,
    actorDisplayName: 'Alex',
    eventType: eventType,
    details: details,
    createdAt: DateTime.utc(2026, 3, 26, 9, id),
  );
}

FamilyMemberDto _member() {
  return FamilyMemberDto(
    id: 1,
    familyId: 42,
    profileId: 7,
    displayName: 'Alex',
    role: 'owner',
    status: 'active',
    createdAt: DateTime.utc(2026, 3, 1),
  );
}

ProfileDto _profile() {
  return ProfileDto(
    id: 7,
    authUserId: 'user-7',
    displayName: 'Alex',
    timezone: 'Europe/Moscow',
    analyticsOptIn: true,
    createdAt: DateTime.utc(2026, 3, 1),
    updatedAt: DateTime.utc(2026, 3, 1),
  );
}
