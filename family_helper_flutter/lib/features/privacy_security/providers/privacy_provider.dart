import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_error_classifier.dart';
import '../../../core/offline/offline_operation.dart';
import '../../../core/offline/offline_queue_manager.dart';
import '../../../core/offline/offline_snapshot_store.dart';
import '../../../core/utils/operation_id.dart';
import '../data/privacy_repository.dart';

class PrivacyState {
  const PrivacyState({
    this.lastExportJob,
    this.accountDeletion,
    this.isLoading = false,
    this.isUsingCachedData = false,
    this.lastSuccessfulSyncAt,
    this.error,
  });

  final PrivacyExportJobDto? lastExportJob;
  final AccountDeletionStatusDto? accountDeletion;
  final bool isLoading;
  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
  final String? error;

  bool get hasActiveDeletionRequest {
    final status = accountDeletion?.status;
    return status == 'requested' ||
        status == 'pending' ||
        status == 'scheduled' ||
        status == 'processing';
  }

  bool get shouldShowDeletionCard => hasActiveDeletionRequest;

  bool get isExportExpired {
    final expiresAt = lastExportJob?.expiresAt;
    if (expiresAt == null) {
      return false;
    }
    return expiresAt.isBefore(DateTime.now().toUtc());
  }

  bool get canDownloadExport =>
      (lastExportJob?.signedUrl?.trim().isNotEmpty ?? false) &&
      !isExportExpired;

  bool get hasVisiblePrivacyRequest =>
      lastExportJob != null || shouldShowDeletionCard;

