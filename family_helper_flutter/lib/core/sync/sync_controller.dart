import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logging/app_error_logger.dart';
import '../network/app_api_client.dart';

class SyncState {
  const SyncState({
    required this.since,
    required this.lastSeenChangeId,
    required this.lastChanges,
    required this.isSyncing,
    this.error,
  });

  final DateTime since;
  final int lastSeenChangeId;
  final List<SyncChangeDto> lastChanges;
  final bool isSyncing;
  final String? error;

  factory SyncState.initial() {
    return SyncState(
      since: DateTime.utc(2020, 1, 1),
      lastSeenChangeId: 0,
      lastChanges: const [],
      isSyncing: false,
    );
  }

  SyncState copyWith({
    DateTime? since,
    int? lastSeenChangeId,
    List<SyncChangeDto>? lastChanges,
    bool? isSyncing,
    String? error,
    bool clearError = false,
  }) {
    return SyncState(
      since: since ?? this.since,
      lastSeenChangeId: lastSeenChangeId ?? this.lastSeenChangeId,
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
        lastSeenChangeId: state.lastSeenChangeId,
      );

      emit(
        state.copyWith(
          isSyncing: false,
          since: response.nextSince,
          lastSeenChangeId: response.nextLastSeenChangeId,
          lastChanges: response.changes,
          clearError: true,
        ),
      );

      return response;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'sync.sync',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'limit': limit,
        },
      );
      emit(state.copyWith(isSyncing: false, error: '$error'));
      rethrow;
    }
  }
}
