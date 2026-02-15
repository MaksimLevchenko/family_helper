import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class DateTimePickerField extends StatelessWidget {
  const DateTimePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 10),
        );
        if (date == null || !context.mounted) {
          return;
        }
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value ?? now),
        );
        if (time == null) {
          return;
        }
        onChanged(
          DateTime(date.year, date.month, date.day, time.hour, time.minute)
              .toUtc(),
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          value?.toLocal().toString() ?? 'Select date and time',
          style: TextStyle(color: colors.textPrimary),
        ),
      ),
    );
  }
}
