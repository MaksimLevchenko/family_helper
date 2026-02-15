class CalendarEventForm {
  const CalendarEventForm({
    required this.title,
    required this.startsAt,
    required this.endsAt,
    this.rrule,
  });

  final String title;
  final DateTime startsAt;
  final DateTime endsAt;
  final String? rrule;
}
