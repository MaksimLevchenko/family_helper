import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';

class CalendarFormatters {
  static String fullDate(BuildContext context, DateTime date) {
    final local = date.toLocal();
    return DateFormat.yMMMMd(_locale(context)).format(local);
  }

  static String monthLabel(BuildContext context, DateTime date) {
    final local = date.toLocal();
    return DateFormat.yMMMM(_locale(context)).format(local);
  }

  static String timeOfDay(BuildContext context, DateTime dateTime) {
    final local = dateTime.toLocal();
    return DateFormat.Hm(_locale(context)).format(local);
  }

  static String timeRange(BuildContext context, DateTime start, DateTime end) {
    return '${timeOfDay(context, start)} - ${timeOfDay(context, end)}';
  }

  static String durationLabel(
    BuildContext context,
    DateTime start,
    DateTime end,
  ) {
    final difference = end.difference(start);
    if (difference.inHours >= 1) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      return minutes == 0
          ? context.l10n.calendarDurationHours(hours)
          : context.l10n.calendarDurationHoursMinutes(hours, minutes);
    }
    return context.l10n.calendarDurationMinutes(difference.inMinutes);
  }

  static String weekdayShort(BuildContext context, int weekday) {
    return DateFormat.E(_locale(context)).format(_weekdayDate(weekday));
  }

  static String weekdayCompact(BuildContext context, int weekday) {
    return DateFormat.EEEEE(_locale(context)).format(_weekdayDate(weekday));
  }

  static String _locale(BuildContext context) =>
      Localizations.localeOf(context).toLanguageTag();

  static DateTime _weekdayDate(int weekday) =>
      DateTime.utc(2024, 1, weekday.clamp(1, 7));
}
