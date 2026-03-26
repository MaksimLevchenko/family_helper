import 'dart:convert';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/config/app_defaults.dart';
import '../../../../ui_kit/app_modal_sheet.dart';
import '../../../../ui_kit/app_button.dart';
import '../../../../ui_kit/date_time_picker.dart';
import '../../../notifications/domain/notification_models.dart';
import '../../../notifications/providers/notifications_provider.dart';
import '../../domain/task_form.dart';
import '../../providers/tasks_provider.dart';

Future<void> showTaskEditor(
  BuildContext context, {
  required bool isWide,
  required List<FamilyMemberDto> members,
  required int? currentProfileId,
  required NotificationsState notificationsState,
  required TaskDto? existingTask,
}) async {
  final cubit = context.read<TasksCubit>();
  final notificationsCubit = context.read<NotificationsCubit>();
  final reminder = existingTask == null
      ? null
      : scheduledReminderForTask(
          notificationsState,
          existingTask.id,
        );
  final initialForm = existingTask == null
      ? TaskForm.create(currentProfileId: currentProfileId)
      : TaskForm.fromTask(
          existingTask,
          reminderPreset: reminderPresetFromTask(
            task: existingTask,
            reminder: reminder,
          ),
        );

  final child = BlocBuilder<TasksCubit, TasksState>(
    builder: (context, state) {
      return TaskEditorSheet(
        initialForm: initialForm,
        members: members,
        currentProfileId: currentProfileId,
        isSubmitting: state.isSavingTask || state.isReminderSyncing,
        existingTask: existingTask,
        onSubmit: (form) async {
          final messenger = ScaffoldMessenger.of(context);
          final savedTask = await cubit.saveTask(
            form,
            taskId: existingTask?.id,
          );
          if (!context.mounted || savedTask == null) {
            return false;
          }

          final remindAt = form.dueAt == null
              ? null
              : form.reminderPreset.scheduleAt(form.dueAt!);
          cubit.setReminderSyncing(true);
          final reminderResult = await notificationsCubit.replaceEntityReminder(
            notificationType: AppDefaults.taskNotificationType,
            entityType: AppDefaults.taskReminderEntityType,
            entityId: savedTask.id,
            remindAt: remindAt,
            payloadJson: jsonEncode({'taskId': savedTask.id}),
            title: 'Task reminder',
            body: savedTask.title,
          );
          cubit.setReminderSyncing(false);

          if (!context.mounted) {
            return false;
          }
          if (reminderResult.message != null) {
            messenger.showSnackBar(
              SnackBar(content: Text(reminderResult.message!)),
            );
          }
          return true;
        },
      );
    },
  );

  if (isWide) {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider<TasksCubit>.value(
          value: cubit,
          child: Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: child,
              ),
            ),
          ),
        );
      },
    );
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return BlocProvider<TasksCubit>.value(
        value: cubit,
        child: AppModalSheet(
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          scrollable: false,
          child: child,
        ),
      );
    },
  );
}

ReminderDto? scheduledReminderForTask(NotificationsState state, int taskId) {
  for (final reminder in state.reminders) {
    if (reminder.entityType == AppDefaults.taskReminderEntityType &&
        reminder.entityId == taskId &&
        reminder.status == 'scheduled') {
      return reminder;
    }
  }
  return null;
}

