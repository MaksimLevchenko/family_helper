import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_error_classifier.dart';
import '../../../core/offline/offline_operation.dart';
import '../../../core/offline/offline_queue_manager.dart';
import '../../../core/utils/operation_id.dart';
import '../data/privacy_repository.dart';

class PrivacyState {
  const PrivacyState({
    this.lastExportJob,
    this.accountDeletion,
    this.isLoading = false,
    this.error,
  });

  final PrivacyExportJobDto? lastExportJob;
  final AccountDeletionStatusDto? accountDeletion;
  final bool isLoading;
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
    String? error,
    bool clearError = false,
  }) {
    return PrivacyState(
      lastExportJob: lastExportJob ?? this.lastExportJob,
      accountDeletion: accountDeletion ?? this.accountDeletion,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class PrivacyCubit extends Cubit<PrivacyState> {
  PrivacyCubit({
    required PrivacyRepository repository,
    required OfflineQueueManager offlineQueueManager,
  }) : _repository = repository,
       _offlineQueueManager = offlineQueueManager,
       super(const PrivacyState());

  final PrivacyRepository _repository;
  final OfflineQueueManager _offlineQueueManager;
  static const _offlineFeature = 'privacy';
  static const _actionRequestExport = 'request_export';
  static const _actionRequestAccountDeletion = 'request_account_deletion';

  void reset() {
    emit(const PrivacyState());
  }

  Future<void> reloadStatus() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _replayQueuedOperations();
      final status = await _repository.getStatus();
      emit(
        state.copyWith(
          isLoading: false,
          lastExportJob: status.lastExportJob,
          accountDeletion: status.accountDeletion,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'privacy.reloadStatus',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> requestExport() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      final job = await _repository.requestExport(
        clientOperationId: clientOperationId,
      );
      emit(
        state.copyWith(
          isLoading: false,
          lastExportJob: job,
          clearError: true,
        ),
      );
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
      emit(
        state.copyWith(
          isLoading: false,
          accountDeletion: status,
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
      emit(
        state.copyWith(
          isLoading: false,
          accountDeletion: status,
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
}
