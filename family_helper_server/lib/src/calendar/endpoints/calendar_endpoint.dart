import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/calendar_service.dart';

class CalendarEndpoint extends Endpoint {
  CalendarEndpoint({CalendarService? service})
    : service = service ?? CalendarService();

  final CalendarService service;

  Future<CalendarEventDto> getEvent(
    Session session, {
    required int familyId,
    required int eventId,
  }) {
    return service.getEvent(session, familyId: familyId, eventId: eventId);
  }

  Future<CalendarEventDto> upsertEvent(
    Session session, {
    required String clientOperationId,
    int? eventId,
    required int familyId,
    required String title,
    String? description,
    required DateTime startsAt,
    required DateTime endsAt,
    required String timezone,
    String? rrule,
    int? reminderOffsetMinutes,
    String? colorKey,
    String? category,
    String scope = 'all',
    DateTime? anchorOccurrenceStart,
  }) {
    return service.upsertEvent(
      session,
      clientOperationId: clientOperationId,
      eventId: eventId,
      familyId: familyId,
      title: title,
      description: description,
      startsAt: startsAt,
      endsAt: endsAt,
      timezone: timezone,
      rrule: rrule,
      reminderOffsetMinutes: reminderOffsetMinutes,
      colorKey: colorKey,
      category: category,
      scope: scope,
      anchorOccurrenceStart: anchorOccurrenceStart,
    );
  }

  Future<OperationResult> upsertOverride(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int eventId,
    required DateTime occurrenceKeyStart,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    int? overrideReminderOffsetMinutes,
    bool overrideReminderCleared = false,
    bool cancelled = false,
  }) {
    return service.upsertOverride(
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      eventId: eventId,
      occurrenceKeyStart: occurrenceKeyStart,
      overrideTitle: overrideTitle,
      overrideStartsAt: overrideStartsAt,
      overrideEndsAt: overrideEndsAt,
      overrideReminderOffsetMinutes: overrideReminderOffsetMinutes,
      overrideReminderCleared: overrideReminderCleared,
      cancelled: cancelled,
    );
  }

  Future<OperationResult> deleteEvent(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int eventId,
    String scope = 'all',
    DateTime? anchorOccurrenceStart,
  }) {
    return service.deleteEvent(
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      eventId: eventId,
      scope: scope,
      anchorOccurrenceStart: anchorOccurrenceStart,
    );
  }

  Future<List<CalendarInstanceDto>> listInstances(
    Session session, {
    required int familyId,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    return service.listInstances(
      session,
      familyId: familyId,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
  }
}
