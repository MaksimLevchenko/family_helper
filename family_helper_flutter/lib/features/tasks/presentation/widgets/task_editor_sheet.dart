import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_defaults.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../ui_kit/app_button.dart';
import '../../../../ui_kit/app_modal_sheet.dart';
import '../../../family_invites/providers/family_provider.dart';
import '../../../media/providers/media_provider.dart';
import '../../../notifications/data/notification_target.dart';
import '../../../notifications/domain/notification_models.dart';
import '../../../notifications/providers/notifications_provider.dart';
import '../../domain/task_form.dart';
import '../../providers/tasks_provider.dart';
import 'task_deadline_section.dart';
import 'task_editor_form_sections.dart';
import 'task_editor_recurrence_controls.dart';

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

          final familyId = context.read<FamilySelectionCubit>().state;
          final remindAt = form.dueAt == null
              ? null
              : form.reminderPreset.scheduleAt(form.dueAt!);
          cubit.setReminderSyncing(true);
          final reminderResult = await notificationsCubit.replaceEntityReminder(
            notificationType: AppDefaults.taskNotificationType,
            entityType: AppDefaults.taskReminderEntityType,
            entityId: savedTask.id,
            remindAt: remindAt,
            payloadJson: buildNotificationTargetPayloadJson(
              familyId: familyId ?? savedTask.familyId,
              entityType: AppDefaults.taskReminderEntityType,
              entityId: savedTask.id,
              payload: {'taskId': savedTask.id},
            ),
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
    final isEditing = widget.existingTask != null;
    final activeMembers = widget.members
        .where((member) => member.status == 'active')
        .toList();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskEditorHeader(isEditing: isEditing),
            const SizedBox(height: 16),
            TaskEditorBasicsSection(
              titleController: _titleController,
              descriptionController: _descriptionController,
              isPersonal: _isPersonal,
              priority: _priority,
              assigneeProfileId: _assigneeProfileId,
              activeMembers: activeMembers,
              loadSignedUrl: widget.loadSignedUrl,
              priorityLabel: _priorityLabel,
              onPersonalChanged: (value) {
                setState(() {
                  _isPersonal = value;
                  if (value) {
                    _assigneeProfileId = null;
                  }
                });
              },
              onPriorityChanged: (value) {
                setState(() {
                  _priority = value;
                });
              },
              onAssigneeChanged: (value) {
                setState(() {
                  _assigneeProfileId = value;
                });
              },
            ),
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
            TaskEditorReminderRecurrenceSection(
              hasValidDeadline: _hasValidDeadline,
              reminderPreset: _reminderPreset,
              recurrencePreset: _recurrencePreset,
              recurrenceInterval: _recurrenceInterval,
              recurrenceLabel: _recurrenceLabel,
              onReminderChanged: (value) {
                setState(() {
                  _reminderPreset = value;
                });
              },
              onRecurrenceChanged: (value) {
                setState(() {
                  _recurrencePreset = value;
                  if (value == TaskRecurrencePreset.none) {
                    _recurrenceInterval = 1;
                  }
                });
              },
              onRecurrenceIntervalChanged: (value) {
                setState(() {
                  _recurrenceInterval = value;
                });
              },
            ),
            const SizedBox(height: 20),
            AppButton(
              label: isEditing
                  ? context.l10n.taskEditorSaveChanges
                  : context.l10n.taskEditorCreateAction,
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
          content: Text(l10n.taskEditorDeadlineMissingMessage),
        ),
      );
      return;
    }

    if ((_reminderPreset != ReminderPreset.none ||
            _recurrencePreset != TaskRecurrencePreset.none) &&
        _resolvedDueAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.taskEditorDeadlineRequiredMessage),
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
