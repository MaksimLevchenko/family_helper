class AuthInputValidator {
  const AuthInputValidator._();

  static const int minPasswordLength = 6;

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!_looksLikeEmail(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(
    String password, {
    String requiredMessage = 'Password is required',
  }) {
    if (password.isEmpty) {
      return requiredMessage;
    }
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }

  static bool _looksLikeEmail(String value) {
    final atIndex = value.indexOf('@');
    return atIndex > 0 && atIndex < value.length - 1;
  }
}
