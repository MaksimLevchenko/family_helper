import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'package:family_helper_flutter/core/auth/auth_error_mapper.dart';

void main() {
  test('maps duplicate registration to explicit message', () {
    final message = AuthErrorMapper.toMessage(
      AuthRegistrationException(
        reason: AuthRegistrationExceptionReason.emailAlreadyRegistered,
      ),
    );

    expect(
      message,
      '\u042d\u0442\u043e\u0442 email \u0443\u0436\u0435 '
      '\u0437\u0430\u0440\u0435\u0433\u0438\u0441\u0442\u0440\u0438'
      '\u0440\u043e\u0432\u0430\u043d. \u0412\u043e\u0439\u0434\u0438'
      '\u0442\u0435 \u0438\u043b\u0438 \u0432\u043e\u0441\u0441\u0442'
      '\u0430\u043d\u043e\u0432\u0438\u0442\u0435 \u043f\u0430\u0440'
      '\u043e\u043b\u044c.',
    );
  });

  test('maps invalid login credentials from typed exception', () {
    final message = AuthErrorMapper.toMessage(
      EmailAccountLoginException(
        reason: EmailAccountLoginExceptionReason.invalidCredentials,
      ),
    );

    expect(message, 'Invalid email or password.');
  });
}
