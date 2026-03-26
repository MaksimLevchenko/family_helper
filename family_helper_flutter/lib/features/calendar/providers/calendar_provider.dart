import 'dart:async';
import 'dart:convert';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/config/app_defaults.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../notifications/data/local_notification_service.dart';
import '../../notifications/data/notifications_repository.dart';
import '../../notifications/domain/notification_models.dart';
import '../data/calendar_repository.dart';
import '../domain/calendar_event_form.dart';

class CalendarState {
  const CalendarState({
    required this.isLoading,
    required this.isMutating,
    required this.instances,
    required this.selectedDay,
    required this.visibleMonth,
    this.error,
  });

  final bool isLoading;
  final bool isMutating;
  final List<CalendarInstanceDto> instances;
  final DateTime selectedDay;
  final DateTime visibleMonth;
  final String? error;

  factory CalendarState.initial() {
    final today = DateTime.now();
    final selectedDay = DateTime(today.year, today.month, today.day);
    final visibleMonth = DateTime(today.year, today.month);
    return CalendarState(
      isLoading: false,
      isMutating: false,
      instances: const [],
      selectedDay: selectedDay,
      visibleMonth: visibleMonth,
    );
  }

  CalendarState copyWith({
    bool? isLoading,
    bool? isMutating,
    List<CalendarInstanceDto>? instances,
    DateTime? selectedDay,
    DateTime? visibleMonth,
    String? error,
    bool clearError = false,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      isMutating: isMutating ?? this.isMutating,
      instances: instances ?? this.instances,
      selectedDay: selectedDay ?? this.selectedDay,
      visibleMonth: visibleMonth ?? this.visibleMonth,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({
    required CalendarRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    required AuthCubit authCubit,
    required NotificationsRepository notificationsRepository,
    required LocalNotificationService localNotificationService,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _authCubit = authCubit,
       _notificationsRepository = notificationsRepository,
       _localNotificationService = localNotificationService,
       super(CalendarState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
  }

  final CalendarRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final AuthCubit _authCubit;
  final NotificationsRepository _notificationsRepository;
  final LocalNotificationService _localNotificationService;
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
    emit(
      state.copyWith(
        visibleMonth: DateTime(month.year, month.month),
        clearError: true,
      ),
    );
    await reload();
  }

  Future<void> reload() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(isLoading: false, instances: const []));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

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
      emit(
        state.copyWith(
          isLoading: false,
          instances: instances,
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
      emit(state.copyWith(isLoading: false, error: '$error'));
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

    emit(state.copyWith(isMutating: true, clearError: true));
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
      emit(state.copyWith(isMutating: false));
      await reload();
      return event;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.saveSeries',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId, 'eventId': eventId},
      );
      emit(state.copyWith(isMutating: false, error: '$error'));
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

    emit(state.copyWith(isMutating: true, clearError: true));
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
      emit(state.copyWith(isMutating: false));
      await reload();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.saveOccurrence',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId, 'eventId': instance.eventId},
      );
      emit(state.copyWith(isMutating: false, error: '$error'));
    }
  }

  Future<void> deleteOccurrence(CalendarInstanceDto instance) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isMutating: true, clearError: true));
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
      emit(state.copyWith(isMutating: false));
      await reload();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.deleteOccurrence',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId, 'eventId': instance.eventId},
      );
      emit(state.copyWith(isMutating: false, error: '$error'));
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

    emit(state.copyWith(isMutating: true, clearError: true));
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
      emit(state.copyWith(isMutating: false));
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
      emit(state.copyWith(isMutating: false, error: '$error'));
    }
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
}
