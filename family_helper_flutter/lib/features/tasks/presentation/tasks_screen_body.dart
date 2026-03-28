part of 'tasks_screen.dart';

Widget _buildSelectedFamilyBody(
  BuildContext context, {
  required TasksState tasksState,
  required NotificationsState notificationsState,
  required FamilyMembersState familyMembersState,
  required int? currentProfileId,
  required bool isOffline,
  required TaskFilter currentFilter,
  required ValueChanged<TaskFilter> onFilterChanged,
  required ValueChanged<int?> onSelectTask,
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
          final isWide = constraints.maxWidth >= 720.0;
          final visibleTasks = visibleTasksForFilter(
            tasksState,
            currentProfileId,
            currentFilter,
          );
          final selectedTask = resolvedSelectedTask(tasksState, visibleTasks);

          void handleFilterChanged(TaskFilter filter) {
            onFilterChanged(filter);
            final filtered = visibleTasksForFilter(
              tasksState,
              currentProfileId,
              filter,
            );
            onSelectTask(filtered.isEmpty ? null : filtered.first.id);
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
                    currentFilter: currentFilter,
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
                            currentFilter: currentFilter,
                            selectedTaskId: selectedTask?.id,
                            members: familyMembersState.members,
                            currentProfileId: currentProfileId,
                            isCompletingTask: tasksState.isCompletingTask,
                            isOffline: isOffline,
                            isEmbedded: false,
                            onSelectTask: (taskId) {
                              onSelectTask(taskId);
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
                currentFilter: currentFilter,
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
                currentFilter: currentFilter,
                selectedTaskId: selectedTask?.id,
                members: familyMembersState.members,
                currentProfileId: currentProfileId,
                isCompletingTask: tasksState.isCompletingTask,
                isOffline: isOffline,
                isEmbedded: true,
                onSelectTask: (taskId) {
                  onSelectTask(taskId);
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
