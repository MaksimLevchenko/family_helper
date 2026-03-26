import 'dart:async';
import 'dart:convert';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/config/app_defaults.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_snapshot_store.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../notifications/data/local_notification_service.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../notifications/domain/notification_models.dart';
import '../data/calendar_repository.dart';
import '../domain/calendar_event_form.dart';

enum CalendarLoadPhase { idle, initialLoad, monthTransition }

enum CalendarMutationKind {
  saveSeries,
  saveOccurrence,
  deleteOccurrence,
  deleteSeries,
}

class CalendarState {
  const CalendarState({
    required this.loadPhase,
    required this.instances,
    required this.selectedDay,
    required this.visibleMonth,
    this.isUsingCachedData = false,
    this.lastSuccessfulSyncAt,
    this.pendingMutationType,
    this.pendingOccurrenceKeyStart,
    this.error,
    this.errorFromMutation = false,
  });

  final CalendarLoadPhase loadPhase;
  final List<CalendarInstanceDto> instances;
  final DateTime selectedDay;
  final DateTime visibleMonth;
  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
  final CalendarMutationKind? pendingMutationType;
  final DateTime? pendingOccurrenceKeyStart;
  final String? error;
  final bool errorFromMutation;

  bool get isLoading => loadPhase != CalendarLoadPhase.idle;
  bool get isInitialLoading => loadPhase == CalendarLoadPhase.initialLoad;
  bool get isMonthTransitioning =>
      loadPhase == CalendarLoadPhase.monthTransition;
  bool get isMutating => pendingMutationType != null;

  factory CalendarState.initial() {
    final today = DateTime.now();
    final selectedDay = DateTime(today.year, today.month, today.day);
    final visibleMonth = DateTime(today.year, today.month);
    return CalendarState(
      loadPhase: CalendarLoadPhase.idle,
      instances: const [],
      selectedDay: selectedDay,
      visibleMonth: visibleMonth,
    );
  }

  CalendarState copyWith({
    CalendarLoadPhase? loadPhase,
    List<CalendarInstanceDto>? instances,
    DateTime? selectedDay,
    DateTime? visibleMonth,
    bool? isUsingCachedData,
    DateTime? lastSuccessfulSyncAt,
    CalendarMutationKind? pendingMutationType,
    DateTime? pendingOccurrenceKeyStart,
    String? error,
    bool? errorFromMutation,
    bool clearError = false,
    bool clearPendingMutation = false,
    bool clearLastSuccessfulSyncAt = false,
  }) {
    return CalendarState(
      loadPhase: loadPhase ?? this.loadPhase,
      instances: instances ?? this.instances,
      selectedDay: selectedDay ?? this.selectedDay,
      visibleMonth: visibleMonth ?? this.visibleMonth,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      lastSuccessfulSyncAt: clearLastSuccessfulSyncAt
          ? null
          : (lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt),
      pendingMutationType: clearPendingMutation
          ? null
          : (pendingMutationType ?? this.pendingMutationType),
      pendingOccurrenceKeyStart: clearPendingMutation
          ? null
          : (pendingOccurrenceKeyStart ?? this.pendingOccurrenceKeyStart),
      error: clearError ? null : (error ?? this.error),
      errorFromMutation: clearError
          ? false
          : (errorFromMutation ?? this.errorFromMutation),
    );
  }

