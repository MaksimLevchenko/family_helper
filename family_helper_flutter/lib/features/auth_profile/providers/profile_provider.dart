import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/utils/operation_id.dart';
import '../data/profile_repository.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileResetRequested extends ProfileEvent {
  const ProfileResetRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested({
    this.displayName,
    this.timezone,
    this.avatarMediaId,
    this.analyticsOptIn,
  });

  final String? displayName;
  final String? timezone;
  final int? avatarMediaId;
  final bool? analyticsOptIn;
}

class ProfileState {
  const ProfileState({
    required this.isLoading,
    this.profile,
    this.error,
  });

  final bool isLoading;
  final ProfileDto? profile;
  final String? error;

  ProfileState copyWith({
    bool? isLoading,
    ProfileDto? profile,
    String? error,
    bool clearError = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: clearError ? null : (error ?? this.error),
    );
  }

  factory ProfileState.initial() {
    return const ProfileState(isLoading: true);
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required ProfileRepositoryContract repository})
    : _repository = repository,
      super(ProfileState.initial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileResetRequested>(_onResetRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
  }

  final ProfileRepositoryContract _repository;

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final profile = await _repository.me();
      emit(
        state.copyWith(isLoading: false, profile: profile, clearError: true),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'profile.load',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final updated = await _repository.update(
        clientOperationId: OperationId.next(),
        displayName: event.displayName,
        timezone: event.timezone,
        avatarMediaId: event.avatarMediaId,
        analyticsOptIn: event.analyticsOptIn,
      );
      emit(
        state.copyWith(isLoading: false, profile: updated, clearError: true),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'profile.update',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  void _onResetRequested(
    ProfileResetRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileState.initial());
  }
}