  PrivacyState copyWith({
    PrivacyExportJobDto? lastExportJob,
    AccountDeletionStatusDto? accountDeletion,
    bool? isLoading,
    bool? isUsingCachedData,
    DateTime? lastSuccessfulSyncAt,
    String? error,
    bool clearError = false,
    bool clearLastSuccessfulSyncAt = false,
  }) {
    return PrivacyState(
      lastExportJob: lastExportJob ?? this.lastExportJob,
      accountDeletion: accountDeletion ?? this.accountDeletion,
      isLoading: isLoading ?? this.isLoading,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      lastSuccessfulSyncAt: clearLastSuccessfulSyncAt
          ? null
          : (lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class PrivacyCubit extends Cubit<PrivacyState> {
  PrivacyCubit({
    required PrivacyRepositoryContract repository,
    required OfflineQueueManager offlineQueueManager,
    OfflineSnapshotStore? snapshotStore,
    Duration exportStatusPollInterval = const Duration(seconds: 3),
    Duration exportStatusPollingTimeout = const Duration(seconds: 60),
    Future<void> Function(Duration duration)? delay,
  }) : _repository = repository,
       _offlineQueueManager = offlineQueueManager,
       _snapshotStore = snapshotStore,
       _exportStatusPollInterval = exportStatusPollInterval,
       _exportStatusPollingTimeout = exportStatusPollingTimeout,
       _delay = delay ?? Future<void>.delayed,
       super(const PrivacyState()) {
    _restoreSnapshot();
  }

  final PrivacyRepositoryContract _repository;
  final OfflineQueueManager _offlineQueueManager;
  final OfflineSnapshotStore? _snapshotStore;
  final Duration _exportStatusPollInterval;
  final Duration _exportStatusPollingTimeout;
  final Future<void> Function(Duration duration) _delay;
  static const _offlineFeature = 'privacy';
  static const _actionRequestExport = 'request_export';
  static const _actionRequestAccountDeletion = 'request_account_deletion';
  int _exportPollGeneration = 0;

  void reset() {
    _exportPollGeneration++;
    emit(const PrivacyState());
  }

  Future<void> reloadStatus() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _replayQueuedOperations();
      final status = await _repository.getStatus();
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(
        lastExportJob: status.lastExportJob,
        accountDeletion: status.accountDeletion,
        syncedAt: syncedAt,
      );
      emit(
        state.copyWith(
          isLoading: false,
          lastExportJob: status.lastExportJob,
          accountDeletion: status.accountDeletion,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'privacy.reloadStatus',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoading: false,
          isUsingCachedData:
              state.lastExportJob != null || state.accountDeletion != null,
          error: '$error',
        ),
      );
    }
  }

  Future<void> requestExport() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      final job = await _repository.requestExport(
        clientOperationId: clientOperationId,
      );
      await _writeSnapshot(
        lastExportJob: job,
        accountDeletion: state.accountDeletion,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
      emit(
        state.copyWith(
          isLoading: false,
          lastExportJob: job,
          isUsingCachedData: false,
          clearError: true,
        ),
      );
      unawaited(_pollExportStatus(jobId: job.id));
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'privacy.requestExport',
        error: error,
        stackTrace: stackTrace,
      );
      if (isOfflineRecoverableError(error)) {
        await _enqueueOfflineOperation(
          action: _actionRequestExport,
          payload: {'clientOperationId': clientOperationId},
        );
        emit(
          state.copyWith(
            isLoading: false,
            isUsingCachedData:
                state.lastExportJob != null || state.accountDeletion != null,
            error: 'Network unavailable. Export request queued.',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> requestAccountDeletion() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      final status = await _repository.requestAccountDeletion(
        clientOperationId: clientOperationId,
      );
      await _writeSnapshot(
        lastExportJob: state.lastExportJob,
        accountDeletion: status,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
      emit(
        state.copyWith(
          isLoading: false,
          accountDeletion: status,
          isUsingCachedData: false,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'privacy.requestAccountDeletion',
        error: error,
        stackTrace: stackTrace,
      );
      if (isOfflineRecoverableError(error)) {
        await _enqueueOfflineOperation(
          action: _actionRequestAccountDeletion,
          payload: {'clientOperationId': clientOperationId},
        );
        emit(
          state.copyWith(
            isLoading: false,
            isUsingCachedData:
                state.lastExportJob != null || state.accountDeletion != null,
            error: 'Network unavailable. Deletion request queued.',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> cancelAccountDeletion() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final status = await _repository.cancelAccountDeletion();
      await _writeSnapshot(
        lastExportJob: state.lastExportJob,
        accountDeletion: status,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
      emit(
        state.copyWith(
          isLoading: false,
          accountDeletion: status,
          isUsingCachedData: false,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'privacy.cancelAccountDeletion',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> _enqueueOfflineOperation({
    required String action,
    required Map<String, dynamic> payload,
  }) {
    return _offlineQueueManager.enqueue(
      OfflineOperation(
        id: OperationId.next(),
        feature: _offlineFeature,
        action: action,
        payload: payload,
        createdAt: DateTime.now().toUtc(),
        attempt: 0,
      ),
    );
  }

  Future<void> _replayQueuedOperations() {
    return _offlineQueueManager.replayWhere(
      (operation) async {
        switch (operation.action) {
          case _actionRequestExport:
            await _repository.requestExport(
              clientOperationId:
                  operation.payload['clientOperationId'] as String,
            );
            return;
          case _actionRequestAccountDeletion:
            await _repository.requestAccountDeletion(
              clientOperationId:
                  operation.payload['clientOperationId'] as String,
            );
            return;
        }
      },
      canProcess: (operation) => operation.feature == _offlineFeature,
    );
  }

  Future<void> _pollExportStatus({required int jobId}) async {
    final generation = ++_exportPollGeneration;
    final deadline = DateTime.now().toUtc().add(_exportStatusPollingTimeout);

    while (!isClosed &&
        generation == _exportPollGeneration &&
        DateTime.now().toUtc().isBefore(deadline)) {
      await _delay(_exportStatusPollInterval);
      if (isClosed || generation != _exportPollGeneration) {
        return;
      }

      try {
        final status = await _repository.getStatus();
        if (isClosed || generation != _exportPollGeneration) {
          return;
        }

        final latestJob = status.lastExportJob;
        emit(
          state.copyWith(
            lastExportJob: latestJob,
            accountDeletion: status.accountDeletion,
            isUsingCachedData: false,
            clearError: true,
          ),
        );
        await _writeSnapshot(
          lastExportJob: latestJob,
          accountDeletion: status.accountDeletion,
          syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
        );

        if (latestJob == null) {
          continue;
        }
        if (latestJob.id != jobId) {
          return;
        }
        if (_isTerminalExportStatus(latestJob.status)) {
          return;
        }
      } catch (error, stackTrace) {
        AppErrorLogger.logHandled(
          scope: 'privacy.pollExportStatus',
          error: error,
          stackTrace: stackTrace,
        );
        if (isClosed || generation != _exportPollGeneration) {
          return;
        }
        emit(state.copyWith(error: '$error'));
        return;
      }
    }

    if (isClosed || generation != _exportPollGeneration) {
      return;
    }

    emit(
      state.copyWith(
        error: 'Export is still processing. Check back in a moment.',
      ),
    );
  }

  bool _isTerminalExportStatus(String status) {
    return status == 'ready' || status == 'failed';
  }

  @override
  Future<void> close() {
    _exportPollGeneration++;
    return super.close();
  }

  Future<void> _restoreSnapshot() async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      final snapshot = await snapshotStore.read(_cacheKey);
      if (snapshot == null || isClosed) {
        return;
      }

      final lastExportJob = snapshot.payload['lastExportJob'];
      final accountDeletion = snapshot.payload['accountDeletion'];
      emit(
        state.copyWith(
          isLoading: false,
          lastExportJob: lastExportJob is Map<String, dynamic>
              ? PrivacyExportJobDto.fromJson(lastExportJob)
              : null,
          accountDeletion: accountDeletion is Map<String, dynamic>
              ? AccountDeletionStatusDto.fromJson(accountDeletion)
              : null,
          isUsingCachedData: true,
          lastSuccessfulSyncAt: snapshot.updatedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'privacy.restoreSnapshot',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _writeSnapshot({
    required PrivacyExportJobDto? lastExportJob,
    required AccountDeletionStatusDto? accountDeletion,
    required DateTime syncedAt,
  }) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      await snapshotStore.write(_cacheKey, {
        'lastExportJob': lastExportJob?.toJson(),
        'accountDeletion': accountDeletion?.toJson(),
      }, updatedAt: syncedAt);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'privacy.writeSnapshot',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static const _cacheKey = 'privacy/current';
}
