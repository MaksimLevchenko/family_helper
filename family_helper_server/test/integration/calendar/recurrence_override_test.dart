import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Calendar recurrence and overrides', (sessionBuilder, endpoints) {
    test('listInstances applies one-occurrence cancellation override', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-calendar-001',
        title: 'Calendar Family',
      );

      final event = await endpoints.calendar.upsertEvent(
        owner,
        clientOperationId: 'calendar-event-create-001',
        familyId: family.id,
        title: 'Dinner',
        startsAt: DateTime.utc(2026, 2, 10, 19, 0),
        endsAt: DateTime.utc(2026, 2, 10, 20, 0),
        timezone: 'UTC',
        rrule: 'FREQ=DAILY;INTERVAL=1',
      );

      final beforeOverride = await endpoints.calendar.listInstances(
        owner,
        familyId: family.id,
        rangeStart: DateTime.utc(2026, 2, 10),
        rangeEnd: DateTime.utc(2026, 2, 13, 23, 59),
      );

      expect(beforeOverride.length, greaterThanOrEqualTo(3));

      await endpoints.calendar.upsertOverride(
        owner,
        clientOperationId: 'calendar-override-001',
        familyId: family.id,
        eventId: event.id,
        occurrenceStart: DateTime.utc(2026, 2, 11, 19, 0),
        scope: 'one',
        cancelled: true,
      );

      final afterOverride = await endpoints.calendar.listInstances(
        owner,
        familyId: family.id,
        rangeStart: DateTime.utc(2026, 2, 10),
        rangeEnd: DateTime.utc(2026, 2, 13, 23, 59),
      );

      final cancelledOccurrence = afterOverride.where(
        (it) =>
            it.eventId == event.id &&
            it.occurrenceStart == DateTime.utc(2026, 2, 11, 19, 0),
      );

      expect(cancelledOccurrence.isNotEmpty, isTrue);
      expect(cancelledOccurrence.first.cancelled, isTrue);
    });
  });
}
