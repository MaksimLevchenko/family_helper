import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth_profile/presentation/sign_in_screen.dart';
import '../../features/home_overview/presentation/home_shell_screen.dart';
import '../auth/auth_session.dart';

GoRouter createAppRouter(AuthCubit authCubit) {
  final refresh = _StreamRefreshNotifier(authCubit.stream);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: refresh,
    routes: [
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeShellScreen(),
      ),
    ],
    redirect: (context, state) {
      final auth = authCubit.state;
      if (auth.isInitializing) {
        return null;
      }

      final isAuthenticated = auth.isAuthenticated;
      final isSignIn = state.matchedLocation == '/sign-in';

      if (!isAuthenticated && !isSignIn) {
        return '/sign-in';
      }
      if (isAuthenticated && isSignIn) {
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
