import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class CalendarRepository {
  const CalendarRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<CalendarEventDto> getEvent({
    required int familyId,
    required int eventId,
  }) {
    return _apiClient.client.calendar.getEvent(
      familyId: familyId,
      eventId: eventId,
    );
  }

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
    int? reminderOffsetMinutes,
    String? colorKey,
    String? category,
    String scope = 'all',
    DateTime? anchorOccurrenceStart,
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
      reminderOffsetMinutes: reminderOffsetMinutes,
      colorKey: colorKey,
      category: category,
      scope: scope,
      anchorOccurrenceStart: anchorOccurrenceStart,
    );
  }

  Future<OperationResult> upsertOccurrence({
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
    return _apiClient.client.calendar.upsertOverride(
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

  Future<OperationResult> deleteEvent({
    required String clientOperationId,
    required int familyId,
    required int eventId,
    required String scope,
    DateTime? anchorOccurrenceStart,
  }) {
    return _apiClient.client.calendar.deleteEvent(
      clientOperationId: clientOperationId,
      familyId: familyId,
      eventId: eventId,
      scope: scope,
      anchorOccurrenceStart: anchorOccurrenceStart,
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
}