class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({
    super.key,
    required this.initialForm,
    required this.members,
    required this.currentProfileId,
    required this.isSubmitting,
    required this.existingTask,
    required this.onSubmit,
    this.nowProvider,
  });

  final TaskForm initialForm;
  final List<FamilyMemberDto> members;
  final int? currentProfileId;
  final bool isSubmitting;
  final TaskDto? existingTask;
  final Future<bool> Function(TaskForm form) onSubmit;
  final DateTime Function()? nowProvider;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dueOffsetController;
  late TaskPriorityOption _priority;
  late bool _isPersonal;
  late int? _assigneeProfileId;
  late TaskDueInputMode _dueInputMode;
  late DateTime? _dueAt;
  late TaskDueOffsetUnit _dueOffsetUnit;
  late ReminderPreset _reminderPreset;
  late TaskRecurrencePreset _recurrencePreset;
  late int _recurrenceInterval;
  bool _deadlineDirty = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialForm.title);
    _descriptionController = TextEditingController(
      text: widget.initialForm.description,
    );
    _priority = widget.initialForm.priority;
    _isPersonal = widget.initialForm.isPersonal;
    _assigneeProfileId = widget.initialForm.assigneeProfileId;
    _dueInputMode = widget.initialForm.dueInputMode;
    _dueAt = widget.initialForm.dueAt;
    _dueOffsetController = TextEditingController(
      text: widget.initialForm.dueOffsetValue?.toString() ?? '1',
    );
    _dueOffsetUnit = widget.initialForm.dueOffsetUnit;
    _reminderPreset = widget.initialForm.reminderPreset;
    _recurrencePreset = widget.initialForm.recurrencePreset;
    _recurrenceInterval = widget.initialForm.recurrenceInterval;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueOffsetController.dispose();
    super.dispose();
  }

  DateTime _nowUtc() => (widget.nowProvider?.call() ?? DateTime.now()).toUtc();

  int? get _dueOffsetValue {
    final value = int.tryParse(_dueOffsetController.text.trim());
    if (value == null || value < 1) {
      return null;
    }
    return value;
  }

  DateTime? get _resolvedDueAt {
    switch (_dueInputMode) {
      case TaskDueInputMode.none:
        return null;
      case TaskDueInputMode.absolute:
        return _dueAt;
      case TaskDueInputMode.relative:
        final offsetValue = _dueOffsetValue;
        if (offsetValue == null) {
          return null;
        }
        if (!_deadlineDirty &&
            widget.initialForm.dueInputMode == TaskDueInputMode.relative &&
            widget.initialForm.dueAt != null &&
            widget.initialForm.dueOffsetValue == offsetValue &&
            widget.initialForm.dueOffsetUnit == _dueOffsetUnit) {
          return widget.initialForm.dueAt;
        }
        return _nowUtc().add(_dueOffsetUnit.toDuration(offsetValue));
    }
  }

  bool get _hasValidDeadline => _resolvedDueAt != null;

  void _markDeadlineChanged() {
    _deadlineDirty = true;
  }

  void _resetDeadlineDependentFields() {
    _reminderPreset = ReminderPreset.none;
    _recurrencePreset = TaskRecurrencePreset.none;
    _recurrenceInterval = 1;
  }

  void _setDueInputMode(TaskDueInputMode mode) {
    setState(() {
      _markDeadlineChanged();
      _dueInputMode = mode;
      if (mode == TaskDueInputMode.none) {
        _dueAt = null;
        _resetDeadlineDependentFields();
      } else if (mode == TaskDueInputMode.relative) {
        _dueOffsetController.text = _dueOffsetController.text.trim().isEmpty
            ? '1'
            : _dueOffsetController.text.trim();
      }
    });
  }

  void _applyRelativePreset(int value, TaskDueOffsetUnit unit) {
    setState(() {
      _markDeadlineChanged();
      _dueInputMode = TaskDueInputMode.relative;
      _dueOffsetController.text = '$value';
      _dueOffsetUnit = unit;
    });
  }

  String _formatDuePreview(DateTime value) {
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$month/$day ${local.year} $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;
    final activeMembers = widget.members
        .where((member) => member.status == 'active')
        .toList();
    final hasValidDeadline = _hasValidDeadline;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Edit task' : 'Create task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isEditing
                  ? 'Update assignment, deadline, recurrence, and reminder settings.'
                  : 'Create a family task with an optional deadline, recurrence, and reminders.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('task-editor-title-field'),
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task title',
                hintText: 'Prepare the weekly grocery list',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a task title.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('task-editor-description-field'),
              controller: _descriptionController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional note for the family',
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isPersonal,
              title: const Text('Personal task'),
              subtitle: Text(
                _isPersonal
                    ? 'Only you will see this task.'
                    : 'Shared tasks stay visible to the whole family.',
              ),
              onChanged: (value) {
                setState(() {
                  _isPersonal = value;
                  if (value) {
                    _assigneeProfileId = null;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TaskPriorityOption>(
              key: const Key('task-editor-priority-field'),
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: TaskPriorityOption.values
                  .map(
                    (priority) => DropdownMenuItem<TaskPriorityOption>(
                      value: priority,
                      child: Text(priority.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _priority = value;
                });
              },
            ),
            if (!_isPersonal) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                key: const Key('task-editor-assignee-field'),
                initialValue: _assigneeProfileId,
                decoration: const InputDecoration(labelText: 'Assignee'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Unassigned'),
                  ),
                  ...activeMembers.map(
                    (member) => DropdownMenuItem<int?>(
                      value: member.profileId,
                      child: Text(member.displayName),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _assigneeProfileId = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 12),
            TaskDeadlineSection(
              mode: _dueInputMode,
              dueAt: _dueAt,
              dueOffsetValue: _dueOffsetController,
              dueOffsetUnit: _dueOffsetUnit,
              previewDueAt: _resolvedDueAt,
              onModeChanged: _setDueInputMode,
              onAbsoluteChanged: (value) {
                setState(() {
                  _markDeadlineChanged();
                  _dueAt = value;
                });
              },
              onRelativePresetSelected: _applyRelativePreset,
              onRelativeValueChanged: (_) {
                setState(() {
                  _markDeadlineChanged();
                });
              },
              onRelativeUnitChanged: (unit) {
                setState(() {
                  _markDeadlineChanged();
                  _dueOffsetUnit = unit;
                });
              },
              formatPreview: _formatDuePreview,
            ),
            const SizedBox(height: 12),
            ReminderPresetField(
              key: const Key('task-editor-reminder-field'),
              label: 'Reminder',
              value: _reminderPreset,
              enabled: hasValidDeadline,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _reminderPreset = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TaskRecurrencePreset>(
              key: const Key('task-editor-recurrence-field'),
              initialValue: _recurrencePreset,
              decoration: const InputDecoration(labelText: 'Repeat'),
              items: TaskRecurrencePreset.values
                  .map(
                    (preset) => DropdownMenuItem<TaskRecurrencePreset>(
                      value: preset,
                      child: Text(preset.label),
                    ),
                  )
                  .toList(),
              onChanged: hasValidDeadline
                  ? (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _recurrencePreset = value;
                        if (value == TaskRecurrencePreset.none) {
                          _recurrenceInterval = 1;
                        }
                      });
                    }
                  : null,
            ),
            if (_recurrencePreset != TaskRecurrencePreset.none &&
                hasValidDeadline) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                key: const Key('task-editor-recurrence-interval-field'),
                initialValue: _recurrenceInterval,
                decoration: const InputDecoration(labelText: 'Interval'),
                items: List.generate(12, (index) => index + 1)
                    .map(
                      (value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _recurrenceInterval = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 20),
            AppButton(
              label: isEditing ? 'Save changes' : 'Create task',
              isLoading: widget.isSubmitting,
              onPressed: widget.isSubmitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dueInputMode == TaskDueInputMode.absolute && _dueAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pick a deadline date and time or switch to no deadline.',
          ),
        ),
      );
      return;
    }

    if ((_reminderPreset != ReminderPreset.none ||
            _recurrencePreset != TaskRecurrencePreset.none) &&
        _resolvedDueAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Set a due date before adding reminders or recurrence.',
          ),
        ),
      );
      return;
    }

    final didSave = await widget.onSubmit(
      TaskForm(
        title: _titleController.text,
        description: _descriptionController.text,
        isPersonal: _isPersonal,
        priority: _priority,
        assigneeProfileId: _isPersonal ? null : _assigneeProfileId,
        dueInputMode: _dueInputMode,
        dueAt: _resolvedDueAt,
        dueOffsetValue: _dueInputMode == TaskDueInputMode.relative
            ? _dueOffsetValue
            : null,
        dueOffsetUnit: _dueOffsetUnit,
        reminderPreset: _reminderPreset,
        recurrencePreset: _recurrencePreset,
        recurrenceInterval: _recurrenceInterval,
      ),
    );
    if (!mounted || !didSave) {
      return;
    }
    Navigator.of(context).pop();
  }
}

