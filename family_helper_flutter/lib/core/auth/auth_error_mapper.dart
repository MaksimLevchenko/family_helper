import 'package:family_helper_client/family_helper_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

class AuthErrorMapper {
  const AuthErrorMapper._();

  static String toMessage(Object error) {
    if (error case AuthRegistrationException(
      reason: AuthRegistrationExceptionReason.emailAlreadyRegistered,
    )) {
      return '\u042d\u0442\u043e\u0442 email \u0443\u0436\u0435 '
          '\u0437\u0430\u0440\u0435\u0433\u0438\u0441\u0442\u0440\u0438'
          '\u0440\u043e\u0432\u0430\u043d. \u0412\u043e\u0439\u0434\u0438'
          '\u0442\u0435 \u0438\u043b\u0438 \u0432\u043e\u0441\u0441\u0442'
          '\u0430\u043d\u043e\u0432\u0438\u0442\u0435 \u043f\u0430\u0440'
          '\u043e\u043b\u044c.';
    }

    if (error case EmailAccountLoginException(
      reason: EmailAccountLoginExceptionReason.invalidCredentials,
    )) {
      return 'Invalid email or password.';
    }

    if (error case EmailAccountLoginException(
      reason: EmailAccountLoginExceptionReason.tooManyAttempts,
    )) {
      return 'Too many sign-in attempts. Try again later.';
    }

    if (error case EmailAccountRequestException(reason: final reason)) {
      switch (reason) {
        case EmailAccountRequestExceptionReason.invalid:
          return 'Verification code error. Check the code and try again.';
        case EmailAccountRequestExceptionReason.policyViolation:
          return 'Registration blocked by security policy. Check your data and try again.';
        case EmailAccountRequestExceptionReason.expired:
          return 'Verification code expired. Restart registration and try again.';
        case EmailAccountRequestExceptionReason.tooManyAttempts:
          return 'Too many verification attempts. Restart registration and try again.';
        case EmailAccountRequestExceptionReason.unknown:
          break;
      }
    }

    final raw = error.toString();
    final value = raw.toLowerCase();

    if (value.contains('policyviolation')) {
      return 'Registration blocked by security policy. Check your data and try again.';
    }
    if (value.contains('invalidverificationcode')) {
      return 'Invalid verification code.';
    }
    if (value.contains('verification code')) {
      return 'Verification code error. Check the code and try again.';
    }
    if (value.contains('usernotfound')) {
      return 'User not found.';
    }
    if (value.contains('invalidcredentials') ||
        value.contains('invalid credentials')) {
      return 'Invalid email or password.';
    }
    if (value.contains('network') || value.contains('socketexception')) {
      return 'Network error. Check your connection and retry.';
    }

    return raw;
  }
}
