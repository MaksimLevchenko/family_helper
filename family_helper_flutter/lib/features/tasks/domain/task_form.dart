import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/config/app_defaults.dart';
import '../../notifications/domain/notification_models.dart';

enum TaskPriorityOption { low, normal, high }

extension TaskPriorityOptionX on TaskPriorityOption {
  String get label {
    return switch (this) {
      TaskPriorityOption.low => 'Low',
      TaskPriorityOption.normal => 'Normal',
      TaskPriorityOption.high => 'High',
    };
  }

  String get wireValue {
    return switch (this) {
      TaskPriorityOption.low => 'low',
      TaskPriorityOption.normal => 'normal',
      TaskPriorityOption.high => 'high',
    };
  }

  static TaskPriorityOption fromWireValue(String value) {
    return switch (value) {
      'low' => TaskPriorityOption.low,
      'high' => TaskPriorityOption.high,
      _ => TaskPriorityOption.normal,
    };
  }
}

enum TaskRecurrencePreset { none, daily, weekly, monthly }

extension TaskRecurrencePresetX on TaskRecurrencePreset {
  String get label {
    return switch (this) {
      TaskRecurrencePreset.none => 'Does not repeat',
      TaskRecurrencePreset.daily => 'Daily',
      TaskRecurrencePreset.weekly => 'Weekly',
      TaskRecurrencePreset.monthly => 'Monthly',
    };
  }

  String? toWireRrule(int interval) {
    if (this == TaskRecurrencePreset.none) {
      return null;
    }

    final normalizedInterval = interval <= 0 ? 1 : interval;
    return 'FREQ=$wireFrequency;INTERVAL=$normalizedInterval';
  }

  String get wireFrequency {
    return switch (this) {
      TaskRecurrencePreset.none => 'NONE',
      TaskRecurrencePreset.daily => 'DAILY',
      TaskRecurrencePreset.weekly => 'WEEKLY',
      TaskRecurrencePreset.monthly => 'MONTHLY',
    };
  }

  static TaskRecurrencePreset fromTask(TaskDto task) {
    final rrule = task.recurrenceRrule?.toUpperCase() ?? '';
    if (rrule.contains('FREQ=MONTHLY')) {
      return TaskRecurrencePreset.monthly;
    }
    if (rrule.contains('FREQ=WEEKLY')) {
      return TaskRecurrencePreset.weekly;
    }
    if (rrule.contains('FREQ=DAILY')) {
      return TaskRecurrencePreset.daily;
    }
    return TaskRecurrencePreset.none;
  }

  static int intervalFromTask(TaskDto task) {
    final rrule = task.recurrenceRrule?.toUpperCase();
    if (rrule == null || rrule.isEmpty) {
      return 1;
    }

    for (final part in rrule.split(';')) {
      final keyValue = part.split('=');
      if (keyValue.length == 2 && keyValue[0] == 'INTERVAL') {
        return int.tryParse(keyValue[1]) ?? 1;
      }
    }
    return 1;
  }
}

enum TaskDueInputMode { none, absolute, relative }

extension TaskDueInputModeX on TaskDueInputMode {
  String get label {
    return switch (this) {
      TaskDueInputMode.none => 'No deadline',
      TaskDueInputMode.absolute => 'Specific date',
      TaskDueInputMode.relative => 'In...',
    };
  }

  String get wireValue {
    return switch (this) {
      TaskDueInputMode.none => 'none',
      TaskDueInputMode.absolute => 'absolute',
      TaskDueInputMode.relative => 'relative',
    };
  }

  static TaskDueInputMode fromWireValue(String? value) {
    return switch (value) {
      'absolute' => TaskDueInputMode.absolute,
      'relative' => TaskDueInputMode.relative,
      _ => TaskDueInputMode.none,
    };
  }
}

enum TaskDueOffsetUnit { minutes, hours, days }

extension TaskDueOffsetUnitX on TaskDueOffsetUnit {
  String get label {
    return switch (this) {
      TaskDueOffsetUnit.minutes => 'Minutes',
      TaskDueOffsetUnit.hours => 'Hours',
      TaskDueOffsetUnit.days => 'Days',
    };
  }

