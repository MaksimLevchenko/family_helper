import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/config/app_defaults.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/calendar_repository.dart';

class CalendarState {
  const CalendarState({
    required this.isLoading,
    required this.instances,
    this.error,
  });

  final bool isLoading;
  final List<CalendarInstanceDto> instances;
  final String? error;

  factory CalendarState.initial() {
    return const CalendarState(isLoading: false, instances: []);
  }

  CalendarState copyWith({
    bool? isLoading,
    List<CalendarInstanceDto>? instances,
    String? error,
    bool clearError = false,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      instances: instances ?? this.instances,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({
    required CalendarRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    required AuthCubit authCubit,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _authCubit = authCubit,
       super(CalendarState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
  }

  final CalendarRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final AuthCubit _authCubit;
  StreamSubscription<int?>? _familySub;

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

  Future<void> reload() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(const CalendarState(isLoading: false, instances: []));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final instances = await _repository.listInstances(
        familyId: familyId,
        rangeStart: DateTime.now().toUtc().subtract(
          AppDefaults.calendarLookBehind,
        ),
        rangeEnd: DateTime.now().toUtc().add(AppDefaults.calendarLookAhead),
      );
      emit(
        state.copyWith(
          isLoading: false,
          instances: instances,
          clearError: true,
        ),
      );
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

  Future<CalendarEventDto?> createEvent({
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    String? rrule,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return null;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final timezone =
          _authCubit.state.profile?.timezone ?? AppDefaults.defaultTimezone;
      final event = await _repository.upsertEvent(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        title: title,
        startsAt: startsAt,
        endsAt: endsAt,
        timezone: timezone,
        rrule: rrule,
      );
      await reload();
      return event;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.createEvent',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
      return null;
    }
  }

  Future<void> cancelOccurrence(CalendarInstanceDto instance) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.cancelOccurrence(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        eventId: instance.eventId,
        occurrenceStart: instance.occurrenceStart,
      );
      await reload();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'calendar.cancelOccurrence',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'eventId': instance.eventId,
        },
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
