import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/auth/auth_session.dart';
import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_error_classifier.dart';
import '../../../core/offline/offline_operation.dart';
import '../../../core/offline/offline_queue_manager.dart';
import '../../../core/offline/offline_snapshot_store.dart';
import '../../../core/utils/operation_id.dart';
import '../data/family_repository.dart';

const _familyIdStorageKey = 'current_family_id';

class FamilySelectionCubit extends Cubit<int?> {
  FamilySelectionCubit({
    FamilyRepository? repository,
    AuthCubit? authCubit,
    FlutterSecureStorage? storage,
    Future<FamilyDto?> Function()? loadCurrentFamily,
    Stream<AuthSessionState>? authStates,
    AuthSessionState? Function()? authStateProvider,
  }) : _repository = repository,
       _authCubit = authCubit,
       _storage = storage ?? const FlutterSecureStorage(),
       _loadCurrentFamily = loadCurrentFamily,
       _authStates = authStates,
       _authStateProvider = authStateProvider,
       super(null);

  final FamilyRepository? _repository;
  final AuthCubit? _authCubit;
  final FlutterSecureStorage _storage;
  final Future<FamilyDto?> Function()? _loadCurrentFamily;
  final Stream<AuthSessionState>? _authStates;
  final AuthSessionState? Function()? _authStateProvider;
  bool _bootstrapped = false;
  StreamSubscription<AuthSessionState>? _authSub;

  Future<void> bootstrap() async {
    if (_bootstrapped) {
      return;
    }
    _bootstrapped = true;
    await _restore();
    _authSub = _resolvedAuthStates?.listen((auth) {
      unawaited(_handleAuthState(auth));
    });

    final authState = _currentAuthState();
    if (authState != null) {
      await _handleAuthState(authState);
    }
  }

  Future<void> _restore() async {
    final value = await _storage.read(key: _familyIdStorageKey);
    if (value == null) {
      return;
    }
    emit(int.tryParse(value));
  }

  Future<void> setFamilyId(int familyId) async {
    emit(familyId);
    await _storage.write(key: _familyIdStorageKey, value: '$familyId');
  }

  Future<void> clear() async {
    emit(null);
    await _storage.delete(key: _familyIdStorageKey);
  }

  Stream<AuthSessionState>? get _resolvedAuthStates =>
      _authStates ?? _authCubit?.stream;

  AuthSessionState? _currentAuthState() =>
      _authStateProvider?.call() ?? _authCubit?.state;

  Future<void> _handleAuthState(AuthSessionState auth) async {
    if (auth.isInitializing) {
      return;
    }

    if (!auth.isAuthenticated) {
      if (state != null) {
        emit(null);
      }
      return;
    }

    final loadCurrentFamily =
        _loadCurrentFamily ?? _repository?.getCurrentFamily;
    if (loadCurrentFamily == null) {
      return;
    }

    try {
      final family = await loadCurrentFamily();
      if (family == null) {
        if (state != null) {
          emit(null);
        }
        await _storage.delete(key: _familyIdStorageKey);
        return;
      }

      if (state != family.id) {
        emit(family.id);
      }
      await _storage.write(key: _familyIdStorageKey, value: '${family.id}');
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.restoreCurrentFamily',
        error: error,
        stackTrace: stackTrace,
        context: {'hasCachedFamilyId': state != null},
      );
    }
  }

  @override
  Future<void> close() async {
    await _authSub?.cancel();
    return super.close();
  }
}

class FamilyMembersState {
  const FamilyMembersState({
    required this.isLoading,
    required this.members,
    required this.familyId,
    this.family,
    this.lastInviteCode,
    this.isUsingCachedData = false,
    this.lastSuccessfulSyncAt,
    this.error,
  });

  final bool isLoading;
  final List<FamilyMemberDto> members;
  final int? familyId;
  final FamilyDto? family;
  final String? lastInviteCode;
  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
  final String? error;

  factory FamilyMembersState.initial({int? familyId}) {
    return FamilyMembersState(
      isLoading: familyId != null,
      members: const [],
      familyId: familyId,
    );
  }

