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
      hasSelectedFamily: false,
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
      hasSelectedFamily: false,
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
      hasSelectedFamily: false,
    );

    expect(redirect, AppRoutes.loading);
  });

  test('redirects family routes to overview when no family is selected', () {
    final redirect = redirectForAuthState(
      const AuthSessionState(
        isInitializing: false,
        isAuthenticated: true,
      ),
      AppRoutes.calendar,
      hasSelectedFamily: false,
    );

    expect(redirect, AppRoutes.overview);
  });

  test('allows settings routes when no family is selected', () {
    final settingsRedirect = redirectForAuthState(
      const AuthSessionState(
        isInitializing: false,
        isAuthenticated: true,
      ),
      AppRoutes.settings,
      hasSelectedFamily: false,
    );
    final familyRedirect = redirectForAuthState(
      const AuthSessionState(
        isInitializing: false,
        isAuthenticated: true,
      ),
      AppRoutes.family,
      hasSelectedFamily: false,
    );

    expect(settingsRedirect, isNull);
    expect(familyRedirect, isNull);
  });

  test('allows family routes when a family is selected', () {
    final redirect = redirectForAuthState(
      const AuthSessionState(
        isInitializing: false,
        isAuthenticated: true,
      ),
      AppRoutes.goals,
      hasSelectedFamily: true,
    );

    expect(redirect, isNull);
  });
}
