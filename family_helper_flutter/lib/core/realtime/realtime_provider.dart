import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/app_defaults.dart';
import '../../features/family_invites/providers/family_provider.dart';
import '../logging/app_error_logger.dart';
import 'realtime_subscription_manager.dart';

typedef RealtimeInvalidationCallback =
    Future<void> Function(Set<String> features);
typedef RealtimeSyncCallback = Future<void> Function(int familyId);

class RealtimeState {
  const RealtimeState({
    required this.started,
    this.familyId,
    this.error,
  });

  final bool started;
  final int? familyId;
  final String? error;

  factory RealtimeState.initial() {
    return const RealtimeState(started: false);
  }

  RealtimeState copyWith({
    bool? started,
    int? familyId,
    String? error,
    bool clearError = false,
  }) {
    return RealtimeState(
      started: started ?? this.started,
      familyId: familyId ?? this.familyId,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class RealtimeCubit extends Cubit<RealtimeState> {
  RealtimeCubit({
    required RealtimeSubscriptionDriver manager,
    required FamilySelectionCubit familySelectionCubit,
    required RealtimeSyncCallback syncFamily,
    required RealtimeInvalidationCallback onInvalidation,
    Duration debounce = AppDefaults.realtimeDebounce,
  }) : _manager = manager,
       _familySelectionCubit = familySelectionCubit,
       _syncFamily = syncFamily,
       _onInvalidation = onInvalidation,
       _debounce = debounce,
       super(RealtimeState.initial());

  final RealtimeSubscriptionDriver _manager;
  final FamilySelectionCubit _familySelectionCubit;
  final RealtimeSyncCallback _syncFamily;
  final RealtimeInvalidationCallback _onInvalidation;
  final Duration _debounce;

  StreamSubscription<int?>? _familySubscription;
  Timer? _flushTimer;
  final Set<String> _pendingFeatures = <String>{};
  bool _flushInProgress = false;
  int? _pendingFamilyId;

  Future<void> start() async {
    if (state.started) {
      return;
    }

    emit(state.copyWith(started: true, clearError: true));

    _familySubscription = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_bindFamily(familyId));
    });

    await _bindFamily(_familySelectionCubit.state);
  }

  Future<void> _bindFamily(int? familyId) async {
    if (familyId == null) {
      await _manager.dispose();
      emit(state.copyWith(familyId: null, clearError: true));
      return;
    }

    try {
      await _manager.subscribeToFamily(
        familyId,
        onEvent: (event) async {
          _pendingFamilyId = event.familyId;
          _pendingFeatures.add(event.feature);
          _flushTimer?.cancel();
          _flushTimer = Timer(_debounce, () {
            unawaited(_flushPending());
          });
        },
      );
      emit(state.copyWith(familyId: familyId, clearError: true));
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'realtime.bindFamily',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(error: '$error'));
    }
  }

  @override
  Future<void> close() async {
    _flushTimer?.cancel();
    await _familySubscription?.cancel();
    await _manager.dispose();
    return super.close();
  }

  Future<void> _flushPending() async {
    if (_flushInProgress) {
      return;
    }

    final familyId = _pendingFamilyId;
    if (familyId == null || _pendingFeatures.isEmpty) {
      return;
    }

    _flushInProgress = true;
    try {
      while (_pendingFeatures.isNotEmpty) {
        final features = Set<String>.from(_pendingFeatures);
        _pendingFeatures.clear();
        await _syncFamily(familyId);
        await _onInvalidation(features);
      }
    } finally {
      _flushInProgress = false;
    }
  }
}
