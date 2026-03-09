import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth_profile/providers/profile_provider.dart';
import '../../features/calendar/providers/calendar_provider.dart';
import '../../features/family_invites/providers/family_provider.dart';
import '../../features/lists/providers/lists_provider.dart';
import '../../features/media/providers/media_provider.dart';
import '../../features/money_goals/providers/money_goals_provider.dart';
import '../../features/notifications/providers/notifications_provider.dart';
import '../../features/privacy_security/providers/privacy_provider.dart';
import '../../features/tasks/providers/tasks_provider.dart';
import '../realtime/realtime_provider.dart';
import '../sync/sync_controller.dart';
import 'service_locator.dart';

class AuthenticatedScope extends StatelessWidget {
  const AuthenticatedScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FamilySelectionCubit>.value(
          value: getIt<FamilySelectionCubit>(),
        ),
        BlocProvider<SyncCubit>.value(value: getIt<SyncCubit>()),
        BlocProvider<FamilyMembersCubit>.value(
          value: getIt<FamilyMembersCubit>(),
        ),
        BlocProvider<CalendarCubit>.value(value: getIt<CalendarCubit>()),
        BlocProvider<TasksCubit>.value(value: getIt<TasksCubit>()),
        BlocProvider<ListsCubit>.value(value: getIt<ListsCubit>()),
        BlocProvider<MoneyGoalsCubit>.value(value: getIt<MoneyGoalsCubit>()),
        BlocProvider<NotificationsCubit>.value(
          value: getIt<NotificationsCubit>(),
        ),
        BlocProvider<MediaCubit>.value(value: getIt<MediaCubit>()),
        BlocProvider<PrivacyCubit>.value(value: getIt<PrivacyCubit>()),
        BlocProvider<ProfileBloc>.value(value: getIt<ProfileBloc>()),
        BlocProvider<RealtimeCubit>.value(value: getIt<RealtimeCubit>()),
      ],
      child: child,
    );
  }
}
