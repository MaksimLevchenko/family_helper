import 'package:flutter_test/flutter_test.dart';

import 'package:family_helper_flutter/core/auth/auth_session.dart';
import 'package:family_helper_flutter/core/routing/app_router.dart';
import 'package:family_helper_flutter/core/routing/app_routes.dart';

void main() {
  test('keeps sign-in screen visible while auth request is in progress', () {
    final redirect = redirectForAuthState(
      const AuthSessionState(
        isInitializing: true,
        isAuthenticated: false,
      ),
      AppRoutes.signIn,
    );

    expect(redirect, isNull);
  });

  test('keeps registration flow visible while auth request is in progress', () {
    final redirect = redirectForAuthState(
      const AuthSessionState(
        isInitializing: true,
        isAuthenticated: false,
      ),
      AppRoutes.registerPassword,
    );

    expect(redirect, isNull);
  });

  test('redirects protected routes to loading during app bootstrap', () {
    final redirect = redirectForAuthState(
      const AuthSessionState(
        isInitializing: true,
        isAuthenticated: false,
      ),
      AppRoutes.overview,
    );

    expect(redirect, AppRoutes.loading);
  });
}
