import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';

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

String formatGoalProgressLabel(BuildContext context, MoneyGoalDto goal) {
  return context.l10n.moneyGoalsProgressOf(
    formatMoneyCents(goal.currentAmountCents, goal.currency),
    formatMoneyCents(goal.targetAmountCents, goal.currency),
  );
}

String formatProgressPercent(double value) {
  return '${(value * 100).round()}%';
}

String formatRemainingAmount(MoneyGoalDto goal) {
  final remaining = goal.targetAmountCents - goal.currentAmountCents;
  final clamped = remaining < 0 ? 0 : remaining;
  return formatMoneyCents(clamped, goal.currency);
}

String formatStatusText(BuildContext context, MoneyGoalDto goal) {
  if (goal.archivedAt != null) {
    return context.l10n.moneyGoalsStatusArchivedOn(
      formatShortDate(context, goal.archivedAt!),
    );
  }
  if (goal.reachedAt != null) {
    return context.l10n.moneyGoalsStatusReachedOn(
      formatShortDate(context, goal.reachedAt!),
    );
  }
  return context.l10n.moneyGoalsStatusUpdatedAt(
    formatShortDateTime(context, goal.updatedAt),
  );
}

bool isArchivedGoal(MoneyGoalDto goal) => goal.archivedAt != null;

bool isWithdrawalHistoryEntry(MoneyGoalHistoryEntryDto entry) {
  return entry.amountCents < 0;
}

String formatHistoryHeadline(
  BuildContext context,
  MoneyGoalHistoryEntryDto entry,
) {
  final amount = formatMoneyCents(entry.amountCents.abs(), entry.currency);
  return isWithdrawalHistoryEntry(entry)
      ? context.l10n.moneyGoalsHistoryWithdrew(
          entry.actorDisplayName,
          amount,
        )
      : context.l10n.moneyGoalsHistoryAdded(
          entry.actorDisplayName,
          amount,
        );
}

String formatShortDate(BuildContext context, DateTime dateTime) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).format(dateTime.toLocal());
}

String formatShortDateTime(BuildContext context, DateTime dateTime) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final localValue = dateTime.toLocal();
  return DateFormat.yMMMd(locale).add_Hm().format(localValue);
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
