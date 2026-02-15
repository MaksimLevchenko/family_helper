import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class CalendarService {
  CalendarService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;

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
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'calendar.upsertEvent',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh && eventId != null) {
        return _findEvent(session, eventId, transaction: transaction);
      }

      final now = DateTime.now().toUtc();
      if (eventId == null) {
        final inserted = await session.db.unsafeQuery(
          '''
          INSERT INTO calendar_event (
            family_id,
            title,
            description,
            timezone,
            starts_at,
            ends_at,
            rrule,
            color_key,
            category,
            created_by_profile_id,
            created_at,
            updated_at,
            deleted_at,
            version
          ) VALUES (
            @familyId,
            @title,
            @description,
            @timezone,
            @startsAt,
            @endsAt,
            @rrule,
            @colorKey,
            @category,
            @createdBy,
            @now,
            @now,
            NULL,
            1
          )
          RETURNING
            id,
            family_id,
            title,
            description,
            timezone,
            starts_at,
            ends_at,
            rrule,
            color_key,
            category,
            created_by_profile_id,
            updated_at,
            version
          ''',
          parameters: QueryParameters.named({
            'familyId': familyId,
            'title': title,
            'description': description,
            'timezone': timezone,
            'startsAt': startsAt.toUtc(),
            'endsAt': endsAt.toUtc(),
            'rrule': rrule,
            'colorKey': colorKey,
            'category': category,
            'createdBy': profileId,
            'now': now,
          }),
          transaction: transaction,
        );
        final dto = _mapEvent(inserted.first.toColumnMap());

        await changeFeed.appendChange(
          session,
          feature: 'calendar',
          entityType: 'event',
          entityId: dto.id,
          operation: 'upserted',
          familyId: familyId,
          version: dto.version,
          payload: {'title': dto.title},
          transaction: transaction,
        );

        await realtime.publish(
          session,
          familyId: familyId,
          event: FamilyRealtimeEvent(
            familyId: familyId,
            feature: 'calendar',
            entityType: 'event',
            entityId: dto.id,
            eventType: 'calendar.updated',
            changedAt: now,
          ),
        );

        return dto;
      }

      await session.db.unsafeExecute(
        '''
        UPDATE calendar_event
        SET
          title = @title,
          description = @description,
          timezone = @timezone,
          starts_at = @startsAt,
          ends_at = @endsAt,
          rrule = @rrule,
          color_key = @colorKey,
          category = @category,
          updated_at = @updatedAt,
          version = version + 1
        WHERE id = @id
          AND family_id = @familyId
          AND deleted_at IS NULL
        ''',
        parameters: QueryParameters.named({
          'id': eventId,
          'familyId': familyId,
          'title': title,
          'description': description,
          'timezone': timezone,
          'startsAt': startsAt.toUtc(),
          'endsAt': endsAt.toUtc(),
          'rrule': rrule,
          'colorKey': colorKey,
          'category': category,
          'updatedAt': now,
        }),
        transaction: transaction,
      );

      final updated = await _findEvent(session, eventId, transaction: transaction);

      await changeFeed.appendChange(
        session,
        feature: 'calendar',
        entityType: 'event',
        entityId: updated.id,
        operation: 'upserted',
        familyId: familyId,
        version: updated.version,
        payload: {'title': updated.title},
        transaction: transaction,
      );

      await realtime.publish(
        session,
        familyId: familyId,
        event: FamilyRealtimeEvent(
          familyId: familyId,
          feature: 'calendar',
          entityType: 'event',
          entityId: updated.id,
          eventType: 'calendar.updated',
          changedAt: now,
        ),
      );

      return updated;
    });
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
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'calendar.upsertOverride',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        return OperationResult(success: true, message: 'Already processed');
      }

      final now = DateTime.now().toUtc();
      if (scope == 'one') {
        await session.db.unsafeExecute(
          '''
          INSERT INTO calendar_event_override (
            event_id,
            occurrence_start,
            override_title,
            override_starts_at,
            override_ends_at,
            cancelled,
            created_at,
            updated_at,
            deleted_at,
            version
          ) VALUES (
            @eventId,
            @occurrenceStart,
            @overrideTitle,
            @overrideStartsAt,
            @overrideEndsAt,
            @cancelled,
            @now,
            @now,
            NULL,
            1
          )
          ON CONFLICT (event_id, occurrence_start)
          DO UPDATE SET
            override_title = EXCLUDED.override_title,
            override_starts_at = EXCLUDED.override_starts_at,
            override_ends_at = EXCLUDED.override_ends_at,
            cancelled = EXCLUDED.cancelled,
            updated_at = EXCLUDED.updated_at,
            version = calendar_event_override.version + 1,
            deleted_at = NULL
          ''',
          parameters: QueryParameters.named({
            'eventId': eventId,
            'occurrenceStart': occurrenceStart.toUtc(),
            'overrideTitle': overrideTitle,
            'overrideStartsAt': overrideStartsAt?.toUtc(),
            'overrideEndsAt': overrideEndsAt?.toUtc(),
            'cancelled': cancelled,
            'now': now,
          }),
          transaction: transaction,
        );
      } else {
        await session.db.unsafeExecute(
          '''
          UPDATE calendar_event
          SET
            title = COALESCE(@title, title),
            starts_at = COALESCE(@startsAt, starts_at),
            ends_at = COALESCE(@endsAt, ends_at),
            updated_at = @now,
            version = version + 1
          WHERE id = @eventId
            AND family_id = @familyId
            AND deleted_at IS NULL
          ''',
          parameters: QueryParameters.named({
            'eventId': eventId,
            'familyId': familyId,
            'title': overrideTitle,
            'startsAt': overrideStartsAt?.toUtc(),
            'endsAt': overrideEndsAt?.toUtc(),
            'now': now,
          }),
          transaction: transaction,
        );

        if (scope == 'future') {
          await session.db.unsafeExecute(
            '''
            UPDATE calendar_event_override
            SET deleted_at = @now, updated_at = @now, version = version + 1
            WHERE event_id = @eventId
              AND occurrence_start >= @occurrenceStart
              AND deleted_at IS NULL
            ''',
            parameters: QueryParameters.named({
              'eventId': eventId,
              'occurrenceStart': occurrenceStart.toUtc(),
              'now': now,
            }),
            transaction: transaction,
          );
        }
      }

      await changeFeed.appendChange(
        session,
        feature: 'calendar',
        entityType: 'event',
        entityId: eventId,
        operation: 'override_upserted',
        familyId: familyId,
        version: 1,
        payload: {'scope': scope},
        transaction: transaction,
      );

      await realtime.publish(
        session,
        familyId: familyId,
        event: FamilyRealtimeEvent(
          familyId: familyId,
          feature: 'calendar',
          entityType: 'event',
          entityId: eventId,
          eventType: 'calendar.updated',
          changedAt: now,
        ),
      );

      return OperationResult(success: true, message: 'Override updated');
    });
  }

  Future<List<CalendarInstanceDto>> listInstances(
    Session session, {
    required int familyId,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) async {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');

    final eventsResult = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        title,
        description,
        timezone,
        starts_at,
        ends_at,
        rrule,
        color_key,
        category,
        created_by_profile_id,
        updated_at,
        version
      FROM calendar_event
      WHERE family_id = @familyId
        AND deleted_at IS NULL
      ORDER BY id ASC
      ''',
      parameters: QueryParameters.named({'familyId': familyId}),
    );

    final overridesResult = await session.db.unsafeQuery(
      '''
      SELECT
        event_id,
        occurrence_start,
        override_title,
        override_starts_at,
        override_ends_at,
        cancelled
      FROM calendar_event_override
      WHERE deleted_at IS NULL
      ''',
    );

    final overrides = <String, Map<String, dynamic>>{};
    for (final row in overridesResult) {
      final map = row.toColumnMap();
      final key = '${map['event_id']}:${(map['occurrence_start'] as DateTime).toUtc().toIso8601String()}';
      overrides[key] = map;
    }

    final instances = <CalendarInstanceDto>[];
    for (final row in eventsResult) {
      final event = _mapEvent(row.toColumnMap());
      final occurrences = _expandOccurrences(event, rangeStart.toUtc(), rangeEnd.toUtc());

      for (final occurrence in occurrences) {
        final occurrenceKey = '${event.id}:${occurrence.start.toUtc().toIso8601String()}';
        final override = overrides[occurrenceKey];

        if (override == null) {
          instances.add(
            CalendarInstanceDto(
              eventId: event.id,
              occurrenceStart: occurrence.start,
              occurrenceEnd: occurrence.end,
              title: event.title,
              cancelled: false,
            ),
          );
          continue;
        }

        final cancelled = (override['cancelled'] as bool?) ?? false;
        instances.add(
          CalendarInstanceDto(
            eventId: event.id,
            occurrenceStart:
                (override['override_starts_at'] as DateTime?) ?? occurrence.start,
            occurrenceEnd:
                (override['override_ends_at'] as DateTime?) ?? occurrence.end,
            title: (override['override_title'] as String?) ?? event.title,
            cancelled: cancelled,
          ),
        );
      }
    }

    instances.sort((a, b) => a.occurrenceStart.compareTo(b.occurrenceStart));
    return instances;
  }

  Future<CalendarEventDto> _findEvent(
    Session session,
    int eventId, {
    Transaction? transaction,
  }) async {
    final result = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        title,
        description,
        timezone,
        starts_at,
        ends_at,
        rrule,
        color_key,
        category,
        created_by_profile_id,
        updated_at,
        version
      FROM calendar_event
      WHERE id = @id
      LIMIT 1
      ''',
      parameters: QueryParameters.named({'id': eventId}),
      transaction: transaction,
    );

    return _mapEvent(result.first.toColumnMap());
  }

  CalendarEventDto _mapEvent(Map<String, dynamic> row) {
    return CalendarEventDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int,
      title: row['title'] as String,
      description: row['description'] as String?,
      timezone: row['timezone'] as String,
      startsAt: row['starts_at'] as DateTime,
      endsAt: row['ends_at'] as DateTime,
      rrule: row['rrule'] as String?,
      colorKey: row['color_key'] as String?,
      category: row['category'] as String?,
      createdByProfileId: row['created_by_profile_id'] as int,
      updatedAt: row['updated_at'] as DateTime,
      version: row['version'] as int,
    );
  }

  List<_Occurrence> _expandOccurrences(
    CalendarEventDto event,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final duration = event.endsAt.difference(event.startsAt);
    final occurrences = <_Occurrence>[];

    if (event.rrule == null || event.rrule!.trim().isEmpty) {
      if (_intersects(event.startsAt, event.endsAt, rangeStart, rangeEnd)) {
        occurrences.add(_Occurrence(start: event.startsAt, end: event.endsAt));
      }
      return occurrences;
    }

    final rule = _parseRrule(event.rrule!);
    DateTime cursor = event.startsAt;
    int emitted = 0;
    final maxIterations = 4096;

    for (int i = 0; i < maxIterations; i++) {
      if (rule.until != null && cursor.isAfter(rule.until!)) {
        break;
      }
      if (rule.count != null && emitted >= rule.count!) {
        break;
      }

      final end = cursor.add(duration);
      if (_intersects(cursor, end, rangeStart, rangeEnd)) {
        occurrences.add(_Occurrence(start: cursor, end: end));
      }

      if (cursor.isAfter(rangeEnd) && (rule.until == null || cursor.isAfter(rule.until!))) {
        break;
      }

      emitted += 1;
      cursor = _next(cursor, rule.freq, rule.interval);
      if (cursor.isAfter(rangeEnd.add(const Duration(days: 3700)))) {
        break;
      }
    }

    return occurrences;
  }

  bool _intersects(DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
    return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
  }

  _Rrule _parseRrule(String rrule) {
    final parts = rrule.split(';');
    String freq = 'DAILY';
    int interval = 1;
    DateTime? until;
    int? count;

    for (final part in parts) {
      final kv = part.split('=');
      if (kv.length != 2) {
        continue;
      }
      final key = kv[0].trim().toUpperCase();
      final value = kv[1].trim();

      switch (key) {
        case 'FREQ':
          freq = value.toUpperCase();
          break;
        case 'INTERVAL':
          interval = int.tryParse(value) ?? 1;
          break;
        case 'COUNT':
          count = int.tryParse(value);
          break;
        case 'UNTIL':
          until = _parseUntil(value);
          break;
      }
    }

    return _Rrule(freq: freq, interval: interval, until: until, count: count);
  }

  DateTime _next(DateTime value, String freq, int interval) {
    switch (freq) {
      case 'WEEKLY':
        return value.add(Duration(days: 7 * interval));
      case 'MONTHLY':
        return DateTime.utc(
          value.year,
          value.month + interval,
          value.day,
          value.hour,
          value.minute,
          value.second,
        );
      case 'YEARLY':
        return DateTime.utc(
          value.year + interval,
          value.month,
          value.day,
          value.hour,
          value.minute,
          value.second,
        );
      case 'DAILY':
      default:
        return value.add(Duration(days: interval));
    }
  }

  DateTime? _parseUntil(String raw) {
    try {
      if (raw.contains('-')) {
        return DateTime.parse(raw).toUtc();
      }
      if (raw.length == 8) {
        final year = int.parse(raw.substring(0, 4));
        final month = int.parse(raw.substring(4, 6));
        final day = int.parse(raw.substring(6, 8));
        return DateTime.utc(year, month, day, 23, 59, 59);
      }
      if (raw.length >= 15 && raw.contains('T')) {
        final year = int.parse(raw.substring(0, 4));
        final month = int.parse(raw.substring(4, 6));
        final day = int.parse(raw.substring(6, 8));
        final hour = int.parse(raw.substring(9, 11));
        final minute = int.parse(raw.substring(11, 13));
        final second = int.parse(raw.substring(13, 15));
        return DateTime.utc(year, month, day, hour, minute, second);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

class _Occurrence {
  _Occurrence({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class _Rrule {
  _Rrule({
    required this.freq,
    required this.interval,
    required this.until,
    required this.count,
  });

  final String freq;
  final int interval;
  final DateTime? until;
  final int? count;
}