  FamilyMembersState copyWith({
    bool? isLoading,
    List<FamilyMemberDto>? members,
    int? familyId,
    FamilyDto? family,
    String? lastInviteCode,
    bool? isUsingCachedData,
    DateTime? lastSuccessfulSyncAt,
    String? error,
    bool clearError = false,
    bool clearLastSuccessfulSyncAt = false,
  }) {
    return FamilyMembersState(
      isLoading: isLoading ?? this.isLoading,
      members: members ?? this.members,
      familyId: familyId ?? this.familyId,
      family: family ?? this.family,
      lastInviteCode: lastInviteCode ?? this.lastInviteCode,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      lastSuccessfulSyncAt: clearLastSuccessfulSyncAt
          ? null
          : (lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class FamilyMembersCubit extends Cubit<FamilyMembersState> {
  FamilyMembersCubit({
    required FamilyRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    required OfflineQueueManager offlineQueueManager,
    OfflineSnapshotStore? snapshotStore,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _offlineQueueManager = offlineQueueManager,
       _snapshotStore = snapshotStore,
       super(FamilyMembersState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
    if (_familySelectionCubit.state != null) {
      unawaited(_handleFamilyChanged(_familySelectionCubit.state));
    }
  }

  final FamilyRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final OfflineQueueManager _offlineQueueManager;
  final OfflineSnapshotStore? _snapshotStore;
  StreamSubscription<int?>? _familySub;
  static const _offlineFeature = 'family';
  static const _actionRenameFamily = 'rename_family';
  static const _actionTransferOwnership = 'transfer_ownership';
  static const _actionLeaveFamily = 'leave_family';

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset();
    if (familyId == null) {
      return;
    }
    await _restoreSnapshot(familyId);
    await _replayQueuedOperations();
    await loadMembers();
  }

  void reset() {
    emit(FamilyMembersState.initial(familyId: _familySelectionCubit.state));
  }

  Future<void> loadMembers() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(
        FamilyMembersState(
          isLoading: false,
          members: const [],
          familyId: null,
          family: null,
          lastInviteCode: state.lastInviteCode,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        familyId: familyId,
        clearError: true,
      ),
    );

    try {
      await _replayQueuedOperations();
      final family = await _repository.getFamily(familyId: familyId);
      final members = await _repository.listMembers(familyId: familyId);
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(
        familyId: familyId,
        family: family,
        members: members,
        lastInviteCode: state.lastInviteCode,
        syncedAt: syncedAt,
      );
      emit(
        state.copyWith(
          isLoading: false,
          members: members,
          familyId: familyId,
          family: family,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.loadMembers',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(
        state.copyWith(
          isLoading: false,
          isUsingCachedData:
              state.family != null || state.members.isNotEmpty,
          error: '$error',
        ),
      );
    }
  }

  Future<FamilyDto?> createFamily(String title) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final family = await _repository.createFamily(
        clientOperationId: OperationId.next(),
        title: title,
      );
      await _familySelectionCubit.setFamilyId(family.id);
      final members = await _repository.listMembers(familyId: family.id);
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(
        familyId: family.id,
        family: family,
        members: members,
        lastInviteCode: state.lastInviteCode,
        syncedAt: syncedAt,
      );
      emit(
        state.copyWith(
          isLoading: false,
          family: family,
          familyId: family.id,
          members: members,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
      return family;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.createFamily',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
      return null;
    }
  }

  Future<FamilyDto?> renameFamily(String title) async {
    final familyId = _familySelectionCubit.state;
    final normalizedTitle = title.trim();
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return null;
    }
    if (normalizedTitle.isEmpty) {
      emit(state.copyWith(error: 'Family name cannot be empty'));
      return null;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      final family = await _repository.renameFamily(
        familyId: familyId,
        clientOperationId: clientOperationId,
        title: normalizedTitle,
      );
      emit(
        state.copyWith(
          isLoading: false,
          family: family,
          familyId: family.id,
          isUsingCachedData: false,
          clearError: true,
        ),
      );
      await _writeSnapshot(
        familyId: family.id,
        family: family,
        members: state.members,
        lastInviteCode: state.lastInviteCode,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
      return family;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.renameFamily',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      if (isOfflineRecoverableError(error)) {
        await _offlineQueueManager.enqueue(
          OfflineOperation(
            id: OperationId.next(),
            feature: _offlineFeature,
            action: _actionRenameFamily,
            payload: {
              'familyId': familyId,
              'clientOperationId': clientOperationId,
              'title': normalizedTitle,
            },
            createdAt: DateTime.now().toUtc(),
            attempt: 0,
          ),
        );
        emit(
          state.copyWith(
            isLoading: false,
            family: state.family?.copyWith(title: normalizedTitle),
            isUsingCachedData: true,
            error: 'Network unavailable. Family rename queued.',
          ),
        );
        await _writeSnapshot(
          familyId: familyId,
          family: state.family?.copyWith(title: normalizedTitle),
          members: state.members,
          lastInviteCode: state.lastInviteCode,
          syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
        );
        return state.family?.copyWith(title: normalizedTitle);
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
      return null;
    }
  }

  Future<FamilyInviteDto?> createInvite({
    required String inviteType,
    String? email,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return null;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final invite = await _repository.createInvite(
        familyId: familyId,
        clientOperationId: OperationId.next(),
        inviteType: inviteType,
        email: email,
      );
      emit(
        state.copyWith(
          isLoading: false,
          lastInviteCode: invite.inviteCode,
          familyId: familyId,
          isUsingCachedData: false,
          clearError: true,
        ),
      );
      await _writeSnapshot(
        familyId: familyId,
        family: state.family,
        members: state.members,
        lastInviteCode: invite.inviteCode,
        syncedAt: state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
      return invite;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.createInvite',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'inviteType': inviteType,
          'hasEmail': email?.isNotEmpty ?? false,
        },
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
      return null;
    }
  }

  Future<void> acceptInvite(String tokenOrCode) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final member = await _repository.acceptInvite(
        clientOperationId: OperationId.next(),
        tokenOrCode: tokenOrCode,
      );
      await _familySelectionCubit.setFamilyId(member.familyId);
      final family = await _repository.getFamily(familyId: member.familyId);
      final members = await _repository.listMembers(familyId: member.familyId);
      final syncedAt = DateTime.now().toUtc();
      await _writeSnapshot(
        familyId: member.familyId,
        family: family,
        members: members,
        lastInviteCode: state.lastInviteCode,
        syncedAt: syncedAt,
      );
      emit(
        state.copyWith(
          isLoading: false,
          familyId: member.familyId,
          family: family,
          members: members,
          isUsingCachedData: false,
          lastSuccessfulSyncAt: syncedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.acceptInvite',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> transferOwnership({required int newOwnerProfileId}) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      await _repository.transferOwnership(
        familyId: familyId,
        clientOperationId: clientOperationId,
        newOwnerProfileId: newOwnerProfileId,
      );
      await loadMembers();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.transferOwnership',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'newOwnerProfileId': newOwnerProfileId,
        },
      );
      if (isOfflineRecoverableError(error)) {
        await _offlineQueueManager.enqueue(
          OfflineOperation(
            id: OperationId.next(),
            feature: _offlineFeature,
            action: _actionTransferOwnership,
            payload: {
              'familyId': familyId,
              'clientOperationId': clientOperationId,
              'newOwnerProfileId': newOwnerProfileId,
            },
            createdAt: DateTime.now().toUtc(),
            attempt: 0,
          ),
        );
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Network unavailable. Transfer request queued.',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> leaveFamily() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));
    final clientOperationId = OperationId.next();
    try {
      await _repository.leaveFamily(
        familyId: familyId,
        clientOperationId: clientOperationId,
      );
      await _deleteSnapshot(familyId);
      await _familySelectionCubit.clear();
      emit(FamilyMembersState.initial(familyId: null));
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.leaveFamily',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      if (isOfflineRecoverableError(error)) {
        await _offlineQueueManager.enqueue(
          OfflineOperation(
            id: OperationId.next(),
            feature: _offlineFeature,
            action: _actionLeaveFamily,
            payload: {
              'familyId': familyId,
              'clientOperationId': clientOperationId,
            },
            createdAt: DateTime.now().toUtc(),
            attempt: 0,
          ),
        );
        await _familySelectionCubit.clear();
        await _deleteSnapshot(familyId);
        emit(
          FamilyMembersState.initial(
            familyId: null,
          ).copyWith(
            error: 'Network unavailable. Leave request queued.',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> _replayQueuedOperations() {
    return _offlineQueueManager.replayWhere(
      (operation) async {
        switch (operation.action) {
          case _actionRenameFamily:
            await _repository.renameFamily(
              familyId: operation.payload['familyId'] as int,
              clientOperationId:
                  operation.payload['clientOperationId'] as String,
              title: operation.payload['title'] as String,
            );
            return;
          case _actionTransferOwnership:
            await _repository.transferOwnership(
              familyId: operation.payload['familyId'] as int,
              clientOperationId:
                  operation.payload['clientOperationId'] as String,
              newOwnerProfileId: operation.payload['newOwnerProfileId'] as int,
            );
            return;
          case _actionLeaveFamily:
            await _repository.leaveFamily(
              familyId: operation.payload['familyId'] as int,
              clientOperationId:
                  operation.payload['clientOperationId'] as String,
            );
            return;
        }
      },
      canProcess: (operation) => operation.feature == _offlineFeature,
    );
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }

  Future<void> _restoreSnapshot(int familyId) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      final snapshot = await snapshotStore.read(_cacheKey(familyId));
      if (snapshot == null || isClosed) {
        return;
      }

      final familyPayload = snapshot.payload['family'];
      final members =
          (snapshot.payload['members'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(FamilyMemberDto.fromJson)
              .toList();
      emit(
        state.copyWith(
          isLoading: false,
          familyId: familyId,
          family: familyPayload is Map<String, dynamic>
              ? FamilyDto.fromJson(familyPayload)
              : null,
          members: members,
          lastInviteCode: snapshot.payload['lastInviteCode'] as String?,
          isUsingCachedData: true,
          lastSuccessfulSyncAt: snapshot.updatedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.restoreSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
    }
  }

  Future<void> _writeSnapshot({
    required int familyId,
    required FamilyDto? family,
    required List<FamilyMemberDto> members,
    required String? lastInviteCode,
    required DateTime syncedAt,
  }) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      await snapshotStore.write(_cacheKey(familyId), {
        'family': family?.toJson(),
        'members': members.map((member) => member.toJson()).toList(),
        'lastInviteCode': lastInviteCode,
      }, updatedAt: syncedAt);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.writeSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId, 'membersCount': members.length},
      );
    }
  }

  Future<void> _deleteSnapshot(int familyId) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      await snapshotStore.delete(_cacheKey(familyId));
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'family.deleteSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
    }
  }

  String _cacheKey(int familyId) => 'family/family/$familyId';
}
