import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../ui_kit/date_time_picker.dart';
import '../../domain/task_form.dart';
import 'task_editor_presets.dart';

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
        Text(
          context.l10n.taskEditorDeadlineLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
                  for (final preset in relativeDuePresets)
                    ChoiceChip(
                      key: Key('task-editor-relative-preset-${preset.key}'),
                      label: Text(relativePresetLabel(context, preset)),
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
                          return context
                              .l10n
                              .taskEditorPositiveNumberValidation;
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
                      decoration: InputDecoration(
                        labelText: context.l10n.taskEditorUnitLabel,
                      ),
                      items: TaskDueOffsetUnit.values
                          .map(
                            (unit) => DropdownMenuItem<TaskDueOffsetUnit>(
                              value: unit,
                              child: Text(dueOffsetUnitLabel(unit)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onRelativeUnitChanged(value);
                        }
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
