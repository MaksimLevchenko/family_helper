import 'package:family_helper_client/family_helper_client.dart';

import '../../notifications/domain/notification_models.dart';

enum CalendarMutationScope { one, future, all }

extension CalendarMutationScopeX on CalendarMutationScope {
  String get apiValue {
    return switch (this) {
      CalendarMutationScope.one => 'one',
      CalendarMutationScope.future => 'future',
      CalendarMutationScope.all => 'all',
    };
  }

  String get label {
    return switch (this) {
      CalendarMutationScope.one => 'This occurrence',
      CalendarMutationScope.future => 'This and following',
      CalendarMutationScope.all => 'Whole series',
    };
  }
}

enum CalendarRecurrenceMode { none, yearly, monthly, weekly, everyNDays }

class CalendarRecurrence {
  const CalendarRecurrence._({
    required this.mode,
    required this.interval,
    required this.weekdays,
  });

  const CalendarRecurrence.none()
    : this._(
        mode: CalendarRecurrenceMode.none,
        interval: 1,
        weekdays: const <int>{},
      );

  factory CalendarRecurrence.yearly() {
    return const CalendarRecurrence._(
      mode: CalendarRecurrenceMode.yearly,
      interval: 1,
      weekdays: <int>{},
    );
  }

  factory CalendarRecurrence.monthly() {
    return const CalendarRecurrence._(
      mode: CalendarRecurrenceMode.monthly,
      interval: 1,
      weekdays: <int>{},
    );
  }

  factory CalendarRecurrence.weekly(Set<int> weekdays) {
    return CalendarRecurrence._(
      mode: CalendarRecurrenceMode.weekly,
      interval: 1,
      weekdays: weekdays.isEmpty ? const <int>{DateTime.monday} : weekdays,
    );
  }

  factory CalendarRecurrence.everyNDays(int interval) {
    return CalendarRecurrence._(
      mode: CalendarRecurrenceMode.everyNDays,
      interval: interval < 1 ? 1 : interval,
      weekdays: const <int>{},
    );
  }

  factory CalendarRecurrence.fromRrule(String? rrule, DateTime startsAt) {
    final trimmed = rrule?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return const CalendarRecurrence.none();
    }

    final parts = <String, String>{};
    for (final part in trimmed.split(';')) {
      final kv = part.split('=');
      if (kv.length == 2) {
        parts[kv[0].trim().toUpperCase()] = kv[1].trim();
      }
    }

    final freq = parts['FREQ']?.toUpperCase() ?? 'DAILY';
    final interval = int.tryParse(parts['INTERVAL'] ?? '1') ?? 1;
    switch (freq) {
      case 'YEARLY':
        return CalendarRecurrence.yearly();
      case 'MONTHLY':
        return CalendarRecurrence.monthly();
      case 'WEEKLY':
        final weekdays = (parts['BYDAY'] ?? '')
            .split(',')
            .map((token) => _weekdayFromToken(token.trim().toUpperCase()))
            .whereType<int>()
            .toSet();
        return CalendarRecurrence.weekly(
          weekdays.isEmpty ? <int>{startsAt.weekday} : weekdays,
        );
      case 'DAILY':
      default:
        if (interval <= 1) {
          return CalendarRecurrence.everyNDays(1);
        }
        return CalendarRecurrence.everyNDays(interval);
    }
  }

  final CalendarRecurrenceMode mode;
  final int interval;
  final Set<int> weekdays;

  bool get isRecurring => mode != CalendarRecurrenceMode.none;

  String? toRrule() {
    return switch (mode) {
      CalendarRecurrenceMode.none => null,
      CalendarRecurrenceMode.yearly => 'FREQ=YEARLY;INTERVAL=1',
      CalendarRecurrenceMode.monthly => 'FREQ=MONTHLY;INTERVAL=1',
      CalendarRecurrenceMode.weekly =>
        'FREQ=WEEKLY;INTERVAL=1;BYDAY=${_weekdayTokens(weekdays).join(',')}',
      CalendarRecurrenceMode.everyNDays =>
        'FREQ=DAILY;INTERVAL=${interval < 1 ? 1 : interval}',
    };
  }

  CalendarRecurrence copyWith({
    CalendarRecurrenceMode? mode,
    int? interval,
    Set<int>? weekdays,
  }) {
    return CalendarRecurrence._(
      mode: mode ?? this.mode,
      interval: interval ?? this.interval,
      weekdays: weekdays ?? this.weekdays,
    );
  }

  static int? _weekdayFromToken(String token) {
    return switch (token) {
      'MO' => DateTime.monday,
      'TU' => DateTime.tuesday,
      'WE' => DateTime.wednesday,
      'TH' => DateTime.thursday,
      'FR' => DateTime.friday,
      'SA' => DateTime.saturday,
      'SU' => DateTime.sunday,
      _ => null,
    };
  }

  static List<String> _weekdayTokens(Set<int> weekdays) {
    final ordered = weekdays.toList()..sort();
    return ordered.map((weekday) {
      return switch (weekday) {
        DateTime.monday => 'MO',
        DateTime.tuesday => 'TU',
        DateTime.wednesday => 'WE',
        DateTime.thursday => 'TH',
        DateTime.friday => 'FR',
        DateTime.saturday => 'SA',
        DateTime.sunday => 'SU',
        _ => 'MO',
      };
    }).toList();
  }
}

