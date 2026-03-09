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
import '../realtime/realtime_feature_flags.dart';
import '../auth/auth_session.dart';
import '../realtime/realtime_provider.dart';
import '../sync/sync_controller.dart';
import 'service_locator.dart';

class AuthenticatedScope extends StatefulWidget {
  const AuthenticatedScope({super.key, required this.child});

  final Widget child;

  @override
  State<AuthenticatedScope> createState() => _AuthenticatedScopeState();
}

class _AuthenticatedScopeState extends State<AuthenticatedScope> {
  late final FamilySelectionCubit _familySelectionCubit;
  late final SyncCubit _syncCubit;
  late final FamilyMembersCubit _familyMembersCubit;
  late final CalendarCubit _calendarCubit;
  late final TasksCubit _tasksCubit;
  late final ListsCubit _listsCubit;
  late final MoneyGoalsCubit _moneyGoalsCubit;
  late final NotificationsCubit _notificationsCubit;
  late final MediaCubit _mediaCubit;
  late final PrivacyCubit _privacyCubit;
  late final ProfileBloc _profileBloc;
  late final RealtimeCubit _realtimeCubit;

  @override
  void initState() {
    super.initState();
    _familySelectionCubit = FamilySelectionCubit();
    _syncCubit = SyncCubit(getIt());
    _familyMembersCubit = FamilyMembersCubit(
      repository: getIt(),
      familySelectionCubit: _familySelectionCubit,
      offlineQueueManager: getIt(),
    );
    _calendarCubit = CalendarCubit(
      repository: getIt(),
      familySelectionCubit: _familySelectionCubit,
      authCubit: getIt<AuthCubit>(),
    );
    _tasksCubit = TasksCubit(
      repository: getIt(),
      familySelectionCubit: _familySelectionCubit,
    );
    _listsCubit = ListsCubit(
      repository: getIt(),
      familySelectionCubit: _familySelectionCubit,
    );
    _moneyGoalsCubit = MoneyGoalsCubit(
      repository: getIt(),
      familySelectionCubit: _familySelectionCubit,
    );
    _notificationsCubit = NotificationsCubit(
      repository: getIt(),
      familySelectionCubit: _familySelectionCubit,
      localNotificationService: getIt(),
      offlineQueueManager: getIt(),
    );
    _mediaCubit = MediaCubit(
      repository: getIt(),
      familySelectionCubit: _familySelectionCubit,
      offlineQueueManager: getIt(),
    );
    _privacyCubit = PrivacyCubit(
      repository: getIt(),
      offlineQueueManager: getIt(),
    );
    _profileBloc = ProfileBloc(repository: getIt());
    _realtimeCubit = RealtimeCubit(
      manager: getIt(),
      familySelectionCubit: _familySelectionCubit,
      syncFamily: (familyId) => _syncCubit.sync(familyId: familyId),
      onInvalidation: (features) async {
        final reloads = <Future<void>>[];
        if (features.contains('tasks')) {
          reloads.add(_tasksCubit.reload());
        }
        if (features.contains('calendar')) {
          reloads.add(_calendarCubit.reload());
        }
        if (features.contains('lists')) {
          reloads.add(_listsCubit.reload());
        }
        if (features.any(isMoneyGoalsFeature)) {
          reloads.add(_moneyGoalsCubit.reload());
        }
        if (features.contains('notifications')) {
          reloads.add(_notificationsCubit.reloadReminders());
        }
        if (reloads.isEmpty) {
          return;
        }
        await Future.wait(reloads);
      },
    );

    _familySelectionCubit.bootstrap();
  }

  @override
  void dispose() {
    _realtimeCubit.close();
    _profileBloc.close();
    _privacyCubit.close();
    _mediaCubit.close();
    _notificationsCubit.close();
    _moneyGoalsCubit.close();
    _listsCubit.close();
    _tasksCubit.close();
    _calendarCubit.close();
    _familyMembersCubit.close();
    _syncCubit.close();
    _familySelectionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FamilySelectionCubit>.value(
          value: _familySelectionCubit,
        ),
        BlocProvider<SyncCubit>.value(value: _syncCubit),
        BlocProvider<FamilyMembersCubit>.value(
          value: _familyMembersCubit,
        ),
        BlocProvider<CalendarCubit>.value(value: _calendarCubit),
        BlocProvider<TasksCubit>.value(value: _tasksCubit),
        BlocProvider<ListsCubit>.value(value: _listsCubit),
        BlocProvider<MoneyGoalsCubit>.value(value: _moneyGoalsCubit),
        BlocProvider<NotificationsCubit>.value(
          value: _notificationsCubit,
        ),
        BlocProvider<MediaCubit>.value(value: _mediaCubit),
        BlocProvider<PrivacyCubit>.value(value: _privacyCubit),
        BlocProvider<ProfileBloc>.value(value: _profileBloc),
        BlocProvider<RealtimeCubit>.value(value: _realtimeCubit),
      ],
      child: widget.child,
    );
  }
}
