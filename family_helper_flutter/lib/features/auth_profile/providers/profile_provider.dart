import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_snapshot_store.dart';
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

class ProfileSnapshotRestoreRequested extends ProfileEvent {
  const ProfileSnapshotRestoreRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested({
    this.displayName,
    this.timezone,
    this.avatarMediaId,
    this.clearAvatarMedia = false,
    this.analyticsOptIn,
  });

  final String? displayName;
  final String? timezone;
  final int? avatarMediaId;
  final bool clearAvatarMedia;
  final bool? analyticsOptIn;
}

class ProfileState {
  const ProfileState({
    required this.isLoading,
    this.profile,
    this.isUsingCachedData = false,
    this.lastSuccessfulSyncAt,
    this.error,
  });

  final bool isLoading;
  final ProfileDto? profile;
  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
  final String? error;

  ProfileState copyWith({
    bool? isLoading,
    ProfileDto? profile,
    bool? isUsingCachedData,
    DateTime? lastSuccessfulSyncAt,
    String? error,
    bool clearError = false,
    bool clearLastSuccessfulSyncAt = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      lastSuccessfulSyncAt: clearLastSuccessfulSyncAt
          ? null
          : (lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt),
      error: clearError ? null : (error ?? this.error),
    );
  }

  factory ProfileState.initial() {
    return const ProfileState(isLoading: true);
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required ProfileRepositoryContract repository,
    AuthCubit? authCubit,
    OfflineSnapshotStore? snapshotStore,
  }) : _repository = repository,
       _authCubit = authCubit,
       _snapshotStore = snapshotStore,
       super(ProfileState.initial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileResetRequested>(_onResetRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileSnapshotRestoreRequested>(_onSnapshotRestoreRequested);
    add(const ProfileSnapshotRestoreRequested());
  }

  final ProfileRepositoryContract _repository;
  final AuthCubit? _authCubit;
  final OfflineSnapshotStore? _snapshotStore;

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final profile = await _repository.me();
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(profile, syncedAt);
      _syncAuthProfile(profile);
      emit(
        state.copyWith(
          isLoading: false,
          profile: profile,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'profile.load',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoading: false,
          isUsingCachedData: state.profile != null,
          error: '$error',
        ),
      );
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
        clearAvatarMedia: event.clearAvatarMedia,
        analyticsOptIn: event.analyticsOptIn,
      );
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(updated, syncedAt);
      _syncAuthProfile(updated);
      emit(
        state.copyWith(
          isLoading: false,
          profile: updated,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'profile.update',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isLoading: false,
          isUsingCachedData: state.profile != null,
          error: '$error',
        ),
      );
    }
  }

  void _onResetRequested(
    ProfileResetRequested event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileState.initial());
  }

  Future<void> _onSnapshotRestoreRequested(
    ProfileSnapshotRestoreRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      final snapshot = await snapshotStore.read(_cacheKey);
      if (snapshot == null || isClosed) {
        return;
      }

      final profilePayload = snapshot.payload['profile'];
      if (profilePayload is! Map<String, dynamic>) {
        return;
      }

      emit(
        state.copyWith(
          isLoading: false,
          profile: ProfileDto.fromJson(profilePayload),
          isUsingCachedData: true,
          lastSuccessfulSyncAt: snapshot.updatedAt,
          clearError: true,
        ),
      );
      _syncAuthProfile(ProfileDto.fromJson(profilePayload));
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'profile.restoreSnapshot',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _writeSnapshot(ProfileDto profile, DateTime syncedAt) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      await snapshotStore.write(_cacheKey, {
        'profile': profile.toJson(),
      }, updatedAt: syncedAt);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'profile.writeSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {'profileId': profile.id},
      );
    }
  }

  void _syncAuthProfile(ProfileDto profile) {
    _authCubit?.setProfile(profile);
  }

  static const _cacheKey = 'profile/current';
}
