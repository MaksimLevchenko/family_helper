import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class CalendarRepository {
  const CalendarRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<CalendarEventDto> upsertEvent({
    required String clientOperationId,
    int? eventId,
    required int familyId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String timezone,
    String? description,
    String? rrule,
    String? colorKey,
    String? category,
  }) {
    return _apiClient.client.calendar.upsertEvent(
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

  Future<List<CalendarInstanceDto>> listInstances({
    required int familyId,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    return _apiClient.client.calendar.listInstances(
      familyId: familyId,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
  }

  Future<OperationResult> cancelOccurrence({
    required String clientOperationId,
    required int familyId,
    required int eventId,
    required DateTime occurrenceStart,
  }) {
    return _apiClient.client.calendar.upsertOverride(
      clientOperationId: clientOperationId,
      familyId: familyId,
      eventId: eventId,
      occurrenceStart: occurrenceStart,
      scope: 'one',
      cancelled: true,
    );
  }
}