class CalendarEventForm {
  const CalendarEventForm({
    required this.title,
    required this.startsAt,
    required this.endsAt,
    required this.recurrence,
    required this.reminderPreset,
    this.description,
  });

  factory CalendarEventForm.createDefault(DateTime selectedDay) {
    final localStart = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
      9,
    );
    return CalendarEventForm(
      title: '',
      startsAt: localStart.toUtc(),
      endsAt: localStart.add(const Duration(hours: 1)).toUtc(),
      recurrence: const CalendarRecurrence.none(),
      reminderPreset: ReminderPreset.none,
    );
  }

  factory CalendarEventForm.fromEvent(CalendarEventDto event) {
    return CalendarEventForm(
      title: event.title,
      description: event.description,
      startsAt: event.startsAt,
      endsAt: event.endsAt,
      recurrence: CalendarRecurrence.fromRrule(event.rrule, event.startsAt),
      reminderPreset: _presetFromOffset(event.reminderOffsetMinutes),
    );
  }

  factory CalendarEventForm.fromInstance(CalendarInstanceDto instance) {
    return CalendarEventForm(
      title: instance.title,
      startsAt: instance.occurrenceStart,
      endsAt: instance.occurrenceEnd,
      recurrence: const CalendarRecurrence.none(),
      reminderPreset: _presetFromOffset(instance.reminderOffsetMinutes),
    );
  }

  final String title;
  final String? description;
  final DateTime startsAt;
  final DateTime endsAt;
  final CalendarRecurrence recurrence;
  final ReminderPreset reminderPreset;

  String? get rrule => recurrence.toRrule();

  int? get reminderOffsetMinutes {
    final offset = reminderPreset.offset;
    if (offset == null) {
      return null;
    }
    return offset.inMinutes;
  }

  CalendarEventForm copyWith({
    String? title,
    String? description,
    DateTime? startsAt,
    DateTime? endsAt,
    CalendarRecurrence? recurrence,
    ReminderPreset? reminderPreset,
  }) {
    return CalendarEventForm(
      title: title ?? this.title,
      description: description ?? this.description,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      recurrence: recurrence ?? this.recurrence,
      reminderPreset: reminderPreset ?? this.reminderPreset,
    );
  }

  static ReminderPreset _presetFromOffset(int? minutes) {
    return switch (minutes) {
      null => ReminderPreset.none,
      0 => ReminderPreset.atTime,
      10 => ReminderPreset.tenMinutesBefore,
      60 => ReminderPreset.oneHourBefore,
      1440 => ReminderPreset.oneDayBefore,
      _ => ReminderPreset.none,
    };
  }
}
