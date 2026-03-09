import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/authenticated_scope.dart';
import '../../features/auth_profile/presentation/registration_flow_screens.dart';
import '../../features/auth_profile/presentation/sign_in_screen.dart';
import '../../features/auth_profile/presentation/profile_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/family_invites/presentation/family_screen.dart';
import '../../features/home_overview/presentation/home_shell_screen.dart';
import '../../features/home_overview/presentation/home_overview_screen.dart';
import '../../features/home_overview/presentation/settings_screen.dart';
import '../../features/lists/presentation/lists_screen.dart';
import '../../features/media/presentation/media_screen.dart';
import '../../features/money_goals/presentation/money_goals_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/privacy_security/presentation/privacy_security_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../ui_kit/loading_state.dart';
import '../auth/auth_session.dart';
import 'app_routes.dart';

GoRouter createAppRouter(AuthCubit authCubit) {
  final refresh = _StreamRefreshNotifier(authCubit.stream);

  return GoRouter(
    initialLocation: AppRoutes.loading,
    refreshListenable: refresh,
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) => const Scaffold(body: LoadingState()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerEmail,
        builder: (context, state) => const RegistrationEmailStepScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerCode,
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
        path: AppRoutes.registerPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          final token = state.uri.queryParameters['token'];
          return RegistrationPasswordStepScreen(
            email: email,
            registrationToken: token,
          );
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AuthenticatedScope(child: HomeShellScreen(child: child));
        },
        routes: [
          GoRoute(
            path: AppRoutes.overview,
            builder: (context, state) => const HomeOverviewScreen(),
          ),
          GoRoute(
            path: AppRoutes.calendar,
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: AppRoutes.tasks,
            builder: (context, state) => const TasksScreen(),
          ),
          GoRoute(
            path: AppRoutes.lists,
            builder: (context, state) => const ListsScreen(),
          ),
          GoRoute(
            path: AppRoutes.goals,
            builder: (context, state) => const MoneyGoalsScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
              GoRoute(
                path: 'family',
                builder: (context, state) => const FamilyScreen(),
              ),
              GoRoute(
                path: 'local-reminders',
                builder: (context, state) => const NotificationsScreen(),
              ),
              GoRoute(
                path: 'media',
                builder: (context, state) => const MediaScreen(),
              ),
              GoRoute(
                path: 'privacy',
                builder: (context, state) => const PrivacySecurityScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final auth = authCubit.state;
      final isLoading = state.matchedLocation == AppRoutes.loading;
      final isSignIn = state.matchedLocation == AppRoutes.signIn;
      final isRegistration = state.matchedLocation.startsWith('/register/');
      final isHome = state.matchedLocation.startsWith('/home');

      if (auth.isInitializing) {
        return isLoading ? null : AppRoutes.loading;
      }

      final isAuthenticated = auth.isAuthenticated;

      if (!isAuthenticated && !isSignIn && !isRegistration) {
        return AppRoutes.signIn;
      }
      if (isAuthenticated && (isSignIn || isLoading)) {
        return AppRoutes.overview;
      }
      if (!isAuthenticated && isLoading) {
        return AppRoutes.signIn;
      }
      if (isAuthenticated && !isHome) {
        return AppRoutes.overview;
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
