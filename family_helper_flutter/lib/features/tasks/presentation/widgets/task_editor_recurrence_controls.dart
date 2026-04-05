import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../notifications/domain/notification_models.dart';
import '../../domain/task_form.dart';

class TaskEditorReminderRecurrenceSection extends StatelessWidget {
  const TaskEditorReminderRecurrenceSection({
    super.key,
    required this.hasValidDeadline,
    required this.reminderPreset,
    required this.recurrencePreset,
    required this.recurrenceInterval,
    required this.recurrenceLabel,
    required this.onReminderChanged,
    required this.onRecurrenceChanged,
    required this.onRecurrenceIntervalChanged,
  });

  final bool hasValidDeadline;
  final ReminderPreset reminderPreset;
  final TaskRecurrencePreset recurrencePreset;
  final int recurrenceInterval;
  final String Function(TaskRecurrencePreset preset) recurrenceLabel;
  final ValueChanged<ReminderPreset> onReminderChanged;
  final ValueChanged<TaskRecurrencePreset> onRecurrenceChanged;
  final ValueChanged<int> onRecurrenceIntervalChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReminderPresetField(
          key: const Key('task-editor-reminder-field'),
          label: l10n.taskEditorReminderLabel,
          value: reminderPreset,
          enabled: hasValidDeadline,
          onChanged: (value) {
            if (value != null) {
              onReminderChanged(value);
            }
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TaskRecurrencePreset>(
          key: const Key('task-editor-recurrence-field'),
          initialValue: recurrencePreset,
          decoration: InputDecoration(
            labelText: l10n.taskEditorRepeatLabel,
          ),
          items: TaskRecurrencePreset.values
              .map(
                (preset) => DropdownMenuItem<TaskRecurrencePreset>(
                  value: preset,
                  child: Text(recurrenceLabel(preset)),
                ),
              )
              .toList(),
          onChanged: hasValidDeadline
              ? (value) {
                  if (value != null) {
                    onRecurrenceChanged(value);
                  }
                }
              : null,
        ),
        if (recurrencePreset != TaskRecurrencePreset.none &&
            hasValidDeadline) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            key: const Key('task-editor-recurrence-interval-field'),
            initialValue: recurrenceInterval,
            decoration: InputDecoration(
              labelText: l10n.taskEditorIntervalLabel,
            ),
            items: List.generate(12, (index) => index + 1)
                .map(
                  (value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onRecurrenceIntervalChanged(value);
              }
            },
          ),
        ],
      ],
    );
  }
}
