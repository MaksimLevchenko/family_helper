import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:family_helper_flutter/features/tasks/domain/task_form.dart';
import 'package:family_helper_flutter/features/tasks/presentation/widgets/task_editor_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fixedNow = DateTime.utc(2026, 3, 26, 12);

  Future<void> pumpEditor(
    WidgetTester tester, {
    required TaskForm initialForm,
    Future<bool> Function(TaskForm form)? onSubmit,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: TaskEditorSheet(
            initialForm: initialForm,
            members: [_member()],
            currentProfileId: 7,
            isSubmitting: false,
            existingTask: null,
            nowProvider: () => fixedNow,
            onSubmit: onSubmit ?? ((_) async => false),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapSubmit(WidgetTester tester, String label) async {
    final buttonFinder = find.widgetWithText(FilledButton, label);
    await tester.scrollUntilVisible(
      buttonFinder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
  }

  testWidgets('creating a task without a deadline succeeds', (tester) async {
    TaskForm? submittedForm;
    await pumpEditor(
      tester,
      initialForm: TaskForm.create(currentProfileId: 7),
      onSubmit: (form) async {
        submittedForm = form;
        return false;
      },
    );

    await tester.enterText(
      find.byKey(const Key('task-editor-title-field')),
      'Buy milk',
    );
    await tapSubmit(tester, 'Create task');

    expect(submittedForm, isNotNull);
    expect(submittedForm!.dueInputMode, TaskDueInputMode.none);
    expect(submittedForm!.dueAt, isNull);
  });

  testWidgets('switching to no deadline clears reminder and recurrence', (
    tester,
  ) async {
    TaskForm? submittedForm;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: TaskEditorSheet(
            initialForm:
                TaskForm.create(
                  currentProfileId: 7,
                ).copyWith(
                  title: 'Task',
                  dueInputMode: TaskDueInputMode.absolute,
                  dueAt: DateTime.utc(2026, 3, 27, 9),
                  reminderPreset: ReminderPreset.oneHourBefore,
                  recurrencePreset: TaskRecurrencePreset.daily,
                ),
            members: [_member()],
            currentProfileId: 7,
            isSubmitting: false,
            existingTask: null,
            nowProvider: () => fixedNow,
            onSubmit: (form) async {
              submittedForm = form;
              return false;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('task-editor-deadline-mode-none')));
    await tester.pumpAndSettle();
    await tapSubmit(tester, 'Create task');

    expect(submittedForm, isNotNull);
    expect(submittedForm!.dueInputMode, TaskDueInputMode.none);
    expect(submittedForm!.dueAt, isNull);
    expect(submittedForm!.reminderPreset, ReminderPreset.none);
    expect(submittedForm!.recurrencePreset, TaskRecurrencePreset.none);
  });

  testWidgets('relative preset computes dueAt on submit', (tester) async {
    TaskForm? submittedForm;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: TaskEditorSheet(
            initialForm: TaskForm.create(currentProfileId: 7).copyWith(
              title: 'Task',
            ),
            members: [_member()],
            currentProfileId: 7,
            isSubmitting: false,
            existingTask: null,
            nowProvider: () => fixedNow,
            onSubmit: (form) async {
              submittedForm = form;
              return false;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('task-editor-deadline-mode-relative')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('task-editor-relative-preset-3h')));
    await tester.pumpAndSettle();
    await tapSubmit(tester, 'Create task');

    expect(submittedForm, isNotNull);
    expect(submittedForm!.dueInputMode, TaskDueInputMode.relative);
    expect(submittedForm!.dueOffsetValue, 3);
    expect(submittedForm!.dueOffsetUnit, TaskDueOffsetUnit.hours);
    expect(submittedForm!.dueAt, DateTime.utc(2026, 3, 26, 15));
  });

  testWidgets('manual relative input computes dueAt on submit', (tester) async {
    TaskForm? submittedForm;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: TaskEditorSheet(
            initialForm: TaskForm.create(currentProfileId: 7).copyWith(
              title: 'Task',
            ),
            members: [_member()],
            currentProfileId: 7,
            isSubmitting: false,
            existingTask: null,
            nowProvider: () => fixedNow,
            onSubmit: (form) async {
              submittedForm = form;
              return false;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('task-editor-deadline-mode-relative')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('task-editor-due-offset-value-field')),
      '2',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('task-editor-due-offset-unit-field')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Days').last);
    await tester.pumpAndSettle();
    await tapSubmit(tester, 'Create task');

    expect(submittedForm, isNotNull);
    expect(submittedForm!.dueInputMode, TaskDueInputMode.relative);
    expect(submittedForm!.dueOffsetValue, 2);
    expect(submittedForm!.dueOffsetUnit, TaskDueOffsetUnit.days);
    expect(submittedForm!.dueAt, DateTime.utc(2026, 3, 28, 12));
  });

  testWidgets('existing relative task keeps stored dueAt if untouched', (
    tester,
  ) async {
    TaskForm? submittedForm;
    final task = TaskDto(
      id: 1,
      familyId: 42,
      title: 'Task',
      description: 'Details',
      isPersonal: false,
      priority: 'normal',
      status: 'open',
      dueAt: DateTime.utc(2026, 4, 1, 12),
      dueInputMode: 'relative',
      dueOffsetValue: 3,
      dueOffsetUnit: 'days',
      updatedAt: DateTime.utc(2026, 3, 26, 11),
      version: 1,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: TaskEditorSheet(
            initialForm: TaskForm.fromTask(task),
            members: [_member()],
            currentProfileId: 7,
            isSubmitting: false,
            existingTask: task,
            nowProvider: () => fixedNow,
            onSubmit: (form) async {
              submittedForm = form;
              return false;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tapSubmit(tester, 'Save changes');
    await tester.pumpAndSettle();

    expect(submittedForm, isNotNull);
    expect(submittedForm!.dueAt, DateTime.utc(2026, 4, 1, 12));
    expect(submittedForm!.dueInputMode, TaskDueInputMode.relative);
  });

  testWidgets('reminder and repeat are disabled without a valid deadline', (
    tester,
  ) async {
    await pumpEditor(
      tester,
      initialForm: TaskForm.create(currentProfileId: 7).copyWith(title: 'Task'),
    );

    final reminderField = tester.widget<ReminderPresetField>(
      find.byKey(const Key('task-editor-reminder-field')),
    );
    final recurrenceField = tester
        .widget<DropdownButtonFormField<TaskRecurrencePreset>>(
          find.byKey(const Key('task-editor-recurrence-field')),
        );

    expect(reminderField.enabled, isFalse);
    expect(recurrenceField.onChanged, isNull);
  });
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
