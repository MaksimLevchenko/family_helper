import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/family_invites/providers/family_provider.dart';
import '../sync/sync_controller.dart';
import 'realtime_subscription_manager.dart';

typedef RealtimeInvalidationCallback = Future<void> Function(
  FamilyRealtimeEvent event,
);

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
    required RealtimeSubscriptionManager manager,
    required FamilySelectionCubit familySelectionCubit,
    required SyncCubit syncCubit,
    required RealtimeInvalidationCallback onInvalidation,
  }) : _manager = manager,
       _familySelectionCubit = familySelectionCubit,
       _syncCubit = syncCubit,
       _onInvalidation = onInvalidation,
       super(RealtimeState.initial());

  final RealtimeSubscriptionManager _manager;
  final FamilySelectionCubit _familySelectionCubit;
  final SyncCubit _syncCubit;
  final RealtimeInvalidationCallback _onInvalidation;

  StreamSubscription<int?>? _familySubscription;

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
          await _syncCubit.sync(familyId: event.familyId);
          await _onInvalidation(event);
        },
      );
      emit(state.copyWith(familyId: familyId, clearError: true));
    } catch (error) {
      emit(state.copyWith(error: '$error'));
    }
  }

  @override
  Future<void> close() async {
    await _familySubscription?.cancel();
    await _manager.dispose();
    return super.close();
  }
}
