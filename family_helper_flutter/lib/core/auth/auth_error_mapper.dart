class AuthErrorMapper {
  const AuthErrorMapper._();

  static String toMessage(Object error) {
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
