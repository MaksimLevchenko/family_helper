import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/ui_error_localizer.dart';
import '../../../core/network/server_availability_cubit.dart';
import '../../../core/routing/app_routes.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../auth_profile/providers/profile_provider.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../providers/tasks_provider.dart';
import 'widgets/task_editor_sheet.dart';
import 'widgets/task_workspace_widgets.dart';

part 'tasks_screen_body.dart';
part 'tasks_screen_helpers.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskFilter _filter = TaskFilter.allOpen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileBloc = context.read<ProfileBloc>();
      if (profileBloc.state.profile == null) {
        profileBloc.add(const ProfileLoadRequested());
      }

      final familySelectionCubit = context.read<FamilySelectionCubit>();
      final familyMembersCubit = context.read<FamilyMembersCubit>();
      if (familySelectionCubit.state != null &&
          familyMembersCubit.state.members.isEmpty &&
          !familyMembersCubit.state.isLoading) {
        familyMembersCubit.loadMembers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOffline =
        context.watch<ServerAvailabilityCubit?>()?.state.isUnavailable ?? false;
    final tasksState = context.watch<TasksCubit>().state;
    final currentProfileId = context.watch<ProfileBloc>().state.profile?.id;
    final familyMembersState = context.watch<FamilyMembersCubit>().state;
    final notificationsState = context.watch<NotificationsCubit>().state;
    final visibleTasks = visibleTasksForFilter(
      tasksState,
      currentProfileId,
      _filter,
    );

    _ensureSelection(
      state: tasksState,
      visibleTasks: visibleTasks,
      mounted: mounted,
      onSelectTask: (taskId) {
        context.read<TasksCubit>().setCurrentTask(taskId);
      },
    );

    return Scaffold(
      appBar: serverStatusAppBar(context, title: Text(context.l10n.homeTasks)),
      body: tasksState.hasSelectedFamily
          ? _buildSelectedFamilyBody(
              context,
              tasksState: tasksState,
              notificationsState: notificationsState,
              familyMembersState: familyMembersState,
              currentProfileId: currentProfileId,
              isOffline: isOffline,
              currentFilter: _filter,
              onFilterChanged: (nextFilter) {
                setState(() {
                  _filter = nextFilter;
                });
              },
              onSelectTask: (taskId) {
                context.read<TasksCubit>().setCurrentTask(taskId);
              },
            )
          : SafeArea(
              child: NoFamilyTasksView(
                onOpenFamily: () {
                  context.go(AppRoutes.family);
                },
              ),
          ),
    );
  }
}
