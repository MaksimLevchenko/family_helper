import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/calendar_service.dart';

class CalendarEndpoint extends Endpoint {
  CalendarEndpoint({CalendarService? service}) : service = service ?? CalendarService();

  final CalendarService service;

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
    String? colorKey,
    String? category,
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
      colorKey: colorKey,
      category: category,
    );
  }

  Future<OperationResult> upsertOverride(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int eventId,
    required DateTime occurrenceStart,
    required String scope,
    String? overrideTitle,
    DateTime? overrideStartsAt,
    DateTime? overrideEndsAt,
    bool cancelled = false,
  }) {
    return service.upsertOverride(
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      eventId: eventId,
      occurrenceStart: occurrenceStart,
      scope: scope,
      overrideTitle: overrideTitle,
      overrideStartsAt: overrideStartsAt,
      overrideEndsAt: overrideEndsAt,
      cancelled: cancelled,
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
