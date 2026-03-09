import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/app_error_logger.dart';
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
  PrivacyCubit({required PrivacyRepository repository})
    : _repository = repository,
      super(const PrivacyState());

  final PrivacyRepository _repository;

  Future<void> requestExport() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final job = await _repository.requestExport(
        clientOperationId: OperationId.next(),
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
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> requestAccountDeletion() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final status = await _repository.requestAccountDeletion(
        clientOperationId: OperationId.next(),
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
}