  String get singularLabel {
    return switch (this) {
      TaskDueOffsetUnit.minutes => 'minute',
      TaskDueOffsetUnit.hours => 'hour',
      TaskDueOffsetUnit.days => 'day',
    };
  }

  String get wireValue {
    return switch (this) {
      TaskDueOffsetUnit.minutes => 'minutes',
      TaskDueOffsetUnit.hours => 'hours',
      TaskDueOffsetUnit.days => 'days',
    };
  }

  Duration toDuration(int value) {
    final normalizedValue = value < 1 ? 1 : value;
    return switch (this) {
      TaskDueOffsetUnit.minutes => Duration(minutes: normalizedValue),
      TaskDueOffsetUnit.hours => Duration(hours: normalizedValue),
      TaskDueOffsetUnit.days => Duration(days: normalizedValue),
    };
  }

  static TaskDueOffsetUnit fromWireValue(String? value) {
    return switch (value) {
      'minutes' => TaskDueOffsetUnit.minutes,
      'days' => TaskDueOffsetUnit.days,
      _ => TaskDueOffsetUnit.hours,
    };
  }
}

class TaskForm {
  const TaskForm({
    required this.title,
    required this.description,
    required this.isPersonal,
    required this.priority,
    required this.assigneeProfileId,
    required this.dueInputMode,
    required this.dueAt,
    required this.dueOffsetValue,
    required this.dueOffsetUnit,
    required this.reminderPreset,
    required this.recurrencePreset,
    required this.recurrenceInterval,
  });

  final String title;
  final String description;
  final bool isPersonal;
  final TaskPriorityOption priority;
  final int? assigneeProfileId;
  final TaskDueInputMode dueInputMode;
  final DateTime? dueAt;
  final int? dueOffsetValue;
  final TaskDueOffsetUnit dueOffsetUnit;
  final ReminderPreset reminderPreset;
  final TaskRecurrencePreset recurrencePreset;
  final int recurrenceInterval;

  factory TaskForm.create({int? currentProfileId}) {
    return TaskForm(
      title: '',
      description: '',
      isPersonal: false,
      priority: TaskPriorityOptionX.fromWireValue(
        AppDefaults.defaultTaskPriority,
      ),
      assigneeProfileId: currentProfileId,
      dueInputMode: TaskDueInputMode.none,
      dueAt: null,
      dueOffsetValue: 1,
      dueOffsetUnit: TaskDueOffsetUnit.hours,
      reminderPreset: ReminderPreset.none,
      recurrencePreset: TaskRecurrencePreset.none,
      recurrenceInterval: 1,
    );
  }

  factory TaskForm.fromTask(
    TaskDto task, {
    ReminderPreset reminderPreset = ReminderPreset.none,
  }) {
    return TaskForm(
      title: task.title,
      description: task.description ?? '',
      isPersonal: task.isPersonal,
      priority: TaskPriorityOptionX.fromWireValue(task.priority),
      assigneeProfileId: task.assigneeProfileId,
      dueInputMode: _dueInputModeFromTask(task),
      dueAt: task.dueAt,
      dueOffsetValue: task.dueOffsetValue,
      dueOffsetUnit: TaskDueOffsetUnitX.fromWireValue(task.dueOffsetUnit),
      reminderPreset: reminderPreset,
      recurrencePreset: TaskRecurrencePresetX.fromTask(task),
      recurrenceInterval: TaskRecurrencePresetX.intervalFromTask(task),
    );
  }

  String? get normalizedDescription {
    final value = description.trim();
    return value.isEmpty ? null : value;
  }

  String get priorityValue => priority.wireValue;

  String? get dueInputModeValue {
    return switch (dueInputMode) {
      TaskDueInputMode.none => TaskDueInputMode.none.wireValue,
      TaskDueInputMode.absolute =>
        dueAt == null
            ? TaskDueInputMode.none.wireValue
            : TaskDueInputMode.absolute.wireValue,
      TaskDueInputMode.relative =>
        normalizedDueOffsetValue == null
            ? TaskDueInputMode.none.wireValue
            : TaskDueInputMode.relative.wireValue,
    };
  }

