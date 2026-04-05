import 'dart:async';

import '../../features/auth_profile/data/profile_repository.dart';
import '../auth/auth_session.dart';
import '../logging/app_error_logger.dart';
import '../utils/operation_id.dart';
import 'locale_controller.dart';

class LocaleSyncService {
  LocaleSyncService({
    required LocaleCubit localeCubit,
    required AuthCubit authCubit,
    required ProfileRepositoryContract profileRepository,
  }) : _localeCubit = localeCubit,
       _authCubit = authCubit,
       _profileRepository = profileRepository;

  final LocaleCubit _localeCubit;
  final AuthCubit _authCubit;
  final ProfileRepositoryContract _profileRepository;

  StreamSubscription<AppLocaleState>? _localeSubscription;
  StreamSubscription<AuthSessionState>? _authSubscription;
  bool _isSyncing = false;

  void start() {
    _localeSubscription ??= _localeCubit.stream.listen((_) {
      unawaited(_syncIfNeeded());
    });
    _authSubscription ??= _authCubit.stream.listen((_) {
      unawaited(_syncIfNeeded());
    });
    unawaited(_syncIfNeeded());
  }

  Future<void> dispose() async {
    await _localeSubscription?.cancel();
    await _authSubscription?.cancel();
  }

  Future<void> _syncIfNeeded() async {
    if (_isSyncing) {
      return;
    }

    final authState = _authCubit.state;
    if (!authState.isAuthenticated) {
      return;
    }

    final profile = authState.profile;
    if (profile == null) {
      return;
    }

    final effectiveLocale = _localeCubit.state.effectiveLocaleCode;
    if (profile.locale == effectiveLocale) {
      return;
    }

    _isSyncing = true;
    try {
      final updated = await _profileRepository.update(
        clientOperationId: OperationId.next(),
        locale: effectiveLocale,
      );
      _authCubit.setProfile(updated);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'locale.syncProfileLocale',
        error: error,
        stackTrace: stackTrace,
        context: {'effectiveLocale': effectiveLocale},
      );
    } finally {
      _isSyncing = false;
    }
  }
}
