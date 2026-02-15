import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/app_api_client.dart';

class SyncState {
  const SyncState({
    required this.since,
    required this.lastChanges,
    required this.isSyncing,
    this.error,
  });

  final DateTime since;
  final List<SyncChangeDto> lastChanges;
  final bool isSyncing;
  final String? error;

  factory SyncState.initial() {
    return SyncState(
      since: DateTime.utc(2020, 1, 1),
      lastChanges: const [],
      isSyncing: false,
    );
  }

  SyncState copyWith({
    DateTime? since,
    List<SyncChangeDto>? lastChanges,
    bool? isSyncing,
    String? error,
    bool clearError = false,
  }) {
    return SyncState(
      since: since ?? this.since,
      lastChanges: lastChanges ?? this.lastChanges,
      isSyncing: isSyncing ?? this.isSyncing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class SyncCubit extends Cubit<SyncState> {
  SyncCubit(this._apiClient) : super(SyncState.initial());

  final AppApiClient _apiClient;

  Future<SyncChangesResponse> sync({int? familyId, int limit = 200}) async {
    emit(state.copyWith(isSyncing: true, clearError: true));

    try {
      final response = await _apiClient.client.sync.changes(
        since: state.since,
        familyId: familyId,
        limit: limit,
      );

      emit(
        state.copyWith(
          isSyncing: false,
          since: response.nextSince,
          lastChanges: response.changes,
          clearError: true,
        ),
      );

      return response;
    } catch (error) {
      emit(state.copyWith(isSyncing: false, error: '$error'));
      rethrow;
    }
  }
}
