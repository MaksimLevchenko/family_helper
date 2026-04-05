import 'dart:convert';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';
import '../../notifications/services/app_notification_service.dart';
import '../../notifications/services/notification_message_builder.dart';

class CalendarService {
  CalendarService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
    AppNotificationService? appNotifications,
  }) : appNotifications = appNotifications ?? AppNotificationService();

  static const _calendarReminderEntityType = 'calendar';
  static const _reminderSyncHorizon = Duration(days: 30);
  static const _maxIterations = 4096;

  final AuthContext authContext;
  final ClockService clock;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;
  final AppNotificationService appNotifications;

  Future<CalendarEventDto> getEvent(
    Session session, {
    required int familyId,
    required int eventId,
  }) async {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');
    final row = await _findEventRow(session, familyId, eventId);
    return _mapEvent(row);
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
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;
    _validateEventInput(
      title: title,
      startsAt: startsAt,
      endsAt: endsAt,
      reminderOffsetMinutes: reminderOffsetMinutes,
    );
    _validateScope(scope, allowOne: false);

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
        final existing = await _findEventRow(
          session,
          familyId,
          eventId,
          transaction: transaction,
        );
        return _mapEvent(existing);
      }
      if (!isFresh) {
        final binding = await idempotency.getBinding(
          session,
          actorAuthUserId: authUserId,
          action: 'calendar.upsertEvent',
          clientOperationId: clientOperationId,
          transaction: transaction,
        );
        if (binding?.resourceType == 'calendar_event') {
          final existing = await _findEventRow(
            session,
            familyId,
            binding!.resourceId,
            transaction: transaction,
          );
          return _mapEvent(existing);
        }
      }

      final normalizedRrule = _normalizeRrule(rrule);
      final now = clock.nowUtc();
      late final CalendarEventDto dto;

      if (eventId == null) {
        final inserted = await CalendarEventRow.db.insertRow(
          session,
          CalendarEventRow(
            familyId: familyId,
            title: title.trim(),
            description: description?.trim(),
            timezone: timezone,
            startsAt: startsAt.toUtc(),
            endsAt: endsAt.toUtc(),
            rrule: normalizedRrule,
            reminderOffsetMinutes: reminderOffsetMinutes,
            colorKey: colorKey,
            category: category,
            createdByProfileId: profileId,
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
            version: 1,
          ),
          transaction: transaction,
        );
        dto = _mapEvent(inserted);
        await idempotency.bindResource(
          session,
          actorAuthUserId: authUserId,
          action: 'calendar.upsertEvent',
          clientOperationId: clientOperationId,
          resourceType: 'calendar_event',
          resourceId: dto.id,
          transaction: transaction,
        );
      } else {
        final existing = await _findEventRow(
          session,
          familyId,
          eventId,
          transaction: transaction,
        );
        if (scope == 'future' &&
            _isRecurringRrule(existing.rrule) &&
            anchorOccurrenceStart != null &&
            anchorOccurrenceStart.toUtc().isAfter(existing.startsAt)) {
          dto = await _splitAndUpsertFuture(
            session,
            original: existing,
            profileId: profileId,
            title: title.trim(),
            description: description?.trim(),
            startsAt: startsAt.toUtc(),
            endsAt: endsAt.toUtc(),
            timezone: timezone,
            rrule: normalizedRrule,
            reminderOffsetMinutes: reminderOffsetMinutes,
            colorKey: colorKey,
            category: category,
            anchorOccurrenceStart: anchorOccurrenceStart.toUtc(),
            now: now,
            transaction: transaction,
          );
        } else {
          final updated = await CalendarEventRow.db.updateRow(
            session,
            existing.copyWith(
              title: title.trim(),
              description: description?.trim(),
              timezone: timezone,
              startsAt: startsAt.toUtc(),
              endsAt: endsAt.toUtc(),
              rrule: normalizedRrule,
              reminderOffsetMinutes: reminderOffsetMinutes,
              colorKey: colorKey,
              category: category,
              updatedAt: now,
              version: existing.version + 1,
            ),
            transaction: transaction,
          );
          dto = _mapEvent(updated);
        }
      }

      await _syncScheduledRemindersForProfile(
        session,
        familyId: familyId,
        profileId: profileId,
        transaction: transaction,
      );

      await changeFeed.appendChange(
        session,
        feature: 'calendar',
        entityType: 'event',
        entityId: dto.id,
        operation: 'upserted',
        familyId: familyId,
        version: dto.version,
        payload: {'title': dto.title, 'scope': scope},
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

      await _notifyCalendarEvent(
        session,
        actorProfileId: profileId,
        familyId: familyId,
        eventId: dto.id,
        title: dto.title,
        category: eventId == null ? 'calendar_created' : 'calendar_updated',
        occurrenceStart: dto.startsAt,
        transaction: transaction,
      );

      return dto;
    });
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
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;
    if (overrideReminderOffsetMinutes != null &&
        overrideReminderOffsetMinutes < 0) {
      throw ArgumentError.value(
        overrideReminderOffsetMinutes,
        'overrideReminderOffsetMinutes',
        'Reminder offset must be zero or greater.',
      );
    }

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
        action: 'calendar.upsertOverride',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        return OperationResult(success: true, message: 'Already processed');
      }

      final now = clock.nowUtc();
      final event = await _findEventRow(
        session,
        familyId,
        eventId,
        transaction: transaction,
      );
      final duration = event.endsAt.difference(event.startsAt);
      final keyStart = occurrenceKeyStart.toUtc();
      final effectiveStartsAt = overrideStartsAt?.toUtc() ?? keyStart;
      final effectiveEndsAt =
          overrideEndsAt?.toUtc() ?? effectiveStartsAt.add(duration);
      if (!effectiveEndsAt.isAfter(effectiveStartsAt)) {
        throw ArgumentError.value(
          overrideEndsAt,
          'overrideEndsAt',
          'Occurrence end must be after its start.',
        );
      }

      final existing = await CalendarEventOverrideRow.db.findFirstRow(
        session,
        where: (t) =>
            t.eventId.equals(eventId) &
            t.occurrenceStart.equals(keyStart) &
            t.deletedAt.equals(null),
        transaction: transaction,
      );

      if (existing == null) {
        await CalendarEventOverrideRow.db.insertRow(
          session,
          CalendarEventOverrideRow(
            eventId: eventId,
            occurrenceStart: keyStart,
            overrideTitle: overrideTitle?.trim(),
            overrideStartsAt: effectiveStartsAt,
            overrideEndsAt: effectiveEndsAt,
            overrideReminderOffsetMinutes: overrideReminderOffsetMinutes,
            overrideReminderCleared: overrideReminderCleared,
            cancelled: cancelled,
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
            version: 1,
          ),
          transaction: transaction,
        );
      } else {
        await CalendarEventOverrideRow.db.updateRow(
          session,
          existing.copyWith(
            overrideTitle: overrideTitle?.trim(),
            overrideStartsAt:
                overrideStartsAt?.toUtc() ??
                existing.overrideStartsAt ??
                keyStart,
            overrideEndsAt:
                overrideEndsAt?.toUtc() ??
                existing.overrideEndsAt ??
                effectiveStartsAt.add(duration),
            overrideReminderOffsetMinutes: overrideReminderOffsetMinutes,
            overrideReminderCleared: overrideReminderCleared,
            cancelled: cancelled,
            updatedAt: now,
            deletedAt: null,
            version: existing.version + 1,
          ),
          transaction: transaction,
        );
      }

      await _syncScheduledRemindersForProfile(
        session,
        familyId: familyId,
        profileId: profileId,
        transaction: transaction,
      );

      await changeFeed.appendChange(
        session,
        feature: 'calendar',
        entityType: 'event',
        entityId: eventId,
        operation: 'override_upserted',
        familyId: familyId,
        version: event.version,
        payload: {'scope': 'one'},
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

      await _notifyCalendarEvent(
        session,
        actorProfileId: profileId,
        familyId: familyId,
        eventId: eventId,
        title: event.title,
        category: cancelled ? 'calendar_cancelled' : 'calendar_updated',
        occurrenceStart: keyStart,
        transaction: transaction,
      );

      return OperationResult(success: true, message: 'Occurrence updated');
    });
  }

  Future<OperationResult> deleteEvent(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int eventId,
    String scope = 'all',
    DateTime? anchorOccurrenceStart,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;
    _validateScope(scope, allowOne: false);

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
        action: 'calendar.deleteEvent',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        return OperationResult(success: true, message: 'Already processed');
      }

      final event = await _findEventRow(
        session,
        familyId,
        eventId,
        transaction: transaction,
      );
      final now = clock.nowUtc();
      final anchor = anchorOccurrenceStart?.toUtc();

      if (scope == 'future' &&
          anchor != null &&
          _isRecurringRrule(event.rrule) &&
          anchor.isAfter(event.startsAt) &&
          _hasOccurrenceBefore(_mapEvent(event), anchor)) {
        await CalendarEventRow.db.updateRow(
          session,
          event.copyWith(
            rrule: _withUntil(
              event.rrule!,
              anchor.subtract(const Duration(seconds: 1)),
            ),
            updatedAt: now,
            version: event.version + 1,
          ),
          transaction: transaction,
        );
        await _softDeleteOverrides(
          session,
          eventId: eventId,
          fromOccurrenceStart: anchor,
          now: now,
          transaction: transaction,
        );
      } else {
        await CalendarEventRow.db.updateRow(
          session,
          event.copyWith(
            deletedAt: now,
            updatedAt: now,
            version: event.version + 1,
          ),
          transaction: transaction,
        );
        await _softDeleteOverrides(
          session,
          eventId: eventId,
          fromOccurrenceStart: null,
          now: now,
          transaction: transaction,
        );
      }

      await _syncScheduledRemindersForProfile(
        session,
        familyId: familyId,
        profileId: profileId,
        transaction: transaction,
      );

      await changeFeed.appendChange(
        session,
        feature: 'calendar',
        entityType: 'event',
        entityId: eventId,
        operation: 'deleted',
        familyId: familyId,
        version: event.version + 1,
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

      await _notifyCalendarEvent(
        session,
        actorProfileId: profileId,
        familyId: familyId,
        eventId: eventId,
        title: event.title,
        category: 'calendar_cancelled',
        occurrenceStart: anchor ?? event.startsAt,
        transaction: transaction,
      );

      return OperationResult(success: true, message: 'Event deleted');
    });
  }

  Future<List<CalendarInstanceDto>> listInstances(
    Session session, {
    required int familyId,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) async {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');
    final profileId = await authContext.ensureProfileId(session);
    final events = await _loadActiveEvents(session, familyId: familyId);
    final overridesByEvent = await _loadActiveOverrides(
      session,
      eventIds: events.map((event) => event.id!).toList(),
    );
    final instances = _buildInstances(
      events: events.map(_mapEvent).toList(),
      overridesByEvent: overridesByEvent,
      rangeStart: rangeStart.toUtc(),
      rangeEnd: rangeEnd.toUtc(),
      includeCancelled: false,
    );

    await _syncScheduledRemindersForProfile(
      session,
      familyId: familyId,
      profileId: profileId,
      events: events,
      overridesByEvent: overridesByEvent,
    );

    instances.sort((a, b) {
      final byStart = a.occurrenceStart.compareTo(b.occurrenceStart);
      if (byStart != 0) {
        return byStart;
      }
      return a.title.compareTo(b.title);
    });
    return instances;
  }

  Future<CalendarEventDto> _splitAndUpsertFuture(
    Session session, {
    required CalendarEventRow original,
    required int profileId,
    required String title,
    required String? description,
    required DateTime startsAt,
    required DateTime endsAt,
    required String timezone,
    required String? rrule,
    required int? reminderOffsetMinutes,
    required String? colorKey,
    required String? category,
    required DateTime anchorOccurrenceStart,
    required DateTime now,
    required Transaction transaction,
  }) async {
    final originalEvent = _mapEvent(original);
    if (!_hasOccurrenceBefore(originalEvent, anchorOccurrenceStart)) {
      final updated = await CalendarEventRow.db.updateRow(
        session,
        original.copyWith(
          title: title,
          description: description,
          timezone: timezone,
          startsAt: startsAt,
          endsAt: endsAt,
          rrule: rrule,
          reminderOffsetMinutes: reminderOffsetMinutes,
          colorKey: colorKey,
          category: category,
          updatedAt: now,
          version: original.version + 1,
        ),
        transaction: transaction,
      );
      return _mapEvent(updated);
    }

    await CalendarEventRow.db.updateRow(
      session,
      original.copyWith(
        rrule: _withUntil(
          original.rrule!,
          anchorOccurrenceStart.subtract(const Duration(seconds: 1)),
        ),
        updatedAt: now,
        version: original.version + 1,
      ),
      transaction: transaction,
    );

    final successor = await CalendarEventRow.db.insertRow(
      session,
      CalendarEventRow(
        familyId: original.familyId,
        title: title,
        description: description,
        timezone: timezone,
        startsAt: startsAt,
        endsAt: endsAt,
        rrule: rrule,
        reminderOffsetMinutes: reminderOffsetMinutes,
        colorKey: colorKey,
        category: category,
        createdByProfileId: profileId,
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
        version: 1,
      ),
      transaction: transaction,
    );

    final futureOverrides = await CalendarEventOverrideRow.db.find(
      session,
      where: (t) =>
          t.eventId.equals(original.id) &
          (t.occurrenceStart >= anchorOccurrenceStart) &
          t.deletedAt.equals(null),
      transaction: transaction,
    );
    for (final override in futureOverrides) {
      await CalendarEventOverrideRow.db.updateRow(
        session,
        override.copyWith(
          eventId: successor.id!,
          updatedAt: now,
          version: override.version + 1,
        ),
        transaction: transaction,
      );
    }

    return _mapEvent(successor);
  }

  Future<List<CalendarEventRow>> _loadActiveEvents(
    Session session, {
    required int familyId,
    Transaction? transaction,
  }) {
    return CalendarEventRow.db.find(
      session,
      where: (t) => t.familyId.equals(familyId) & t.deletedAt.equals(null),
      orderBy: (t) => t.startsAt,
      transaction: transaction,
    );
  }

  Future<Map<int, List<CalendarEventOverrideRow>>> _loadActiveOverrides(
    Session session, {
    required List<int> eventIds,
    Transaction? transaction,
  }) async {
    if (eventIds.isEmpty) {
      return <int, List<CalendarEventOverrideRow>>{};
    }

    final overrides = await CalendarEventOverrideRow.db.find(
      session,
      where: (t) =>
          t.eventId.inSet(eventIds.toSet()) & t.deletedAt.equals(null),
      transaction: transaction,
    );
    final byEvent = <int, List<CalendarEventOverrideRow>>{};
    for (final row in overrides) {
      byEvent
          .putIfAbsent(row.eventId, () => <CalendarEventOverrideRow>[])
          .add(row);
    }
    return byEvent;
  }

  Future<CalendarEventRow> _findEventRow(
    Session session,
    int familyId,
    int eventId, {
    Transaction? transaction,
  }) async {
    final row = await CalendarEventRow.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(eventId) &
          t.familyId.equals(familyId) &
          t.deletedAt.equals(null),
      transaction: transaction,
    );
    if (row == null) {
      throw FileNotFoundException(message: 'Event not found.');
    }
    return row;
  }

  Future<void> _softDeleteOverrides(
    Session session, {
    required int eventId,
    required DateTime? fromOccurrenceStart,
    required DateTime now,
    required Transaction transaction,
  }) async {
    final overrides = await CalendarEventOverrideRow.db.find(
      session,
      where: (t) {
        var predicate = t.eventId.equals(eventId) & t.deletedAt.equals(null);
        if (fromOccurrenceStart != null) {
          predicate = predicate & (t.occurrenceStart >= fromOccurrenceStart);
        }
        return predicate;
      },
      transaction: transaction,
    );
    for (final override in overrides) {
      await CalendarEventOverrideRow.db.updateRow(
        session,
        override.copyWith(
          deletedAt: now,
          updatedAt: now,
          version: override.version + 1,
        ),
        transaction: transaction,
      );
    }
  }

  Future<void> _syncScheduledRemindersForProfile(
    Session session, {
    required int familyId,
    required int profileId,
    List<CalendarEventRow>? events,
    Map<int, List<CalendarEventOverrideRow>>? overridesByEvent,
    Transaction? transaction,
  }) async {
    final now = clock.nowUtc();
    final horizonEnd = now.add(_reminderSyncHorizon);
    final effectiveEvents =
        events ??
        await _loadActiveEvents(
          session,
          familyId: familyId,
          transaction: transaction,
        );
    final effectiveOverrides =
        overridesByEvent ??
        await _loadActiveOverrides(
          session,
          eventIds: effectiveEvents.map((event) => event.id!).toList(),
          transaction: transaction,
        );
    final desiredInstances = _buildInstances(
      events: effectiveEvents.map(_mapEvent).toList(),
      overridesByEvent: effectiveOverrides,
      rangeStart: now,
      rangeEnd: horizonEnd,
      includeCancelled: false,
    );

    final desiredReminders = <String, _MaterializedReminder>{};
    for (final instance in desiredInstances) {
      if (instance.reminderOffsetMinutes == null) {
        continue;
      }
      final remindAt = instance.occurrenceStart.subtract(
        Duration(minutes: instance.reminderOffsetMinutes!),
      );
      if (!remindAt.isAfter(now)) {
        continue;
      }
      final key = _calendarReminderClientOperationId(
        profileId: profileId,
        eventId: instance.eventId,
        occurrenceKeyStart: instance.occurrenceKeyStart,
      );
      desiredReminders[key] = _MaterializedReminder(
        clientOperationId: key,
        remindAt: remindAt,
        payloadJson: jsonEncode(
          buildAppNotificationPayload(
            familyId: familyId,
            entityType: _calendarReminderEntityType,
            entityId: instance.eventId,
            route: '/home/calendar',
            payload: {
              'eventId': instance.eventId,
              'occurrenceKeyStart': instance.occurrenceKeyStart
                  .toIso8601String(),
              'occurrenceStart': instance.occurrenceStart.toIso8601String(),
            },
          ),
        ),
        eventId: instance.eventId,
      );
    }

    final existingRows = await ReminderRow.db.find(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          t.profileId.equals(profileId) &
          t.entityType.equals(_calendarReminderEntityType),
      transaction: transaction,
    );
    final existingByClientId = <String, ReminderRow>{};
    for (final row in existingRows) {
      final clientId = row.clientOperationId;
      if (clientId == null || clientId.isEmpty) {
        continue;
      }
      existingByClientId[clientId] = row;
    }

    for (final entry in desiredReminders.entries) {
      final existing = existingByClientId.remove(entry.key);
      if (existing == null) {
        await ReminderRow.db.insertRow(
          session,
          ReminderRow(
            familyId: familyId,
            entityType: _calendarReminderEntityType,
            entityId: entry.value.eventId,
            profileId: profileId,
            remindAt: entry.value.remindAt,
            status: 'scheduled',
            payloadJson: entry.value.payloadJson,
            clientOperationId: entry.value.clientOperationId,
            firedAt: null,
            createdAt: now,
          ),
          transaction: transaction,
        );
        continue;
      }

      if (existing.remindAt != entry.value.remindAt ||
          existing.status != 'scheduled' ||
          existing.payloadJson != entry.value.payloadJson) {
        await ReminderRow.db.updateRow(
          session,
          existing.copyWith(
            remindAt: entry.value.remindAt,
            status: 'scheduled',
            payloadJson: entry.value.payloadJson,
            firedAt: null,
          ),
          transaction: transaction,
        );
      }
    }

    for (final stale in existingByClientId.values) {
      if (stale.status == 'scheduled') {
        await ReminderRow.db.updateRow(
          session,
          stale.copyWith(status: 'cancelled'),
          transaction: transaction,
        );
      }
    }
  }

  List<CalendarInstanceDto> _buildInstances({
    required List<CalendarEventDto> events,
    required Map<int, List<CalendarEventOverrideRow>> overridesByEvent,
    required DateTime rangeStart,
    required DateTime rangeEnd,
    required bool includeCancelled,
  }) {
    final instances = <CalendarInstanceDto>[];

    for (final event in events) {
      final overrides =
          overridesByEvent[event.id] ?? const <CalendarEventOverrideRow>[];
      final overrideByKey = <String, CalendarEventOverrideRow>{
        for (final override in overrides)
          override.occurrenceStart.toUtc().toIso8601String(): override,
      };
      final generated = _expandOccurrences(event, rangeStart, rangeEnd);
      final generatedKeys = <String>{};

      for (final occurrence in generated) {
        final key = occurrence.keyStart.toUtc().toIso8601String();
        generatedKeys.add(key);
        final override = overrideByKey[key];
        final cancelled = override?.cancelled ?? false;
        if (cancelled && !includeCancelled) {
          continue;
        }
        instances.add(
          CalendarInstanceDto(
            eventId: event.id,
            occurrenceKeyStart: occurrence.keyStart,
            occurrenceStart: override?.overrideStartsAt ?? occurrence.start,
            occurrenceEnd: override?.overrideEndsAt ?? occurrence.end,
            title: override?.overrideTitle ?? event.title,
            cancelled: cancelled,
            isRecurring: _isRecurringRrule(event.rrule),
            isException: override != null,
            reminderOffsetMinutes: _effectiveReminderOffset(
              event: event,
              override: override,
            ),
          ),
        );
      }

      for (final override in overrides) {
        final key = override.occurrenceStart.toUtc().toIso8601String();
        if (generatedKeys.contains(key) || override.cancelled) {
          continue;
        }
        final pinnedStart =
            override.overrideStartsAt ?? override.occurrenceStart;
        final pinnedEnd =
            override.overrideEndsAt ??
            pinnedStart.add(event.endsAt.difference(event.startsAt));
        if (!_intersects(pinnedStart, pinnedEnd, rangeStart, rangeEnd)) {
          continue;
        }
        instances.add(
          CalendarInstanceDto(
            eventId: event.id,
            occurrenceKeyStart: override.occurrenceStart,
            occurrenceStart: pinnedStart,
            occurrenceEnd: pinnedEnd,
            title: override.overrideTitle ?? event.title,
            cancelled: false,
            isRecurring: _isRecurringRrule(event.rrule),
            isException: true,
            reminderOffsetMinutes: _effectiveReminderOffset(
              event: event,
              override: override,
            ),
          ),
        );
      }
    }

    return instances;
  }

  int? _effectiveReminderOffset({
    required CalendarEventDto event,
    CalendarEventOverrideRow? override,
  }) {
    if (override == null) {
      return event.reminderOffsetMinutes;
    }
    if (override.overrideReminderCleared == true) {
      return null;
    }
    return override.overrideReminderOffsetMinutes ??
        event.reminderOffsetMinutes;
  }

  CalendarEventDto _mapEvent(CalendarEventRow row) {
    return CalendarEventDto(
      id: row.id!,
      familyId: row.familyId,
      title: row.title,
      description: row.description,
      timezone: row.timezone,
      startsAt: row.startsAt,
      endsAt: row.endsAt,
      rrule: row.rrule,
      reminderOffsetMinutes: row.reminderOffsetMinutes,
      colorKey: row.colorKey,
      category: row.category,
      createdByProfileId: row.createdByProfileId,
      updatedAt: row.updatedAt,
      version: row.version,
    );
  }

  List<_Occurrence> _expandOccurrences(
    CalendarEventDto event,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final duration = event.endsAt.difference(event.startsAt);
    if (!_isRecurringRrule(event.rrule)) {
      if (_intersects(event.startsAt, event.endsAt, rangeStart, rangeEnd)) {
        return [
          _Occurrence(
            keyStart: event.startsAt,
            start: event.startsAt,
            end: event.endsAt,
          ),
        ];
      }
      return const <_Occurrence>[];
    }

    final rule = _parseRrule(event.rrule!);
    return switch (rule.freq) {
      'WEEKLY' => _expandWeekly(event, rule, duration, rangeStart, rangeEnd),
      'MONTHLY' => _expandMonthly(event, rule, duration, rangeStart, rangeEnd),
      'YEARLY' => _expandYearly(event, rule, duration, rangeStart, rangeEnd),
      _ => _expandDaily(event, rule, duration, rangeStart, rangeEnd),
    };
  }

  List<_Occurrence> _expandDaily(
    CalendarEventDto event,
    _Rrule rule,
    Duration duration,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <_Occurrence>[];
    var cursor = event.startsAt;
    var emitted = 0;

    for (var i = 0; i < _maxIterations; i++) {
      if (!_canEmit(cursor, rule, emitted)) {
        break;
      }
      final end = cursor.add(duration);
      if (_intersects(cursor, end, rangeStart, rangeEnd)) {
        occurrences.add(_Occurrence(keyStart: cursor, start: cursor, end: end));
      }
      if (cursor.isAfter(rangeEnd) &&
          (rule.until == null || cursor.isAfter(rule.until!))) {
        break;
      }
      emitted += 1;
      cursor = cursor.add(Duration(days: rule.interval));
    }

    return occurrences;
  }

  List<_Occurrence> _expandWeekly(
    CalendarEventDto event,
    _Rrule rule,
    Duration duration,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <_Occurrence>[];
    final weekdays = rule.byDays.isEmpty
        ? <int>[event.startsAt.weekday]
        : (rule.byDays.toList()..sort());
    final weekAnchor = _startOfWeek(event.startsAt);
    var emitted = 0;

    for (var weekIndex = 0; weekIndex < _maxIterations; weekIndex++) {
      final weekStart = weekAnchor.add(
        Duration(days: weekIndex * 7 * rule.interval),
      );
      for (final weekday in weekdays) {
        final candidate = DateTime.utc(
          weekStart.year,
          weekStart.month,
          weekStart.day + (weekday - 1),
          event.startsAt.hour,
          event.startsAt.minute,
          event.startsAt.second,
          event.startsAt.millisecond,
          event.startsAt.microsecond,
        );
        if (candidate.isBefore(event.startsAt)) {
          continue;
        }
        if (!_canEmit(candidate, rule, emitted)) {
          return occurrences;
        }
        final end = candidate.add(duration);
        if (_intersects(candidate, end, rangeStart, rangeEnd)) {
          occurrences.add(
            _Occurrence(keyStart: candidate, start: candidate, end: end),
          );
        }
        emitted += 1;
        if (candidate.isAfter(rangeEnd) &&
            (rule.until == null || candidate.isAfter(rule.until!))) {
          return occurrences;
        }
      }
    }

    return occurrences;
  }

  List<_Occurrence> _expandMonthly(
    CalendarEventDto event,
    _Rrule rule,
    Duration duration,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <_Occurrence>[];
    var emitted = 0;

    for (var step = 0; step < _maxIterations; step++) {
      final candidate = _createUtcIfValid(
        event.startsAt.year,
        event.startsAt.month + (step * rule.interval),
        event.startsAt.day,
        event.startsAt.hour,
        event.startsAt.minute,
        event.startsAt.second,
        event.startsAt.millisecond,
        event.startsAt.microsecond,
      );
      if (candidate == null) {
        continue;
      }
      if (!_canEmit(candidate, rule, emitted)) {
        break;
      }
      final end = candidate.add(duration);
      if (_intersects(candidate, end, rangeStart, rangeEnd)) {
        occurrences.add(
          _Occurrence(keyStart: candidate, start: candidate, end: end),
        );
      }
      emitted += 1;
      if (candidate.isAfter(rangeEnd) &&
          (rule.until == null || candidate.isAfter(rule.until!))) {
        break;
      }
    }

    return occurrences;
  }

  List<_Occurrence> _expandYearly(
    CalendarEventDto event,
    _Rrule rule,
    Duration duration,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <_Occurrence>[];
    var emitted = 0;

    for (var step = 0; step < _maxIterations; step++) {
      final candidate = _createUtcIfValid(
        event.startsAt.year + (step * rule.interval),
        event.startsAt.month,
        event.startsAt.day,
        event.startsAt.hour,
        event.startsAt.minute,
        event.startsAt.second,
        event.startsAt.millisecond,
        event.startsAt.microsecond,
      );
      if (candidate == null) {
        continue;
      }
      if (!_canEmit(candidate, rule, emitted)) {
        break;
      }
      final end = candidate.add(duration);
      if (_intersects(candidate, end, rangeStart, rangeEnd)) {
        occurrences.add(
          _Occurrence(keyStart: candidate, start: candidate, end: end),
        );
      }
      emitted += 1;
      if (candidate.isAfter(rangeEnd) &&
          (rule.until == null || candidate.isAfter(rule.until!))) {
        break;
      }
    }

    return occurrences;
  }

  bool _canEmit(DateTime candidate, _Rrule rule, int emitted) {
    if (rule.until != null && candidate.isAfter(rule.until!)) {
      return false;
    }
    if (rule.count != null && emitted >= rule.count!) {
      return false;
    }
    return true;
  }

  bool _intersects(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) {
    return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
  }

  bool _hasOccurrenceBefore(
    CalendarEventDto event,
    DateTime anchorOccurrenceStart,
  ) {
    final occurrences = _expandOccurrences(
      event,
      event.startsAt.subtract(const Duration(seconds: 1)),
      anchorOccurrenceStart,
    );
    return occurrences.any(
      (occurrence) => occurrence.keyStart.isBefore(anchorOccurrenceStart),
    );
  }

  _Rrule _parseRrule(String rrule) {
    final parts = rrule.split(';');
    var freq = 'DAILY';
    var interval = 1;
    DateTime? until;
    int? count;
    final byDays = <int>{};

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
        case 'BYDAY':
          byDays.addAll(
            value
                .split(',')
                .map((token) => _weekdayFromToken(token.trim().toUpperCase()))
                .whereType<int>(),
          );
          break;
      }
    }

    return _Rrule(
      freq: freq,
      interval: interval < 1 ? 1 : interval,
      until: until,
      count: count,
      byDays: byDays,
    );
  }

  String? _normalizeRrule(String? rrule) {
    final trimmed = rrule?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return _serializeRrule(_parseRrule(trimmed));
  }

  String _withUntil(String rrule, DateTime until) {
    final parsed = _parseRrule(rrule);
    return _serializeRrule(
      parsed.copyWith(until: until.toUtc(), count: null),
    );
  }

  String _serializeRrule(_Rrule rule) {
    final parts = <String>[
      'FREQ=${rule.freq}',
      'INTERVAL=${rule.interval}',
    ];
    if (rule.byDays.isNotEmpty) {
      final tokens = rule.byDays.toList()..sort();
      parts.add('BYDAY=${tokens.map(_weekdayToken).join(',')}');
    }
    if (rule.until != null) {
      parts.add('UNTIL=${_formatUntil(rule.until!)}');
    }
    if (rule.count != null) {
      parts.add('COUNT=${rule.count}');
    }
    return parts.join(';');
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

  String _formatUntil(DateTime until) {
    final value = until.toUtc();
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$year$month${day}T$hour$minute${second}Z';
  }

  DateTime _startOfWeek(DateTime value) {
    final dateOnly = DateTime.utc(value.year, value.month, value.day);
    return dateOnly.subtract(Duration(days: value.weekday - DateTime.monday));
  }

  DateTime? _createUtcIfValid(
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond,
  ) {
    final candidate = DateTime.utc(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
    if (candidate.year != year ||
        candidate.month != month ||
        candidate.day != day) {
      return null;
    }
    return candidate;
  }

  int? _weekdayFromToken(String token) {
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

  String _weekdayToken(int weekday) {
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
  }

  bool _isRecurringRrule(String? rrule) =>
      rrule != null && rrule.trim().isNotEmpty;

  void _validateEventInput({
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required int? reminderOffsetMinutes,
  }) {
    if (title.trim().isEmpty) {
      throw ArgumentError.value(title, 'title', 'Title is required.');
    }
    if (!endsAt.isAfter(startsAt)) {
      throw ArgumentError.value(
        endsAt,
        'endsAt',
        'Event end must be after start.',
      );
    }
    if (reminderOffsetMinutes != null && reminderOffsetMinutes < 0) {
      throw ArgumentError.value(
        reminderOffsetMinutes,
        'reminderOffsetMinutes',
        'Reminder offset must be zero or greater.',
      );
    }
  }

  void _validateScope(String scope, {required bool allowOne}) {
    final allowed = allowOne
        ? const {'one', 'future', 'all'}
        : const {'future', 'all'};
    if (!allowed.contains(scope)) {
      throw ArgumentError.value(scope, 'scope', 'Unsupported scope.');
    }
  }

  String _calendarReminderClientOperationId({
    required int profileId,
    required int eventId,
    required DateTime occurrenceKeyStart,
  }) {
    return 'calendar:$profileId:$eventId:${occurrenceKeyStart.toUtc().toIso8601String()}';
  }

  Future<void> _notifyCalendarEvent(
    Session session, {
    required int actorProfileId,
    required int familyId,
    required int eventId,
    required String title,
    required String category,
    required DateTime occurrenceStart,
    Transaction? transaction,
  }) async {
    await appNotifications.createLocalizedForFamilyMembers(
      session,
      familyId: familyId,
      excludeProfileIds: {actorProfileId},
      category: category,
      buildMessage: (localeCode, _) => buildCalendarEventNotificationMessage(
        localeCode: localeCode,
        category: category,
        eventTitle: title,
      ),
      entityType: 'calendar',
      entityId: eventId,
      route: '/home/calendar',
      payload: {
        'category': category,
        'familyId': familyId,
        'eventId': eventId,
        'occurrenceStart': occurrenceStart.toIso8601String(),
      },
      transaction: transaction,
    );
  }
}

class _Occurrence {
  const _Occurrence({
    required this.keyStart,
    required this.start,
    required this.end,
  });

  final DateTime keyStart;
  final DateTime start;
  final DateTime end;
}

class _Rrule {
  const _Rrule({
    required this.freq,
    required this.interval,
    required this.until,
    required this.count,
    required this.byDays,
  });

  final String freq;
  final int interval;
  final DateTime? until;
  final int? count;
  final Set<int> byDays;

  _Rrule copyWith({
    String? freq,
    int? interval,
    Object? until = _sentinel,
    Object? count = _sentinel,
    Set<int>? byDays,
  }) {
    return _Rrule(
      freq: freq ?? this.freq,
      interval: interval ?? this.interval,
      until: identical(until, _sentinel) ? this.until : until as DateTime?,
      count: identical(count, _sentinel) ? this.count : count as int?,
      byDays: byDays ?? this.byDays,
    );
  }
}

class _MaterializedReminder {
  const _MaterializedReminder({
    required this.clientOperationId,
    required this.remindAt,
    required this.payloadJson,
    required this.eventId,
  });

  final String clientOperationId;
  final DateTime remindAt;
  final String payloadJson;
  final int eventId;
}

const _sentinel = Object();
