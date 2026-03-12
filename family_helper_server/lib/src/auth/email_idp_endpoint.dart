import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../core/security/security_event_service.dart';
import '../generated/protocol.dart';

class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  EmailIdpEndpoint({SecurityEventService? securityEventService})
    : securityEventService =
          securityEventService ?? const SecurityEventService();

  final SecurityEventService securityEventService;

  @override
  Future<UuidValue> startRegistration(
    Session session, {
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final existingAccount = await EmailAccount.db.findFirstRow(
      session,
      where: (t) => t.email.equals(normalizedEmail),
    );

    if (existingAccount != null) {
      throw AuthRegistrationException(
        reason: AuthRegistrationExceptionReason.emailAlreadyRegistered,
      );
    }

    return super.startRegistration(session, email: email);
  }

  @override
  Future<AuthSuccess> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    try {
      final auth = await super.login(
        session,
        email: email,
        password: password,
      );

      await securityEventService.append(
        session,
        authUserId: auth.authUserId.uuid,
        eventType: 'login.success',
        success: true,
        payload: {'emailHash': _emailFingerprint(session, email)},
      );

      return auth;
    } catch (error) {
      await securityEventService.append(
        session,
        authUserId: 'unknown',
        eventType: 'login.failed',
        success: false,
        payload: {
          'emailHash': _emailFingerprint(session, email),
          'errorType': error.runtimeType.toString(),
        },
      );
      rethrow;
    }
  }

  String _emailFingerprint(Session session, String email) {
    final normalizedEmail = email.trim().toLowerCase();
    final pepper =
        session.passwords['emailSecretHashPepper'] ??
        session.passwords['serviceSecret'] ??
        'missing-pepper';
    final digest = Hmac(
      sha256,
      utf8.encode(pepper),
    ).convert(utf8.encode(normalizedEmail));
    return digest.toString();
  }
}
