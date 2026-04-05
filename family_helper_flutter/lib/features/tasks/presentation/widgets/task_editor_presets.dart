import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/task_form.dart';

class RelativeDuePreset {
  const RelativeDuePreset({
    required this.key,
    required this.value,
    required this.unit,
  });

  final String key;
  final int value;
  final TaskDueOffsetUnit unit;
}

String relativePresetLabel(BuildContext context, RelativeDuePreset preset) {
  return switch (preset.key) {
    '30m' => context.l10n.taskEditorRelativePresetThirtyMinutes,
    '1h' => context.l10n.taskEditorRelativePresetOneHour,
    '3h' => context.l10n.taskEditorRelativePresetThreeHours,
    '1d' => context.l10n.taskEditorRelativePresetOneDay,
    '3d' => context.l10n.taskEditorRelativePresetThreeDays,
    _ => '${preset.value}',
  };
}

const relativeDuePresets = [
  RelativeDuePreset(
    key: '30m',
    value: 30,
    unit: TaskDueOffsetUnit.minutes,
  ),
  RelativeDuePreset(
    key: '1h',
    value: 1,
    unit: TaskDueOffsetUnit.hours,
  ),
  RelativeDuePreset(
    key: '3h',
    value: 3,
    unit: TaskDueOffsetUnit.hours,
  ),
  RelativeDuePreset(
    key: '1d',
    value: 1,
    unit: TaskDueOffsetUnit.days,
  ),
  RelativeDuePreset(
    key: '3d',
    value: 3,
    unit: TaskDueOffsetUnit.days,
  ),
];