  int? get normalizedDueOffsetValue {
    final value = dueOffsetValue;
    if (dueInputMode != TaskDueInputMode.relative ||
        value == null ||
        value < 1) {
      return null;
    }
    return value;
  }

  String? get dueOffsetUnitValue {
    return dueInputMode == TaskDueInputMode.relative &&
            normalizedDueOffsetValue != null
        ? dueOffsetUnit.wireValue
        : null;
  }

  DateTime? resolveRelativeDueAt(DateTime nowUtc) {
    final value = normalizedDueOffsetValue;
    if (value == null) {
      return null;
    }
    return nowUtc.add(dueOffsetUnit.toDuration(value));
  }

  DateTime? get effectiveDueAt {
    return switch (dueInputMode) {
      TaskDueInputMode.none => null,
      TaskDueInputMode.absolute => dueAt,
      TaskDueInputMode.relative => resolveRelativeDueAt(DateTime.now().toUtc()),
    };
  }

  bool get hasValidDeadline {
    return switch (dueInputMode) {
      TaskDueInputMode.none => false,
      TaskDueInputMode.absolute => dueAt != null,
      TaskDueInputMode.relative => normalizedDueOffsetValue != null,
    };
  }

  String? get recurrenceMode {
    return recurrencePreset == TaskRecurrencePreset.none
        ? null
        : AppDefaults.defaultTaskRecurrenceMode;
  }

  String? get recurrenceRrule =>
      recurrencePreset.toWireRrule(recurrenceInterval);

  TaskForm copyWith({
    String? title,
    String? description,
    bool? isPersonal,
    Object? assigneeProfileId = _unset,
    TaskDueInputMode? dueInputMode,
    TaskPriorityOption? priority,
    Object? dueAt = _unset,
    Object? dueOffsetValue = _unset,
    TaskDueOffsetUnit? dueOffsetUnit,
    ReminderPreset? reminderPreset,
    TaskRecurrencePreset? recurrencePreset,
    int? recurrenceInterval,
  }) {
    return TaskForm(
      title: title ?? this.title,
      description: description ?? this.description,
      isPersonal: isPersonal ?? this.isPersonal,
      priority: priority ?? this.priority,
      assigneeProfileId: assigneeProfileId == _unset
          ? this.assigneeProfileId
          : assigneeProfileId as int?,
      dueInputMode: dueInputMode ?? this.dueInputMode,
      dueAt: dueAt == _unset ? this.dueAt : dueAt as DateTime?,
      dueOffsetValue: dueOffsetValue == _unset
          ? this.dueOffsetValue
          : dueOffsetValue as int?,
      dueOffsetUnit: dueOffsetUnit ?? this.dueOffsetUnit,
      reminderPreset: reminderPreset ?? this.reminderPreset,
      recurrencePreset: recurrencePreset ?? this.recurrencePreset,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
    );
  }
}

TaskDueInputMode _dueInputModeFromTask(TaskDto task) {
  final explicitMode = TaskDueInputModeX.fromWireValue(task.dueInputMode);
  if (task.dueInputMode != null) {
    return explicitMode;
  }
  return task.dueAt == null ? TaskDueInputMode.none : TaskDueInputMode.absolute;
}

ReminderPreset reminderPresetFromTask({
  required TaskDto task,
  ReminderDto? reminder,
}) {
  if (task.dueAt == null ||
      reminder == null ||
      reminder.status != 'scheduled') {
    return ReminderPreset.none;
  }

  final offset = task.dueAt!.difference(reminder.remindAt.toUtc());
  final minutes = offset.inMinutes;
  return switch (minutes) {
    0 => ReminderPreset.atTime,
    10 => ReminderPreset.tenMinutesBefore,
    60 => ReminderPreset.oneHourBefore,
    1440 => ReminderPreset.oneDayBefore,
    _ => ReminderPreset.none,
  };
}

const _unset = Object();
