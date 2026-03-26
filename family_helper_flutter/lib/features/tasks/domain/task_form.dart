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
    return 'FREQ=${wireFrequency};INTERVAL=$normalizedInterval';
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

class TaskForm {
  const TaskForm({
    required this.title,
    required this.description,
    required this.isPersonal,
    required this.priority,
    required this.assigneeProfileId,
    required this.dueAt,
    required this.reminderPreset,
    required this.recurrencePreset,
    required this.recurrenceInterval,
  });

  final String title;
  final String description;
  final bool isPersonal;
  final TaskPriorityOption priority;
  final int? assigneeProfileId;
  final DateTime? dueAt;
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
      dueAt: null,
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
      dueAt: task.dueAt,
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
    TaskPriorityOption? priority,
    Object? dueAt = _unset,
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
      dueAt: dueAt == _unset ? this.dueAt : dueAt as DateTime?,
      reminderPreset: reminderPreset ?? this.reminderPreset,
      recurrencePreset: recurrencePreset ?? this.recurrencePreset,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
    );
  }
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
