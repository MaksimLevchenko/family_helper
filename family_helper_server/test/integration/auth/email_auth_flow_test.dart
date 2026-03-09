import 'dart:async';

import 'package:family_helper_server/src/auth/email_code_dispatcher.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

class _FakeEmailCodeSender implements EmailCodeSender {
  final Map<String, String> _registrationCodes = <String, String>{};
  final Map<String, String> _passwordResetCodes = <String, String>{};

  @override
  Future<void> sendCode({
    required String recipientEmail,
    required String verificationCode,
    required EmailCodeKind kind,
  }) async {
    switch (kind) {
      case EmailCodeKind.registration:
        _registrationCodes[recipientEmail] = verificationCode;
      case EmailCodeKind.passwordReset:
        _passwordResetCodes[recipientEmail] = verificationCode;
    }
  }

  String? registrationCode(String email) => _registrationCodes[email];

  String? passwordResetCode(String email) => _passwordResetCodes[email];
}

Future<String> _waitForCode(Future<String?> Function() readCode) async {
  for (var i = 0; i < 40; i++) {
    final code = await readCode();
    if (code != null && code.isNotEmpty) {
      return code;
    }
    await Future<void>.delayed(const Duration(milliseconds: 25));
  }
  throw StateError('Verification code was not delivered to fake sender');
}

Future<void> _initializeAuthServices(TestSessionBuilder sessionBuilder) async {
  final session = sessionBuilder.build();
  try {
    session.server.serverpod.initializeAuthServices(
      tokenManagerBuilders: [
        JwtConfigFromPasswords(),
      ],
      identityProviderBuilders: [
        EmailIdpConfigFromPasswords(
          sendRegistrationVerificationCode:
              (
                session, {
                required String email,
                required UuidValue accountRequestId,
                required String verificationCode,
                required Transaction? transaction,
              }) {
                EmailCodeDispatcher.instance.sendRegistrationCode(
                  session,
                  email: email,
                  verificationCode: verificationCode,
                );
              },
          sendPasswordResetVerificationCode:
              (
                session, {
                required String email,
                required UuidValue passwordResetRequestId,
                required String verificationCode,
                required Transaction? transaction,
              }) {
                EmailCodeDispatcher.instance.sendPasswordResetCode(
                  session,
                  email: email,
                  verificationCode: verificationCode,
                );
              },
        ),
      ],
    );
  } finally {
    await session.close();
  }
}

void main() {
  withServerpod(
    'Email auth flow',
    (sessionBuilder, endpoints) {
      test(
        'registration and password reset use injected sender and complete',
        () async {
          final fakeSender = _FakeEmailCodeSender();
          final previousDispatcher = EmailCodeDispatcher.instance;
          EmailCodeDispatcher.instance = EmailCodeDispatcher(
            sender: fakeSender,
          );
          addTearDown(() {
            EmailCodeDispatcher.instance = previousDispatcher;
          });
          await _initializeAuthServices(sessionBuilder);

          final email =
              'e2e_${DateTime.now().microsecondsSinceEpoch}@family-helper.test';

          final accountRequestId = await endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: email,
          );
          final registrationCode = await _waitForCode(
            () async => fakeSender.registrationCode(email),
          );
          final registrationToken = await endpoints.emailIdp
              .verifyRegistrationCode(
                sessionBuilder,
                accountRequestId: accountRequestId,
                verificationCode: registrationCode,
              );
          await endpoints.emailIdp.finishRegistration(
            sessionBuilder,
            registrationToken: registrationToken,
            password: 'Password123!',
          );

          final resetRequestId = await endpoints.emailIdp.startPasswordReset(
            sessionBuilder,
            email: email,
          );
          final resetCode = await _waitForCode(
            () async => fakeSender.passwordResetCode(email),
          );
          final resetToken = await endpoints.emailIdp.verifyPasswordResetCode(
            sessionBuilder,
            passwordResetRequestId: resetRequestId,
            verificationCode: resetCode,
          );
          await endpoints.emailIdp.finishPasswordReset(
            sessionBuilder,
            finishPasswordResetToken: resetToken,
            newPassword: 'Password456!',
          );

          final auth = await endpoints.emailIdp.login(
            sessionBuilder,
            email: email,
            password: 'Password456!',
          );
          expect(auth.token, isNotEmpty);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
