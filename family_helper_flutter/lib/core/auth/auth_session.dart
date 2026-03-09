import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../logging/app_error_logger.dart';
import '../network/app_api_client.dart';

class AuthSessionState {
  const AuthSessionState({
    required this.isInitializing,
    required this.isAuthenticated,
    this.profile,
    this.error,
  });

  final bool isInitializing;
  final bool isAuthenticated;
  final ProfileDto? profile;
  final String? error;

  factory AuthSessionState.initial() {
    return const AuthSessionState(
      isInitializing: true,
      isAuthenticated: false,
    );
  }

  AuthSessionState copyWith({
    bool? isInitializing,
    bool? isAuthenticated,
    ProfileDto? profile,
    String? error,
    bool clearError = false,
  }) {
    return AuthSessionState(
      isInitializing: isInitializing ?? this.isInitializing,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      profile: profile ?? this.profile,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthCubit extends Cubit<AuthSessionState> {
  AuthCubit(this._apiClient) : super(AuthSessionState.initial());

  final AppApiClient _apiClient;
  void Function()? _removeAuthListener;
  bool _bootstrapped = false;

  Future<void> bootstrap() async {
    if (_bootstrapped) {
      return;
    }
    _bootstrapped = true;

    void onAuthChanged() {
      unawaited(_onAuthChanged());
    }

    _apiClient.client.auth.authInfoListenable.addListener(onAuthChanged);
    _removeAuthListener = () {
      _apiClient.client.auth.authInfoListenable.removeListener(onAuthChanged);
    };

    await _onAuthChanged();
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(isInitializing: true, clearError: true));
    try {
      final authSuccess = await _apiClient.client.emailIdp.login(
        email: email,
        password: password,
      );
      await _apiClient.client.auth.updateSignedInUser(authSuccess);
      await refreshProfile();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'auth.signIn',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        AuthSessionState(
          isInitializing: false,
          isAuthenticated: false,
          error: '$error',
        ),
      );
      rethrow;
    }
  }

  Future<UuidValue> startRegistration({required String email}) {
    return _apiClient.client.emailIdp.startRegistration(email: email);
  }

  Future<void> finishRegistration({
    required UuidValue accountRequestId,
    required String verificationCode,
    required String password,
  }) async {
    final registrationToken = await _apiClient.client.emailIdp
        .verifyRegistrationCode(
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
        );
    await finishRegistrationWithToken(
      registrationToken: registrationToken,
      password: password,
    );
  }

  Future<void> finishRegistrationWithToken({
    required String registrationToken,
    required String password,
  }) async {
    emit(state.copyWith(isInitializing: true, clearError: true));
    try {
      final authSuccess = await _apiClient.client.emailIdp.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );
      await _apiClient.client.auth.updateSignedInUser(authSuccess);
      await refreshProfile();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'auth.finishRegistrationWithToken',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        AuthSessionState(
          isInitializing: false,
          isAuthenticated: false,
          error: '$error',
        ),
      );
      rethrow;
    }
  }

  Future<String> verifyRegistrationCodeByRequestId({
    required String accountRequestId,
    required String verificationCode,
  }) {
    // ignore: experimental_member_use
    final requestId = UuidValue.fromString(accountRequestId);
    return _apiClient.client.emailIdp.verifyRegistrationCode(
      accountRequestId: requestId,
      verificationCode: verificationCode,
    );
  }

  Future<UuidValue> startPasswordReset({required String email}) {
    return _apiClient.client.emailIdp.startPasswordReset(email: email);
  }

  Future<void> finishPasswordReset({
    required UuidValue passwordResetRequestId,
    required String verificationCode,
    required String newPassword,
  }) async {
    final finishToken = await _apiClient.client.emailIdp
        .verifyPasswordResetCode(
          passwordResetRequestId: passwordResetRequestId,
          verificationCode: verificationCode,
        );
    await _apiClient.client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: finishToken,
      newPassword: newPassword,
    );
  }

  Future<void> signOut() async {
    await _apiClient.client.auth.signOutDevice();
    emit(
      const AuthSessionState(
        isInitializing: false,
        isAuthenticated: false,
      ),
    );
  }

  Future<void> refreshProfile() async {
    try {
      final profile = await _apiClient.client.profile.me();
      emit(
        AuthSessionState(
          isInitializing: false,
          isAuthenticated: true,
          profile: profile,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'auth.refreshProfile',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        AuthSessionState(
          isInitializing: false,
          isAuthenticated: false,
          error: '$error',
        ),
      );
    }
  }

  Future<void> _onAuthChanged() async {
    if (!_apiClient.client.auth.isAuthenticated) {
      emit(
        const AuthSessionState(
          isInitializing: false,
          isAuthenticated: false,
        ),
      );
      return;
    }

    await refreshProfile();
  }

  @override
  Future<void> close() async {
    _removeAuthListener?.call();
    return super.close();
  }
}