  bool isPendingInstance(CalendarInstanceDto instance) {
    final pendingKey = pendingOccurrenceKeyStart;
    return pendingKey != null &&
        pendingKey.isAtSameMomentAs(instance.occurrenceKeyStart);
  }
}

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({
    required CalendarRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    required AuthCubit authCubit,
    required NotificationsRepository notificationsRepository,
    required LocalNotificationService localNotificationService,
    OfflineSnapshotStore? snapshotStore,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _authCubit = authCubit,
       _notificationsRepository = notificationsRepository,
       _localNotificationService = localNotificationService,
       _snapshotStore = snapshotStore,
       super(CalendarState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
    if (_familySelectionCubit.state != null) {
      unawaited(_handleFamilyChanged(_familySelectionCubit.state));
    }
  }

  final CalendarRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final AuthCubit _authCubit;
  final NotificationsRepository _notificationsRepository;
  final LocalNotificationService _localNotificationService;
  final OfflineSnapshotStore? _snapshotStore;
  StreamSubscription<int?>? _familySub;

  List<CalendarInstanceDto> agendaForDay(DateTime day) {
    return state.instances.where((instance) {
      final local = instance.occurrenceStart.toLocal();
      return local.year == day.year &&
          local.month == day.month &&
          local.day == day.day;
    }).toList()..sort(
      (left, right) => left.occurrenceStart.compareTo(right.occurrenceStart),
    );
  }

  Map<DateTime, List<CalendarInstanceDto>> eventsByDay() {
    final grouped = <DateTime, List<CalendarInstanceDto>>{};
    for (final instance in state.instances) {
      final local = instance.occurrenceStart.toLocal();
      final key = DateTime(local.year, local.month, local.day);
      grouped.putIfAbsent(key, () => <CalendarInstanceDto>[]).add(instance);
    }
    return grouped;
  }

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset();
    if (familyId == null) {
      return;
    }
    await _restoreSnapshot(familyId);
    await reload();
  }

  void reset() {
    emit(CalendarState.initial());
  }

  void selectDay(DateTime day) {
    emit(
      state.copyWith(
        selectedDay: DateTime(day.year, day.month, day.day),
        visibleMonth: DateTime(day.year, day.month),
        clearError: true,
      ),
    );
  }

  Future<void> setVisibleMonth(DateTime month) async {
    final normalizedMonth = DateTime(month.year, month.month);
    if (normalizedMonth.year == state.visibleMonth.year &&
        normalizedMonth.month == state.visibleMonth.month) {
      return;
    }

    final nextSelectedDay = _selectableDayInMonth(
      baseDay: state.selectedDay,
      visibleMonth: normalizedMonth,
    );
    emit(
      state.copyWith(
        selectedDay: nextSelectedDay,
        visibleMonth: normalizedMonth,
        clearError: true,
      ),
    );
    await reload();
  }

  Future<void> reload() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(
        state.copyWith(
          loadPhase: CalendarLoadPhase.idle,
          instances: const [],
          clearPendingMutation: true,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        loadPhase: state.instances.isEmpty
            ? CalendarLoadPhase.initialLoad
            : CalendarLoadPhase.monthTransition,
        clearError: true,
      ),
    );

    try {
      final rangeStart = DateTime.utc(
        state.visibleMonth.year,
        state.visibleMonth.month,
        1,
      ).subtract(AppDefaults.calendarLookBehind);
      final rangeEnd = DateTime.utc(
        state.visibleMonth.year,
        state.visibleMonth.month + 1,
        1,
      ).add(AppDefaults.calendarLookAhead);
      final instances = await _repository.listInstances(
        familyId: familyId,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(familyId, instances, syncedAt);
      emit(
        state.copyWith(
          loadPhase: CalendarLoadPhase.idle,
          instances: instances,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
      await _syncLocalCalendarReminders(familyId);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.reload',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(
        state.copyWith(
          loadPhase: CalendarLoadPhase.idle,
          isUsingCachedData: state.instances.isNotEmpty,
          error: '$error',
          errorFromMutation: false,
        ),
      );
    }
  }

  Future<CalendarEventDto> loadEvent(int eventId) async {
    final familyId = _requireFamilyId();
    return _repository.getEvent(familyId: familyId, eventId: eventId);
  }

  Future<CalendarEventDto?> saveSeries({
    required CalendarEventForm form,
    int? eventId,
    CalendarMutationScope scope = CalendarMutationScope.all,
    DateTime? anchorOccurrenceStart,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return null;
    }

    emit(
      state.copyWith(
        pendingMutationType: CalendarMutationKind.saveSeries,
        pendingOccurrenceKeyStart: anchorOccurrenceStart,
        clearError: true,
      ),
    );
    try {
      final timezone =
          _authCubit.state.profile?.timezone ?? AppDefaults.defaultTimezone;
      final event = await _repository.upsertEvent(
        clientOperationId: OperationId.next(),
        eventId: eventId,
        familyId: familyId,
        title: form.title.trim(),
        description: form.description?.trim(),
        startsAt: form.startsAt,
        endsAt: form.endsAt,
        timezone: timezone,
        rrule: form.rrule,
        reminderOffsetMinutes: form.reminderOffsetMinutes,
        scope: scope.apiValue,
        anchorOccurrenceStart: anchorOccurrenceStart,
      );
      emit(state.copyWith(clearPendingMutation: true, clearError: true));
      await reload();
      return event;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.saveSeries',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId, 'eventId': eventId},
      );
      emit(
        state.copyWith(
          clearPendingMutation: true,
          error: '$error',
          errorFromMutation: true,
        ),
      );
      return null;
    }
  }

  Future<void> saveOccurrence({
    required CalendarInstanceDto instance,
    required CalendarEventForm form,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(
      state.copyWith(
        pendingMutationType: CalendarMutationKind.saveOccurrence,
        pendingOccurrenceKeyStart: instance.occurrenceKeyStart,
        clearError: true,
      ),
    );
    try {
      await _repository.upsertOccurrence(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        eventId: instance.eventId,
        occurrenceKeyStart: instance.occurrenceKeyStart,
        overrideTitle: form.title.trim(),
        overrideStartsAt: form.startsAt,
        overrideEndsAt: form.endsAt,
        overrideReminderOffsetMinutes: form.reminderOffsetMinutes,
        overrideReminderCleared: form.reminderOffsetMinutes == null,
      );
      emit(state.copyWith(clearPendingMutation: true, clearError: true));
      await reload();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.saveOccurrence',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId, 'eventId': instance.eventId},
      );
      emit(
        state.copyWith(
          clearPendingMutation: true,
          error: '$error',
          errorFromMutation: true,
        ),
      );
    }
  }

  Future<void> deleteOccurrence(CalendarInstanceDto instance) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(
      state.copyWith(
        pendingMutationType: CalendarMutationKind.deleteOccurrence,
        pendingOccurrenceKeyStart: instance.occurrenceKeyStart,
        clearError: true,
      ),
    );
    try {
      await _repository.upsertOccurrence(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        eventId: instance.eventId,
        occurrenceKeyStart: instance.occurrenceKeyStart,
        overrideTitle: instance.title,
        overrideStartsAt: instance.occurrenceStart,
        overrideEndsAt: instance.occurrenceEnd,
        overrideReminderOffsetMinutes: instance.reminderOffsetMinutes,
        overrideReminderCleared: instance.reminderOffsetMinutes == null,
        cancelled: true,
      );
      emit(state.copyWith(clearPendingMutation: true, clearError: true));
      await reload();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.deleteOccurrence',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId, 'eventId': instance.eventId},
      );
      emit(
        state.copyWith(
          clearPendingMutation: true,
          error: '$error',
          errorFromMutation: true,
        ),
      );
    }
  }

  Future<void> deleteSeries({
    required CalendarInstanceDto instance,
    required CalendarMutationScope scope,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(
      state.copyWith(
        pendingMutationType: CalendarMutationKind.deleteSeries,
        pendingOccurrenceKeyStart: instance.occurrenceKeyStart,
        clearError: true,
      ),
    );
    try {
      await _repository.deleteEvent(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        eventId: instance.eventId,
        scope: scope.apiValue,
        anchorOccurrenceStart: scope == CalendarMutationScope.future
            ? instance.occurrenceKeyStart
            : null,
      );
      emit(state.copyWith(clearPendingMutation: true, clearError: true));
      await reload();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.deleteSeries',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'eventId': instance.eventId,
          'scope': scope.apiValue,
        },
      );
      emit(
        state.copyWith(
          clearPendingMutation: true,
          error: '$error',
          errorFromMutation: true,
        ),
      );
    }
  }

  DateTime _selectableDayInMonth({
    required DateTime baseDay,
    required DateTime visibleMonth,
  }) {
    final lastDayOfMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;
    final clampedDay = baseDay.day > lastDayOfMonth
        ? lastDayOfMonth
        : baseDay.day;
    return DateTime(visibleMonth.year, visibleMonth.month, clampedDay);
  }

  int _requireFamilyId() {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      throw StateError('Family is not selected.');
    }
    return familyId;
  }

  Future<void> _syncLocalCalendarReminders(int familyId) async {
    final permissionStatus = await _localNotificationService
        .getPermissionStatus();
    if (!permissionStatus.isGranted) {
      return;
    }

    final reminders = await _notificationsRepository.listReminders(
      familyId: familyId,
      status: 'scheduled',
      limit: 500,
    );
    final schedules = reminders
        .where(
          (reminder) =>
              reminder.entityType == AppDefaults.calendarReminderEntityType,
        )
        .map(_mapReminderSchedule)
        .toList();
    await _localNotificationService.syncReminderSet(
      namespace: 'calendar_$familyId',
      reminders: schedules,
    );
  }

  LocalReminderSchedule _mapReminderSchedule(ReminderDto reminder) {
    String title = 'Event reminder';
    String body = 'Family event';

    try {
      final payload = jsonDecode(reminder.payloadJson) as Map<String, dynamic>;
      title = (payload['title'] as String?)?.trim().isNotEmpty == true
          ? payload['title'] as String
          : title;
      body = (payload['body'] as String?)?.trim().isNotEmpty == true
          ? payload['body'] as String
          : body;
    } catch (_) {
      // Fall back to generic strings when payload is malformed.
    }

    return LocalReminderSchedule(
      id: reminder.id,
      title: title,
      body: body,
      scheduledAt: reminder.remindAt.toLocal(),
    );
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }

  Future<void> _restoreSnapshot(int familyId) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      final snapshot = await snapshotStore.read(_cacheKey(familyId));
      if (snapshot == null || isClosed) {
        return;
      }

      final instances =
          (snapshot.payload['instances'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(CalendarInstanceDto.fromJson)
              .toList();
      final selectedDay = snapshot.payload['selectedDay'] as String?;
      final visibleMonth = snapshot.payload['visibleMonth'] as String?;
      emit(
        state.copyWith(
          loadPhase: CalendarLoadPhase.idle,
          instances: instances,
          selectedDay: selectedDay == null
              ? state.selectedDay
              : DateTime.parse(selectedDay),
          visibleMonth: visibleMonth == null
              ? state.visibleMonth
              : DateTime.parse(visibleMonth),
          isUsingCachedData: true,
          lastSuccessfulSyncAt: snapshot.updatedAt,
          clearPendingMutation: true,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.restoreSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
    }
  }

  Future<void> _writeSnapshot(
    int familyId,
    List<CalendarInstanceDto> instances,
    DateTime syncedAt,
  ) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      await snapshotStore.write(_cacheKey(familyId), {
        'selectedDay': state.selectedDay.toIso8601String(),
        'visibleMonth': state.visibleMonth.toIso8601String(),
        'instances': instances.map((instance) => instance.toJson()).toList(),
      }, updatedAt: syncedAt);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.writeSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId, 'instancesCount': instances.length},
      );
    }
  }

  String _cacheKey(int familyId) => 'calendar/family/$familyId';
}
