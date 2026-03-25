import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/auth/auth_session.dart';
import 'core/di/service_locator.dart';
import 'core/logging/app_error_logger.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/family_invites/providers/family_provider.dart';
import 'ui_kit/startup_loading_screen.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        AppErrorLogger.logUnhandled(
          scope: 'flutter.framework',
          error: details.exception,
          stackTrace: details.stack ?? StackTrace.current,
          context: {
            'library': details.library,
            'context': details.context?.toDescription(),
          },
        );
      };

      PlatformDispatcher.instance.onError = (error, stackTrace) {
        AppErrorLogger.logUnhandled(
          scope: 'flutter.platformDispatcher',
          error: error,
          stackTrace: stackTrace,
        );
        return false;
      };

      runApp(const FamilyHelperBootstrapApp());
    },
    (error, stackTrace) {
      AppErrorLogger.logUnhandled(
        scope: 'dart.zone',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

class FamilyHelperBootstrapApp extends StatefulWidget {
  const FamilyHelperBootstrapApp({super.key});

  @override
  State<FamilyHelperBootstrapApp> createState() =>
      _FamilyHelperBootstrapAppState();
}

class _FamilyHelperBootstrapAppState extends State<FamilyHelperBootstrapApp> {
  late final Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await setupServiceLocator();
    } catch (error, stackTrace) {
      AppErrorLogger.logUnhandled(
        scope: 'app.bootstrap',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _BootstrapShell(
            child: StartupLoadingScreen(
              title: 'Family Helper',
              message: 'Unable to start the app.',
              isLoading: false,
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const _BootstrapShell(
            child: StartupLoadingScreen(
              title: 'Family Helper',
              message: 'Preparing your space...',
            ),
          );
        }
        return const FamilyHelperApp();
      },
    );
  }
}

class _BootstrapShell extends StatelessWidget {
  const _BootstrapShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Helper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      onGenerateInitialRoutes: (initialRoute) {
        return [
          MaterialPageRoute<void>(
            builder: (context) => child,
            settings: RouteSettings(name: initialRoute),
          ),
        ];
      },
    );
  }
}

class FamilyHelperApp extends StatefulWidget {
  const FamilyHelperApp({super.key});

  @override
  State<FamilyHelperApp> createState() => _FamilyHelperAppState();
}

class _FamilyHelperAppState extends State<FamilyHelperApp> {
  late final GoRouter _router;
  late final FamilySelectionCubit _familySelectionCubit;

  @override
  void initState() {
    super.initState();
    _familySelectionCubit = FamilySelectionCubit();
    _familySelectionCubit.bootstrap();
    _router = createAppRouter(getIt<AuthCubit>(), _familySelectionCubit);
  }

  @override
  void dispose() {
    unawaited(_familySelectionCubit.close());
    unawaited(resetServiceLocator());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
        BlocProvider<FamilySelectionCubit>.value(value: _familySelectionCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Family Helper',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
