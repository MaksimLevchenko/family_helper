import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/utils/operation_id.dart';
import '../data/family_repository.dart';

const _familyIdStorageKey = 'current_family_id';

class FamilySelectionCubit extends Cubit<int?> {
  FamilySelectionCubit() : super(null);

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _bootstrapped = false;

  Future<void> bootstrap() async {
    if (_bootstrapped) {
      return;
    }
    _bootstrapped = true;
    await _restore();
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
}

class FamilyMembersState {
  const FamilyMembersState({
    required this.isLoading,
    required this.members,
    required this.familyId,
    this.lastInviteCode,
    this.error,
  });

  final bool isLoading;
  final List<FamilyMemberDto> members;
  final int? familyId;
  final String? lastInviteCode;
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
    String? lastInviteCode,
    String? error,
    bool clearError = false,
  }) {
    return FamilyMembersState(
      isLoading: isLoading ?? this.isLoading,
      members: members ?? this.members,
      familyId: familyId ?? this.familyId,
      lastInviteCode: lastInviteCode ?? this.lastInviteCode,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class FamilyMembersCubit extends Cubit<FamilyMembersState> {
  FamilyMembersCubit({
    required FamilyRepository repository,
    required FamilySelectionCubit familySelectionCubit,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       super(FamilyMembersState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
  }

  final FamilyRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  StreamSubscription<int?>? _familySub;

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset();
    if (familyId == null) {
      return;
    }
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
      final members = await _repository.listMembers(familyId: familyId);
      emit(
        state.copyWith(
          isLoading: false,
          members: members,
          familyId: familyId,
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
      emit(state.copyWith(isLoading: false, error: '$error'));
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
      emit(
        state.copyWith(
          isLoading: false,
          familyId: family.id,
          members: members,
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
          clearError: true,
        ),
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
      final members = await _repository.listMembers(familyId: member.familyId);
      emit(
        state.copyWith(
          isLoading: false,
          familyId: member.familyId,
          members: members,
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

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
