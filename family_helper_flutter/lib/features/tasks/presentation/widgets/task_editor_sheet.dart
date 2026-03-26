import 'dart:convert';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  });

  final TaskForm initialForm;
  final List<FamilyMemberDto> members;
  final int? currentProfileId;
  final bool isSubmitting;
  final TaskDto? existingTask;
  final Future<bool> Function(TaskForm form) onSubmit;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late TaskPriorityOption _priority;
  late bool _isPersonal;
  late int? _assigneeProfileId;
  late DateTime? _dueAt;
  late ReminderPreset _reminderPreset;
  late TaskRecurrencePreset _recurrencePreset;
  late int _recurrenceInterval;

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
    _dueAt = widget.initialForm.dueAt;
    _reminderPreset = widget.initialForm.reminderPreset;
    _recurrencePreset = widget.initialForm.recurrencePreset;
    _recurrenceInterval = widget.initialForm.recurrenceInterval;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            Text(
              isEditing ? 'Edit task' : 'Create task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isEditing
                  ? 'Update assignment, due date, recurrence, and reminder settings.'
                  : 'Create a family task with assignment, due date, and reminder settings.',
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
            DueDateField(
              value: _dueAt,
              onChanged: (value) {
                setState(() {
                  _dueAt = value;
                });
              },
              onClear: () {
                setState(() {
                  _dueAt = null;
                  _reminderPreset = ReminderPreset.none;
                  _recurrencePreset = TaskRecurrencePreset.none;
                  _recurrenceInterval = 1;
                });
              },
            ),
            const SizedBox(height: 12),
            ReminderPresetField(
              key: const Key('task-editor-reminder-field'),
              label: 'Reminder',
              value: _reminderPreset,
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
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _recurrencePreset = value;
                  if (value == TaskRecurrencePreset.none) {
                    _recurrenceInterval = 1;
                  }
                });
              },
            ),
            if (_recurrencePreset != TaskRecurrencePreset.none) ...[
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

    if ((_reminderPreset != ReminderPreset.none ||
            _recurrencePreset != TaskRecurrencePreset.none) &&
        _dueAt == null) {
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
        dueAt: _dueAt,
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

class DueDateField extends StatelessWidget {
  const DueDateField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DateTimePickerField(
            key: const Key('task-editor-due-at-field'),
            label: 'Due at',
            value: value,
            onChanged: onChanged,
          ),
        ),
        IconButton(
          key: const Key('task-editor-clear-due-at-button'),
          onPressed: value == null ? null : onClear,
          icon: const Icon(Icons.clear),
          tooltip: 'Clear due date',
        ),
      ],
    );
  }
}
