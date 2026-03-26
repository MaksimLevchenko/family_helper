import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:family_helper_flutter/features/tasks/domain/task_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolves relative deadline using fixed now', () {
    const form = TaskForm(
      title: 'Task',
      description: '',
      isPersonal: false,
      priority: TaskPriorityOption.normal,
      assigneeProfileId: null,
      dueInputMode: TaskDueInputMode.relative,
      dueAt: null,
      dueOffsetValue: 3,
      dueOffsetUnit: TaskDueOffsetUnit.hours,
      reminderPreset: ReminderPreset.none,
      recurrencePreset: TaskRecurrencePreset.none,
      recurrenceInterval: 1,
    );
    final now = DateTime.utc(2026, 3, 26, 12);

    expect(form.resolveRelativeDueAt(now), DateTime.utc(2026, 3, 26, 15));
  });

  test('restores relative task metadata into form state', () {
    final task = _task(
      dueAt: DateTime.utc(2026, 3, 29, 12),
      dueInputMode: 'relative',
      dueOffsetValue: 3,
      dueOffsetUnit: 'days',
    );

    final form = TaskForm.fromTask(task);

    expect(form.dueInputMode, TaskDueInputMode.relative);
    expect(form.dueAt, DateTime.utc(2026, 3, 29, 12));
    expect(form.dueOffsetValue, 3);
    expect(form.dueOffsetUnit, TaskDueOffsetUnit.days);
  });

  test('restores absolute-only task into absolute mode', () {
    final task = _task(dueAt: DateTime.utc(2026, 3, 29, 12));

    final form = TaskForm.fromTask(task);

    expect(form.dueInputMode, TaskDueInputMode.absolute);
    expect(form.dueAt, DateTime.utc(2026, 3, 29, 12));
  });

  test('rejects invalid relative offset values', () {
    const form = TaskForm(
      title: 'Task',
      description: '',
      isPersonal: false,
      priority: TaskPriorityOption.normal,
      assigneeProfileId: null,
      dueInputMode: TaskDueInputMode.relative,
      dueAt: null,
      dueOffsetValue: 0,
      dueOffsetUnit: TaskDueOffsetUnit.days,
      reminderPreset: ReminderPreset.none,
      recurrencePreset: TaskRecurrencePreset.none,
      recurrenceInterval: 1,
    );

    expect(form.normalizedDueOffsetValue, isNull);
    expect(form.resolveRelativeDueAt(DateTime.utc(2026, 3, 26, 12)), isNull);
    expect(form.hasValidDeadline, isFalse);
  });
}

TaskDto _task({
  DateTime? dueAt,
  String? dueInputMode,
  int? dueOffsetValue,
  String? dueOffsetUnit,
}) {
  return TaskDto(
    id: 1,
    familyId: 42,
    title: 'Task',
    description: 'Task details',
    isPersonal: false,
    priority: 'normal',
    status: 'open',
    dueAt: dueAt,
    dueInputMode: dueInputMode,
    dueOffsetValue: dueOffsetValue,
    dueOffsetUnit: dueOffsetUnit,
    updatedAt: DateTime.utc(2026, 3, 26, 11),
    version: 1,
  );
}
