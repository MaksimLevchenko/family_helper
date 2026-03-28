class AuthInputPolicy {
  const AuthInputPolicy._();

  static const int minPasswordLength = 6;

  static bool isValidEmail(String email) {
    final normalizedEmail = email.trim();
    final atIndex = normalizedEmail.indexOf('@');
    return normalizedEmail.isNotEmpty &&
        atIndex > 0 &&
        atIndex < normalizedEmail.length - 1;
  }

  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength;
  }
}
