import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../core/security/security_event_service.dart';

class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  EmailIdpEndpoint({SecurityEventService? securityEventService})
    : securityEventService = securityEventService ?? const SecurityEventService();

  final SecurityEventService securityEventService;

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
        payload: {'emailHash': email.hashCode.toString()},
      );

      return auth;
    } catch (error) {
      await securityEventService.append(
        session,
        authUserId: 'unknown',
        eventType: 'login.failed',
        success: false,
        payload: {'emailHash': email.hashCode.toString(), 'error': '$error'},
      );
      rethrow;
    }
  }
}
