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

Future<void> main() async {
  await runZonedGuarded(
    () async {
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

      await setupServiceLocator();
      runApp(const FamilyHelperApp());
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

class FamilyHelperApp extends StatefulWidget {
  const FamilyHelperApp({super.key});

  @override
  State<FamilyHelperApp> createState() => _FamilyHelperAppState();
}

class _FamilyHelperAppState extends State<FamilyHelperApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(getIt<AuthCubit>());
  }

  @override
  void dispose() {
    unawaited(resetServiceLocator());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
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
