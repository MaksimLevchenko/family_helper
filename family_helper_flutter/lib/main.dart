import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/auth/auth_session.dart';
import 'core/network/app_api_client.dart';
import 'core/offline/offline_queue_manager.dart';
import 'core/offline/offline_queue_providers.dart';
import 'core/realtime/realtime_provider.dart';
import 'core/realtime/realtime_subscription_manager.dart';
import 'core/sync/sync_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth_profile/data/profile_repository.dart';
import 'features/auth_profile/presentation/sign_in_screen.dart';
import 'features/auth_profile/providers/profile_provider.dart';
import 'features/calendar/data/calendar_repository.dart';
import 'features/calendar/providers/calendar_provider.dart';
import 'features/family_invites/data/family_repository.dart';
import 'features/family_invites/providers/family_provider.dart';
import 'features/home_overview/presentation/home_shell_screen.dart';
import 'features/lists/data/lists_repository.dart';
import 'features/lists/providers/lists_provider.dart';
import 'features/media/data/media_repository.dart';
import 'features/media/providers/media_provider.dart';
import 'features/money_goals/data/money_goals_repository.dart';
import 'features/money_goals/providers/money_goals_provider.dart';
import 'features/notifications/data/local_notification_service.dart';
import 'features/notifications/data/notifications_repository.dart';
import 'features/notifications/providers/notifications_provider.dart';
import 'features/privacy_security/data/privacy_repository.dart';
import 'features/privacy_security/providers/privacy_provider.dart';
import 'features/tasks/data/tasks_repository.dart';
import 'features/tasks/providers/tasks_provider.dart';
import 'ui_kit/loading_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = await AppApiClient.create();
  final offlineQueueManager = await createOfflineQueueManager();

  runApp(
    FamilyHelperApp(
      apiClient: apiClient,
      offlineQueueManager: offlineQueueManager,
    ),
  );
}

class FamilyHelperApp extends StatelessWidget {
  const FamilyHelperApp({
    super.key,
    required this.apiClient,
    required this.offlineQueueManager,
  });

  final AppApiClient apiClient;
  final OfflineQueueManager offlineQueueManager;

  @override
  Widget build(BuildContext context) {
    final familyRepository = FamilyRepository(apiClient);
    final calendarRepository = CalendarRepository(apiClient);
    final tasksRepository = TasksRepository(apiClient);
    final listsRepository = ListsRepository(apiClient);
    final moneyGoalsRepository = MoneyGoalsRepository(apiClient);
    final notificationsRepository = NotificationsRepository(apiClient);
    final mediaRepository = MediaRepository(apiClient);
    final privacyRepository = PrivacyRepository(apiClient);
    final profileRepository = ProfileRepository(apiClient);
    final realtimeManager = RealtimeSubscriptionManager(apiClient);
    final localNotificationService = LocalNotificationService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) {
            final cubit = AuthCubit(apiClient);
            cubit.bootstrap();
            return cubit;
          },
        ),
        BlocProvider(create: (_) => FamilySelectionCubit()),
        BlocProvider(create: (_) => SyncCubit(apiClient)),
        BlocProvider(
          create: (context) => FamilyMembersCubit(
            repository: familyRepository,
            familySelectionCubit: context.read<FamilySelectionCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => CalendarCubit(
            repository: calendarRepository,
            familySelectionCubit: context.read<FamilySelectionCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => TasksCubit(
            repository: tasksRepository,
            familySelectionCubit: context.read<FamilySelectionCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => ListsCubit(
            repository: listsRepository,
            familySelectionCubit: context.read<FamilySelectionCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => MoneyGoalsCubit(
            repository: moneyGoalsRepository,
            familySelectionCubit: context.read<FamilySelectionCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => NotificationsCubit(
            repository: notificationsRepository,
            familySelectionCubit: context.read<FamilySelectionCubit>(),
            localNotificationService: localNotificationService,
          ),
        ),
        BlocProvider(
          create: (context) => MediaCubit(
            repository: mediaRepository,
            familySelectionCubit: context.read<FamilySelectionCubit>(),
          ),
        ),
        BlocProvider(
          create: (_) => PrivacyCubit(
            repository: privacyRepository,
          ),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(repository: profileRepository),
        ),
        BlocProvider(
          create: (context) => RealtimeCubit(
            manager: realtimeManager,
            familySelectionCubit: context.read<FamilySelectionCubit>(),
            syncCubit: context.read<SyncCubit>(),
            onInvalidation: (_) async {
              await Future.wait([
                context.read<TasksCubit>().reload(),
                context.read<CalendarCubit>().reload(),
                context.read<ListsCubit>().reload(),
                context.read<MoneyGoalsCubit>().reload(),
              ]);
            },
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Family Helper',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            home: BlocBuilder<AuthCubit, AuthSessionState>(
              builder: (context, authState) {
                if (authState.isInitializing) {
                  return const Scaffold(body: LoadingState());
                }
                if (!authState.isAuthenticated) {
                  return const SignInScreen();
                }
                return const HomeShellScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
