import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../../features/auth_profile/providers/profile_provider.dart';
import '../../../features/calendar/providers/calendar_provider.dart';
import '../../../features/family_invites/providers/family_provider.dart';
import '../../../features/lists/providers/lists_provider.dart';
import '../../../features/media/providers/media_provider.dart';
import '../../../features/money_goals/providers/money_goals_provider.dart';
import '../../../features/notifications/providers/notifications_provider.dart';
import '../../../features/privacy_security/providers/privacy_provider.dart';
import '../../../features/tasks/providers/tasks_provider.dart';
import '../../auth/auth_session.dart';
import '../../realtime/realtime_provider.dart';
import '../../sync/sync_controller.dart';
import '../../theme/theme_controller.dart';

void registerGlobalState(GetIt getIt) {
  getIt.registerSingleton<ThemeCubit>(
    ThemeCubit(),
    dispose: (cubit) => cubit.close(),
  );

  final authCubit = AuthCubit(getIt());
  getIt.registerSingleton<AuthCubit>(
    authCubit,
    dispose: (cubit) => cubit.close(),
  );

  getIt.registerSingleton<FamilySelectionCubit>(
    FamilySelectionCubit(),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<SyncCubit>(
    SyncCubit(getIt()),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<FamilyMembersCubit>(
    FamilyMembersCubit(
      repository: getIt(),
      familySelectionCubit: getIt(),
    ),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<CalendarCubit>(
    CalendarCubit(
      repository: getIt(),
      familySelectionCubit: getIt(),
    ),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<TasksCubit>(
    TasksCubit(
      repository: getIt(),
      familySelectionCubit: getIt(),
    ),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<ListsCubit>(
    ListsCubit(
      repository: getIt(),
      familySelectionCubit: getIt(),
    ),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<MoneyGoalsCubit>(
    MoneyGoalsCubit(
      repository: getIt(),
      familySelectionCubit: getIt(),
    ),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<NotificationsCubit>(
    NotificationsCubit(
      repository: getIt(),
      familySelectionCubit: getIt(),
      localNotificationService: getIt(),
    ),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<MediaCubit>(
    MediaCubit(
      repository: getIt(),
      familySelectionCubit: getIt(),
    ),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<PrivacyCubit>(
    PrivacyCubit(
      repository: getIt(),
    ),
    dispose: (cubit) => cubit.close(),
  );
  getIt.registerSingleton<ProfileBloc>(
    ProfileBloc(repository: getIt()),
    dispose: (bloc) => bloc.close(),
  );
  getIt.registerSingleton<RealtimeCubit>(
    RealtimeCubit(
      manager: getIt(),
      familySelectionCubit: getIt(),
      syncCubit: getIt(),
      onInvalidation: (_) async {
        await Future.wait([
          getIt<TasksCubit>().reload(),
          getIt<CalendarCubit>().reload(),
          getIt<ListsCubit>().reload(),
          getIt<MoneyGoalsCubit>().reload(),
        ]);
      },
    ),
    dispose: (cubit) => cubit.close(),
  );

  unawaited(authCubit.bootstrap());
}
