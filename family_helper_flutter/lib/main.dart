import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/auth/auth_session.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/l10n.dart';
import 'core/l10n/locale_controller.dart';
import 'core/l10n/locale_sync_service.dart';
import 'core/logging/app_error_logger.dart';
import 'core/network/server_availability_cubit.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/family_invites/data/family_repository.dart';
import 'features/family_invites/providers/family_provider.dart';
import 'l10n/app_localizations.dart';
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

class _FamilyHelperAppState extends State<FamilyHelperApp>
    with WidgetsBindingObserver {
  late final GoRouter _router;
  late final FamilySelectionCubit _familySelectionCubit;
  late final ServerAvailabilityCubit _serverAvailabilityCubit;
  late final LocaleCubit _localeCubit;
  late final LocaleSyncService _localeSyncService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _familySelectionCubit = FamilySelectionCubit(
      repository: getIt<FamilyRepository>(),
      authCubit: getIt<AuthCubit>(),
    );
    _familySelectionCubit.bootstrap();
    _serverAvailabilityCubit = getIt<ServerAvailabilityCubit>();
    _serverAvailabilityCubit.start();
    _localeCubit = getIt<LocaleCubit>();
    _localeCubit.updateSystemLocales(PlatformDispatcher.instance.locales);
    _localeSyncService = LocaleSyncService(
      localeCubit: _localeCubit,
      authCubit: getIt<AuthCubit>(),
      profileRepository: getIt(),
    )..start();
    _router = createAppRouter(getIt<AuthCubit>(), _familySelectionCubit);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_familySelectionCubit.close());
    unawaited(_localeSyncService.dispose());
    unawaited(resetServiceLocator());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_serverAvailabilityCubit.refresh());
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    _localeCubit.updateSystemLocales(locales ?? PlatformDispatcher.instance.locales);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>.value(value: _localeCubit),
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
        BlocProvider<FamilySelectionCubit>.value(value: _familySelectionCubit),
        BlocProvider<ServerAvailabilityCubit>.value(
          value: _serverAvailabilityCubit,
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final localeState = context.watch<LocaleCubit>().state;
          return MaterialApp.router(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            locale: localeState.effectiveLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
