import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/authenticated_scope.dart';
import '../../features/auth_profile/presentation/registration_flow_screens.dart';
import '../../features/auth_profile/presentation/sign_in_screen.dart';
import '../../features/home_overview/presentation/home_shell_screen.dart';
import '../../ui_kit/loading_state.dart';
import '../auth/auth_session.dart';

GoRouter createAppRouter(AuthCubit authCubit) {
  final refresh = _StreamRefreshNotifier(authCubit.stream);

  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: refresh,
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => const Scaffold(body: LoadingState()),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/register/email',
        builder: (context, state) => const RegistrationEmailStepScreen(),
      ),
      GoRoute(
        path: '/register/code',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          final requestId = state.uri.queryParameters['requestId'];
          return RegistrationCodeStepScreen(
            email: email,
            requestId: requestId,
          );
        },
      ),
      GoRoute(
        path: '/register/password',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          final token = state.uri.queryParameters['token'];
          return RegistrationPasswordStepScreen(
            email: email,
            registrationToken: token,
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            const AuthenticatedScope(child: HomeShellScreen()),
      ),
    ],
    redirect: (context, state) {
      final auth = authCubit.state;
      final isLoading = state.matchedLocation == '/loading';
      final isSignIn = state.matchedLocation == '/sign-in';
      final isRegistration = state.matchedLocation.startsWith('/register/');
      final isHome = state.matchedLocation == '/home';

      if (auth.isInitializing) {
        return isLoading ? null : '/loading';
      }

      final isAuthenticated = auth.isAuthenticated;

      if (!isAuthenticated && !isSignIn && !isRegistration) {
        return '/sign-in';
      }
      if (isAuthenticated && (isSignIn || isLoading)) {
        return '/home';
      }
      if (!isAuthenticated && isLoading) {
        return '/sign-in';
      }
      if (isAuthenticated && !isHome) {
        return '/home';
      }
      return null;
    },
  );
}

class _StreamRefreshNotifier extends ChangeNotifier {
  _StreamRefreshNotifier(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