class TaskDeadlineSection extends StatelessWidget {
  const TaskDeadlineSection({
    super.key,
    required this.mode,
    required this.dueAt,
    required this.dueOffsetValue,
    required this.dueOffsetUnit,
    required this.previewDueAt,
    required this.onModeChanged,
    required this.onAbsoluteChanged,
    required this.onRelativePresetSelected,
    required this.onRelativeValueChanged,
    required this.onRelativeUnitChanged,
    required this.formatPreview,
  });

  final TaskDueInputMode mode;
  final DateTime? dueAt;
  final TextEditingController dueOffsetValue;
  final TaskDueOffsetUnit dueOffsetUnit;
  final DateTime? previewDueAt;
  final ValueChanged<TaskDueInputMode> onModeChanged;
  final ValueChanged<DateTime> onAbsoluteChanged;
  final void Function(int value, TaskDueOffsetUnit unit)
  onRelativePresetSelected;
  final ValueChanged<String> onRelativeValueChanged;
  final ValueChanged<TaskDueOffsetUnit> onRelativeUnitChanged;
  final String Function(DateTime value) formatPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Deadline', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in TaskDueInputMode.values)
              ChoiceChip(
                key: Key('task-editor-deadline-mode-${option.name}'),
                label: Text(option.label),
                selected: mode == option,
                onSelected: (_) => onModeChanged(option),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (mode == TaskDueInputMode.none)
          Text(
            'This task will not have a deadline.',
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else if (mode == TaskDueInputMode.absolute)
          DateTimePickerField(
            key: const Key('task-editor-due-at-field'),
            label: 'Due at',
            value: dueAt,
            onChanged: onAbsoluteChanged,
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final preset in _relativeDuePresets)
                    ChoiceChip(
                      key: Key('task-editor-relative-preset-${preset.key}'),
                      label: Text(preset.label),
                      selected:
                          dueOffsetValue.text.trim() == '${preset.value}' &&
                          dueOffsetUnit == preset.unit,
                      onSelected: (_) =>
                          onRelativePresetSelected(preset.value, preset.unit),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('task-editor-due-offset-value-field'),
                      controller: dueOffsetValue,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        hintText: '1',
                      ),
                      onChanged: onRelativeValueChanged,
                      validator: (_) {
                        if (mode != TaskDueInputMode.relative) {
                          return null;
                        }
                        final value = int.tryParse(dueOffsetValue.text.trim());
                        if (value == null || value < 1) {
                          return 'Enter a positive number.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<TaskDueOffsetUnit>(
                      key: const Key('task-editor-due-offset-unit-field'),
                      initialValue: dueOffsetUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: TaskDueOffsetUnit.values
                          .map(
                            (unit) => DropdownMenuItem<TaskDueOffsetUnit>(
                              value: unit,
                              child: Text(unit.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        onRelativeUnitChanged(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                previewDueAt == null
                    ? 'Enter a valid offset to calculate the deadline.'
                    : 'Will be due ${formatPreview(previewDueAt!)}',
                key: const Key('task-editor-relative-preview'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
      ],
    );
  }
}

class _RelativeDuePreset {
  const _RelativeDuePreset({
    required this.key,
    required this.label,
    required this.value,
    required this.unit,
  });

  final String key;
  final String label;
  final int value;
  final TaskDueOffsetUnit unit;
}

const _relativeDuePresets = [
  _RelativeDuePreset(
    key: '30m',
    label: '30 min',
    value: 30,
    unit: TaskDueOffsetUnit.minutes,
  ),
  _RelativeDuePreset(
    key: '1h',
    label: '1 hour',
    value: 1,
    unit: TaskDueOffsetUnit.hours,
  ),
  _RelativeDuePreset(
    key: '3h',
    label: '3 hours',
    value: 3,
    unit: TaskDueOffsetUnit.hours,
  ),
  _RelativeDuePreset(
    key: '1d',
    label: '1 day',
    value: 1,
    unit: TaskDueOffsetUnit.days,
  ),
  _RelativeDuePreset(
    key: '3d',
    label: '3 days',
    value: 3,
    unit: TaskDueOffsetUnit.days,
  ),
];
