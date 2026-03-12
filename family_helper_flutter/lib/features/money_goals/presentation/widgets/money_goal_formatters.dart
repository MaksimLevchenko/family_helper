import 'package:family_helper_client/family_helper_client.dart';

String formatMoneyCents(int amountCents, String currency) {
  final sign = amountCents < 0 ? '-' : '';
  final absoluteValue = amountCents.abs();
  final units = absoluteValue ~/ 100;
  final decimals = (absoluteValue % 100).toString().padLeft(2, '0');
  final groupedUnits = _groupThousands(units.toString());
  return '$sign$groupedUnits.$decimals ${_currencyLabel(currency)}';
}

int? parseMoneyInputToCents(String rawValue) {
  final normalized = rawValue.trim().replaceAll(' ', '');
  if (normalized.isEmpty) {
    return null;
  }

  final decimalSeparator = _detectDecimalSeparator(normalized);
  var sanitized = normalized;

  if (decimalSeparator == '.') {
    sanitized = sanitized.replaceAll(',', '');
  } else if (decimalSeparator == ',') {
    sanitized = sanitized.replaceAll('.', '');
    sanitized = sanitized.replaceAll(',', '.');
  }

  if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(sanitized)) {
    return null;
  }

  final parts = sanitized.split('.');
  final units = int.tryParse(parts[0]);
  if (units == null) {
    return null;
  }

  final decimalPart = parts.length == 1
      ? '00'
      : parts[1].padRight(2, '0').substring(0, 2);
  final cents = int.tryParse(decimalPart);
  if (cents == null) {
    return null;
  }

  return units * 100 + cents;
}

double goalProgressValue(MoneyGoalDto goal) {
  if (goal.targetAmountCents <= 0) {
    return 0;
  }
  return (goal.currentAmountCents / goal.targetAmountCents)
      .clamp(0, 1)
      .toDouble();
}

String formatGoalProgressLabel(MoneyGoalDto goal) {
  return '${formatMoneyCents(goal.currentAmountCents, goal.currency)} of ${formatMoneyCents(goal.targetAmountCents, goal.currency)}';
}

String formatProgressPercent(double value) {
  return '${(value * 100).round()}%';
}

String formatRemainingAmount(MoneyGoalDto goal) {
  final remaining = goal.targetAmountCents - goal.currentAmountCents;
  final clamped = remaining < 0 ? 0 : remaining;
  return formatMoneyCents(clamped, goal.currency);
}

String formatStatusText(MoneyGoalDto goal) {
  if (goal.archivedAt != null) {
    return 'Archived on ${formatShortDate(goal.archivedAt!)}';
  }
  if (goal.reachedAt != null) {
    return 'Reached on ${formatShortDate(goal.reachedAt!)}';
  }
  return 'Updated ${formatShortDateTime(goal.updatedAt)}';
}

bool isArchivedGoal(MoneyGoalDto goal) => goal.archivedAt != null;

bool isWithdrawalHistoryEntry(MoneyGoalHistoryEntryDto entry) {
  return entry.amountCents < 0;
}

String formatHistoryHeadline(MoneyGoalHistoryEntryDto entry) {
  final verb = isWithdrawalHistoryEntry(entry) ? 'withdrew' : 'added';
  final amount = formatMoneyCents(entry.amountCents.abs(), entry.currency);
  return '${entry.actorDisplayName} $verb $amount';
}

String formatShortDate(DateTime dateTime) {
  final localValue = dateTime.toLocal();
  final month = _monthNames[localValue.month - 1];
  return '$month ${localValue.day}, ${localValue.year}';
}

String formatShortDateTime(DateTime dateTime) {
  final localValue = dateTime.toLocal();
  final hour = localValue.hour.toString().padLeft(2, '0');
  final minute = localValue.minute.toString().padLeft(2, '0');
  return '${formatShortDate(localValue)}, $hour:$minute';
}

String _groupThousands(String rawValue) {
  final buffer = StringBuffer();
  for (var index = 0; index < rawValue.length; index++) {
    final remaining = rawValue.length - index;
    buffer.write(rawValue[index]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _currencyLabel(String currency) {
  return switch (currency) {
    'USD' => 'USD',
    'EUR' => 'EUR',
    'RUB' => 'RUB',
    _ => currency,
  };
}

String? _detectDecimalSeparator(String value) {
  final lastDot = value.lastIndexOf('.');
  final lastComma = value.lastIndexOf(',');
  if (lastDot == -1 && lastComma == -1) {
    return null;
  }
  return lastDot > lastComma ? '.' : ',';
}

const _monthNames = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
