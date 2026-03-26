import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/server_availability_cubit.dart';
import '../../../core/routing/app_routes.dart';
import '../../../ui_kit/ui_kit.dart';
import '../../auth_profile/providers/profile_provider.dart';
import '../../family_invites/providers/family_provider.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../providers/tasks_provider.dart';
import 'widgets/task_editor_sheet.dart';
import 'widgets/task_workspace_widgets.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  static const _wideLayoutBreakpoint = 720.0;

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

    _ensureSelection(tasksState, visibleTasks);

    return Scaffold(
      appBar: serverStatusAppBar(context, title: const Text('Tasks')),
      body: tasksState.hasSelectedFamily
          ? _buildSelectedFamilyBody(
              context,
              tasksState: tasksState,
              notificationsState: notificationsState,
              familyMembersState: familyMembersState,
              currentProfileId: currentProfileId,
              isOffline: isOffline,
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

  Widget _buildSelectedFamilyBody(
    BuildContext context, {
    required TasksState tasksState,
    required NotificationsState notificationsState,
    required FamilyMembersState familyMembersState,
    required int? currentProfileId,
    required bool isOffline,
  }) {
    if (tasksState.isInitialLoading && tasksState.tasks.isEmpty) {
      return const SafeArea(
        child: LoadingState(label: 'Loading tasks...'),
      );
    }

    if (tasksState.error != null && tasksState.tasks.isEmpty) {
      return SafeArea(
        child: ErrorState(
          message: tasksState.error!,
          onRetry: () => context.read<TasksCubit>().reload(),
        ),
      );
    }

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _wideLayoutBreakpoint;
          final visibleTasks = visibleTasksForFilter(
            tasksState,
            currentProfileId,
            _filter,
          );
          final selectedTask = resolvedSelectedTask(tasksState, visibleTasks);

          void handleFilterChanged(TaskFilter filter) {
            setState(() {
              _filter = filter;
            });
            final filtered = visibleTasksForFilter(
              tasksState,
              currentProfileId,
              filter,
            );
            context.read<TasksCubit>().setCurrentTask(
              filtered.isEmpty ? null : filtered.first.id,
            );
          }

          if (isWide) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedDataStatus(
                    isUsingCachedData: tasksState.isUsingCachedData,
                    lastSuccessfulSyncAt: tasksState.lastSuccessfulSyncAt,
                  ),
                  if (tasksState.error != null) ...[
                    const SizedBox(height: 10),
                    AppBanner(text: tasksState.error!, isError: true),
                  ],
                  const SizedBox(height: 10),
                  TasksToolbar(
                    state: tasksState,
                    currentFilter: _filter,
                    onFilterChanged: handleFilterChanged,
                    onCreateTask: isOffline
                        ? null
                        : () {
                            showTaskEditor(
                              context,
                              isWide: true,
                              members: familyMembersState.members,
                              currentProfileId: currentProfileId,
                              notificationsState: notificationsState,
                              existingTask: null,
                            );
                          },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Row(
                      key: const Key('tasks-wide-layout'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 340,
                          child: TasksSidebar(
                            visibleTasks: visibleTasks,
                            currentFilter: _filter,
                            selectedTaskId: selectedTask?.id,
                            members: familyMembersState.members,
                            currentProfileId: currentProfileId,
                            isCompletingTask: tasksState.isCompletingTask,
                            isOffline: isOffline,
                            isEmbedded: false,
                            onSelectTask: (taskId) {
                              context.read<TasksCubit>().setCurrentTask(taskId);
                            },
                            onCompleteTask: (task) async {
                              await context.read<TasksCubit>().complete(task);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TaskDetailPane(
                            task: selectedTask,
                            history: tasksState.history,
                            isHistoryLoading: tasksState.isHistoryLoading,
                            isBusy:
                                tasksState.isSavingTask ||
                                tasksState.isCompletingTask ||
                                tasksState.isDeletingTask ||
                                tasksState.isReminderSyncing,
                            members: familyMembersState.members,
                            currentProfileId: currentProfileId,
                            isOffline: isOffline,
                            onEditTask:
                                selectedTask == null ||
                                    selectedTask.status == 'completed' ||
                                    isOffline
                                ? null
                                : () {
                                    showTaskEditor(
                                      context,
                                      isWide: true,
                                      members: familyMembersState.members,
                                      currentProfileId: currentProfileId,
                                      notificationsState: notificationsState,
                                      existingTask: selectedTask,
                                    );
                                  },
                            onCompleteTask:
                                selectedTask == null ||
                                    selectedTask.status == 'completed' ||
                                    isOffline
                                ? null
                                : () async {
                                    await context.read<TasksCubit>().complete(
                                      selectedTask,
                                    );
                                  },
                            onDeleteTask: selectedTask == null || isOffline
                                ? null
                                : () async {
                                    await _showDeleteTaskOverlay(
                                      context,
                                      selectedTask,
                                      isWide: true,
                                      isOffline: isOffline,
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            key: const Key('tasks-narrow-layout'),
            padding: const EdgeInsets.all(12),
            children: [
              CachedDataStatus(
                isUsingCachedData: tasksState.isUsingCachedData,
                lastSuccessfulSyncAt: tasksState.lastSuccessfulSyncAt,
              ),
              if (tasksState.error != null) ...[
                const SizedBox(height: 10),
                AppBanner(text: tasksState.error!, isError: true),
              ],
              const SizedBox(height: 10),
              TasksToolbar(
                state: tasksState,
                isCompact: true,
                currentFilter: _filter,
                onFilterChanged: handleFilterChanged,
                onCreateTask: isOffline
                    ? null
                    : () {
                        showTaskEditor(
                          context,
                          isWide: false,
                          members: familyMembersState.members,
                          currentProfileId: currentProfileId,
                          notificationsState: notificationsState,
                          existingTask: null,
                        );
                      },
              ),
              const SizedBox(height: 12),
              TasksSidebar(
                visibleTasks: visibleTasks,
                currentFilter: _filter,
                selectedTaskId: selectedTask?.id,
                members: familyMembersState.members,
                currentProfileId: currentProfileId,
                isCompletingTask: tasksState.isCompletingTask,
                isOffline: isOffline,
                isEmbedded: true,
                onSelectTask: (taskId) {
                  context.read<TasksCubit>().setCurrentTask(taskId);
                },
                onCompleteTask: (task) async {
                  await context.read<TasksCubit>().complete(task);
                },
              ),
              const SizedBox(height: 16),
              TaskDetailPane(
                task: selectedTask,
                history: tasksState.history,
                isHistoryLoading: tasksState.isHistoryLoading,
                isBusy:
                    tasksState.isSavingTask ||
                    tasksState.isCompletingTask ||
                    tasksState.isDeletingTask ||
                    tasksState.isReminderSyncing,
                members: familyMembersState.members,
                currentProfileId: currentProfileId,
                isOffline: isOffline,
                isEmbedded: true,
                onEditTask:
                    selectedTask == null ||
                        selectedTask.status == 'completed' ||
                        isOffline
                    ? null
                    : () {
                        showTaskEditor(
                          context,
                          isWide: false,
                          members: familyMembersState.members,
                          currentProfileId: currentProfileId,
                          notificationsState: notificationsState,
                          existingTask: selectedTask,
                        );
                      },
                onCompleteTask:
                    selectedTask == null ||
                        selectedTask.status == 'completed' ||
                        isOffline
                    ? null
                    : () async {
                        await context.read<TasksCubit>().complete(selectedTask);
                      },
                onDeleteTask: selectedTask == null || isOffline
                    ? null
                    : () async {
                        await _showDeleteTaskOverlay(
                          context,
                          selectedTask,
                          isWide: false,
                          isOffline: isOffline,
                        );
                      },
              ),
            ],
          );
        },
      ),
    );
  }

  void _ensureSelection(TasksState state, List<TaskDto> visibleTasks) {
    final selected = resolvedSelectedTask(state, visibleTasks);
    final nextTaskId = selected?.id;
    if (nextTaskId == state.currentTaskId) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<TasksCubit>().setCurrentTask(nextTaskId);
    });
  }

  Future<void> _showDeleteTaskOverlay(
    BuildContext context,
    TaskDto task, {
    required bool isWide,
    required bool isOffline,
  }) async {
    if (isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tasks are unavailable while offline.')),
      );
      return;
    }

    final cubit = context.read<TasksCubit>();
    final content = BlocProvider<TasksCubit>.value(
      value: cubit,
      child: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          return _TaskConfirmAction(
            title: 'Delete task',
            description:
                'Delete "${task.title}" permanently from active tasks and archive.',
            confirmLabel: 'Delete task',
            isLoading: state.isDeletingTask,
            confirmVariant: AppButtonVariant.danger,
            onConfirm: () => context.read<TasksCubit>().deleteCurrentTask(),
          );
        },
      ),
    );

    if (isWide) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: content,
              ),
            ),
          );
        },
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return AppModalSheet(
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: content,
        );
      },
    );
  }
}

class _TaskConfirmAction extends StatelessWidget {
  const _TaskConfirmAction({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.isLoading,
    required this.onConfirm,
    this.confirmVariant = AppButtonVariant.primary,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final bool isLoading;
  final Future<bool> Function() onConfirm;
  final AppButtonVariant confirmVariant;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        AppButton(
          key: const Key('task-delete-confirm-button'),
          label: confirmLabel,
          variant: confirmVariant,
          isLoading: isLoading,
          onPressed: isLoading
              ? null
              : () async {
                  final didConfirm = await onConfirm();
                  if (!context.mounted || !didConfirm) {
                    return;
                  }
                  Navigator.of(context).pop();
                },
        ),
      ],
    );
  }
}
