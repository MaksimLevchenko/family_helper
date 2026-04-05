import 'dart:convert';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/config/app_defaults.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../ui_kit/app_modal_sheet.dart';
import '../../../../ui_kit/app_button.dart';
import '../../../../ui_kit/date_time_picker.dart';
import '../../../../ui_kit/family_member_avatar.dart';
import '../../../media/providers/media_provider.dart';
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
  final loadSignedUrl = context.read<MediaCubit?>()?.loadSignedUrl;
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
        loadSignedUrl: loadSignedUrl,
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
            title: context.l10n.commonTaskReminderTitle,
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
    required this.loadSignedUrl,
    required this.onSubmit,
    this.nowProvider,
  });

  final TaskForm initialForm;
  final List<FamilyMemberDto> members;
  final int? currentProfileId;
  final bool isSubmitting;
  final TaskDto? existingTask;
  final Future<String> Function(int mediaId)? loadSignedUrl;
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

  String _priorityLabel(TaskPriorityOption priority) {
    final l10n = context.l10n;
    return switch (priority) {
      TaskPriorityOption.low => l10n.taskPriorityLow,
      TaskPriorityOption.normal => l10n.taskPriorityNormal,
      TaskPriorityOption.high => l10n.taskPriorityHigh,
    };
  }

  String _recurrenceLabel(TaskRecurrencePreset preset) {
    final l10n = context.l10n;
    return switch (preset) {
      TaskRecurrencePreset.none => l10n.taskRepeatNone,
      TaskRecurrencePreset.daily => l10n.taskRepeatDaily,
      TaskRecurrencePreset.weekly => l10n.taskRepeatWeekly,
      TaskRecurrencePreset.monthly => l10n.taskRepeatMonthly,
    };
  }

  String _dueModeLabel(TaskDueInputMode mode) {
    final l10n = context.l10n;
    return switch (mode) {
      TaskDueInputMode.none => l10n.taskDeadlineModeNone,
      TaskDueInputMode.absolute => l10n.taskDeadlineModeSpecificDate,
      TaskDueInputMode.relative => l10n.taskDeadlineModeIn,
    };
  }

  String _offsetUnitLabel(TaskDueOffsetUnit unit) {
    final l10n = context.l10n;
    return switch (unit) {
      TaskDueOffsetUnit.minutes => l10n.taskOffsetUnitMinutes,
      TaskDueOffsetUnit.hours => l10n.taskOffsetUnitHours,
      TaskDueOffsetUnit.days => l10n.taskOffsetUnitDays,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
              isEditing ? l10n.taskEditorEditTitle : l10n.taskEditorCreateTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isEditing
                  ? l10n.taskEditorEditSubtitle
                  : l10n.taskEditorCreateSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const Key('task-editor-title-field'),
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.taskEditorTitleLabel,
                hintText: l10n.taskEditorTitleHint,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.taskEditorTitleValidation;
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
              decoration: InputDecoration(
                labelText: l10n.taskEditorDescriptionLabel,
                hintText: l10n.taskEditorDescriptionHint,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isPersonal,
              title: Text(l10n.taskEditorPersonalTaskLabel),
              subtitle: Text(
                _isPersonal
                    ? l10n.taskEditorPersonalTaskOn
                    : l10n.taskEditorPersonalTaskOff,
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
              decoration: InputDecoration(labelText: l10n.taskEditorPriorityLabel),
              items: TaskPriorityOption.values
                  .map(
                    (priority) => DropdownMenuItem<TaskPriorityOption>(
                      value: priority,
                      child: Text(_priorityLabel(priority)),
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
                decoration: InputDecoration(
                  labelText: l10n.taskEditorAssigneeLabel,
                ),
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text(l10n.taskEditorUnassigned),
                  ),
                  ...activeMembers.map(
                    (member) => DropdownMenuItem<int?>(
                      value: member.profileId,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 240),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FamilyMemberAvatar(
                              displayName: member.displayName,
                              avatarMediaId: member.avatarMediaId,
                              size: 28,
                              loadSignedUrl: widget.loadSignedUrl,
                            ),
                            const SizedBox(width: 10),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 190),
                              child: Text(
                                member.displayName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
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
              dueModeLabel: _dueModeLabel,
              dueOffsetUnitLabel: _offsetUnitLabel,
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
              label: l10n.taskEditorReminderLabel,
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
              decoration: InputDecoration(labelText: l10n.taskEditorRepeatLabel),
              items: TaskRecurrencePreset.values
                  .map(
                    (preset) => DropdownMenuItem<TaskRecurrencePreset>(
                      value: preset,
                      child: Text(_recurrenceLabel(preset)),
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
                decoration: InputDecoration(labelText: l10n.taskEditorIntervalLabel),
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
              label: isEditing
                  ? l10n.taskEditorSaveChanges
                  : l10n.taskEditorCreateAction,
              isLoading: widget.isSubmitting,
              onPressed: widget.isSubmitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dueInputMode == TaskDueInputMode.absolute && _dueAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.taskEditorDeadlineMissingMessage,
          ),
        ),
      );
      return;
    }

    if ((_reminderPreset != ReminderPreset.none ||
            _recurrencePreset != TaskRecurrencePreset.none) &&
        _resolvedDueAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.taskEditorDeadlineRequiredMessage,
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
    required this.dueModeLabel,
    required this.dueOffsetUnitLabel,
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
  final String Function(TaskDueInputMode mode) dueModeLabel;
  final String Function(TaskDueOffsetUnit unit) dueOffsetUnitLabel;
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
        Text(context.l10n.taskEditorDeadlineLabel, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in TaskDueInputMode.values)
              ChoiceChip(
                key: Key('task-editor-deadline-mode-${option.name}'),
                label: Text(dueModeLabel(option)),
                selected: mode == option,
                onSelected: (_) => onModeChanged(option),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (mode == TaskDueInputMode.none)
          Text(
            context.l10n.taskEditorNoDeadlineDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else if (mode == TaskDueInputMode.absolute)
          DateTimePickerField(
            key: const Key('task-editor-due-at-field'),
            label: context.l10n.taskEditorDueAtLabel,
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
                      label: Text(_relativePresetLabel(context, preset)),
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
                      decoration: InputDecoration(
                        labelText: context.l10n.taskEditorAmountLabel,
                        hintText: context.l10n.taskEditorAmountHint,
                      ),
                      onChanged: onRelativeValueChanged,
                      validator: (_) {
                        if (mode != TaskDueInputMode.relative) {
                          return null;
                        }
                        final value = int.tryParse(dueOffsetValue.text.trim());
                        if (value == null || value < 1) {
                          return context.l10n.taskEditorPositiveNumberValidation;
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
                      decoration: InputDecoration(labelText: context.l10n.taskEditorUnitLabel),
                      items: TaskDueOffsetUnit.values
                          .map(
                            (unit) => DropdownMenuItem<TaskDueOffsetUnit>(
                              value: unit,
                              child: Text(dueOffsetUnitLabel(unit)),
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
                    ? context.l10n.taskEditorDeadlinePreviewInvalid
                    : context.l10n.taskEditorDeadlinePreview(
                        formatPreview(previewDueAt!),
                      ),
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
    required this.value,
    required this.unit,
  });

  final String key;
  final int value;
  final TaskDueOffsetUnit unit;
}

String _relativePresetLabel(BuildContext context, _RelativeDuePreset preset) {
  return switch (preset.key) {
    '30m' => context.l10n.taskEditorRelativePresetThirtyMinutes,
    '1h' => context.l10n.taskEditorRelativePresetOneHour,
    '3h' => context.l10n.taskEditorRelativePresetThreeHours,
    '1d' => context.l10n.taskEditorRelativePresetOneDay,
    '3d' => context.l10n.taskEditorRelativePresetThreeDays,
    _ => '${preset.value}',
  };
}

const _relativeDuePresets = [
  _RelativeDuePreset(
    key: '30m',
    value: 30,
    unit: TaskDueOffsetUnit.minutes,
  ),
  _RelativeDuePreset(
    key: '1h',
    value: 1,
    unit: TaskDueOffsetUnit.hours,
  ),
  _RelativeDuePreset(
    key: '3h',
    value: 3,
    unit: TaskDueOffsetUnit.hours,
  ),
  _RelativeDuePreset(
    key: '1d',
    value: 1,
    unit: TaskDueOffsetUnit.days,
  ),
  _RelativeDuePreset(
    key: '3d',
    value: 3,
    unit: TaskDueOffsetUnit.days,
  ),
];
