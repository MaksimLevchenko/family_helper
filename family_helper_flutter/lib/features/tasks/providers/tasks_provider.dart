import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/offline/offline_snapshot_store.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/tasks_repository.dart';
import '../domain/task_form.dart';

class TasksState {
  const TasksState({
    required this.hasSelectedFamily,
    required this.isInitialLoading,
    required this.isSavingTask,
    required this.isCompletingTask,
    required this.isDeletingTask,
    required this.isHistoryLoading,
    required this.isReminderSyncing,
    required this.tasks,
    required this.history,
    this.currentTaskId,
    this.isUsingCachedData = false,
    this.lastSuccessfulSyncAt,
    this.error,
  });

  final bool hasSelectedFamily;
  final bool isInitialLoading;
  final bool isSavingTask;
  final bool isCompletingTask;
  final bool isDeletingTask;
  final bool isHistoryLoading;
  final bool isReminderSyncing;
  final List<TaskDto> tasks;
  final List<TaskHistoryEntryDto> history;
  final int? currentTaskId;
  final bool isUsingCachedData;
  final DateTime? lastSuccessfulSyncAt;
  final String? error;

  factory TasksState.initial({bool hasSelectedFamily = false}) {
    return TasksState(
      hasSelectedFamily: hasSelectedFamily,
      isInitialLoading: hasSelectedFamily,
      isSavingTask: false,
      isCompletingTask: false,
      isDeletingTask: false,
      isHistoryLoading: false,
      isReminderSyncing: false,
      tasks: const [],
      history: const [],
    );
  }

  TasksState copyWith({
    bool? hasSelectedFamily,
    bool? isInitialLoading,
    bool? isSavingTask,
    bool? isCompletingTask,
    bool? isDeletingTask,
    bool? isHistoryLoading,
    bool? isReminderSyncing,
    List<TaskDto>? tasks,
    List<TaskHistoryEntryDto>? history,
    Object? currentTaskId = _unset,
    bool? isUsingCachedData,
    DateTime? lastSuccessfulSyncAt,
    Object? error = _unset,
    bool clearError = false,
    bool clearLastSuccessfulSyncAt = false,
  }) {
    return TasksState(
      hasSelectedFamily: hasSelectedFamily ?? this.hasSelectedFamily,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isSavingTask: isSavingTask ?? this.isSavingTask,
      isCompletingTask: isCompletingTask ?? this.isCompletingTask,
      isDeletingTask: isDeletingTask ?? this.isDeletingTask,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      isReminderSyncing: isReminderSyncing ?? this.isReminderSyncing,
      tasks: tasks ?? this.tasks,
      history: history ?? this.history,
      currentTaskId: currentTaskId == _unset
          ? this.currentTaskId
          : currentTaskId as int?,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      lastSuccessfulSyncAt: clearLastSuccessfulSyncAt
          ? null
          : (lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt),
      error: clearError
          ? null
          : (error == _unset ? this.error : error as String?),
    );
  }

  List<TaskDto> get openTasks {
    return tasks.where((task) => task.status != 'completed').toList();
  }

  List<TaskDto> get completedTasks {
    return tasks.where((task) => task.status == 'completed').toList();
  }

  TaskDto? get selectedTask {
    final taskId = currentTaskId;
    if (taskId == null) {
      return null;
    }

    for (final task in tasks) {
      if (task.id == taskId) {
        return task;
      }
    }
    return null;
  }
}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required TasksRepository repository,
    required FamilySelectionCubit familySelectionCubit,
    OfflineSnapshotStore? snapshotStore,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       _snapshotStore = snapshotStore,
       super(
         TasksState.initial(
           hasSelectedFamily: familySelectionCubit.state != null,
         ),
       ) {
    _familySub = _familySelectionCubit.stream.listen((familyId) {
      unawaited(_handleFamilyChanged(familyId));
    });
    if (_familySelectionCubit.state != null) {
      unawaited(_handleFamilyChanged(_familySelectionCubit.state));
    }
  }

  final TasksRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  final OfflineSnapshotStore? _snapshotStore;
  StreamSubscription<int?>? _familySub;
  int _historyRequestId = 0;

  Future<void> _handleFamilyChanged(int? familyId) async {
    reset(hasSelectedFamily: familyId != null);
    if (familyId == null) {
      return;
    }
    await _restoreSnapshot(familyId);
    await reload();
  }

  void reset({bool hasSelectedFamily = false}) {
    emit(TasksState.initial(hasSelectedFamily: hasSelectedFamily));
  }

  void setCurrentTask(int? taskId) {
    if (taskId == state.currentTaskId) {
      return;
    }

    if (taskId == null) {
      ++_historyRequestId;
      emit(
        state.copyWith(
          currentTaskId: null,
          history: const [],
          isHistoryLoading: false,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        currentTaskId: taskId,
        history: const [],
        isHistoryLoading: true,
        clearError: true,
      ),
    );
    unawaited(_loadHistoryForTask(taskId));
  }

  void setReminderSyncing(bool value) {
    emit(state.copyWith(isReminderSyncing: value));
  }

  Future<void> reload() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(TasksState.initial());
      return;
    }

    emit(
      state.copyWith(
        hasSelectedFamily: true,
        isInitialLoading: state.tasks.isEmpty,
        clearError: true,
      ),
    );

    try {
      final tasks = await _repository.listTasks(familyId: familyId);
      final syncedAt = DateTime.now().toUtc();
      final nextState = _buildLoadedState(tasks).copyWith(
        isUsingCachedData: false,
        lastSuccessfulSyncAt: syncedAt,
      );
      await _writeSnapshot(familyId, nextState, syncedAt);
      emit(nextState);
      await _loadHistoryForTask(nextState.currentTaskId);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.reload',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(
        state.copyWith(
          isInitialLoading: false,
          isHistoryLoading: false,
          isUsingCachedData: state.tasks.isNotEmpty || state.history.isNotEmpty,
          error: '$error',
        ),
      );
    }
  }

  Future<TaskDto?> saveTask(
    TaskForm form, {
    int? taskId,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return null;
    }

    emit(
      state.copyWith(
        hasSelectedFamily: true,
        isSavingTask: true,
        clearError: true,
      ),
    );

    try {
      final task = await _repository.upsertTask(
        clientOperationId: OperationId.next(),
        taskId: taskId,
        familyId: familyId,
        title: form.title.trim(),
        description: form.normalizedDescription,
        isPersonal: form.isPersonal,
        priority: form.priorityValue,
        dueAt: form.dueAt,
        dueInputMode: form.dueInputModeValue,
        dueOffsetValue: form.normalizedDueOffsetValue,
        dueOffsetUnit: form.dueOffsetUnitValue,
        recurrenceMode: form.recurrenceMode,
        recurrenceRrule: form.recurrenceRrule,
        assigneeProfileId: form.isPersonal ? null : form.assigneeProfileId,
      );

      final tasks = await _repository.listTasks(familyId: familyId);
      final syncedAt = DateTime.now().toUtc();
      final nextState =
          _buildLoadedState(
            tasks,
            preferredTaskId: task.id,
          ).copyWith(
            isUsingCachedData: false,
            lastSuccessfulSyncAt: syncedAt,
          );
      await _writeSnapshot(familyId, nextState, syncedAt);
      emit(nextState);
      await _loadHistoryForTask(nextState.currentTaskId);
      return task;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.saveTask',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'taskId': taskId,
        },
      );
      emit(
        state.copyWith(
          isSavingTask: false,
          error: '$error',
        ),
      );
      return null;
    }
  }

  Future<TaskDto?> createTask({
    required String title,
    required bool isPersonal,
    DateTime? dueAt,
    bool recurringOnComplete = false,
  }) {
    return saveTask(
      TaskForm.create().copyWith(
        title: title,
        isPersonal: isPersonal,
        dueInputMode: dueAt == null
            ? TaskDueInputMode.none
            : TaskDueInputMode.absolute,
        dueAt: dueAt,
        recurrencePreset: recurringOnComplete
            ? TaskRecurrencePreset.daily
            : TaskRecurrencePreset.none,
        recurrenceInterval: 1,
      ),
    );
  }

  Future<void> complete(TaskDto task) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(
      state.copyWith(
        hasSelectedFamily: true,
        isCompletingTask: true,
        clearError: true,
      ),
    );

    try {
      await _repository.completeTask(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        taskId: task.id,
      );

      final tasks = await _repository.listTasks(familyId: familyId);
      final syncedAt = DateTime.now().toUtc();
      final nextState =
          _buildLoadedState(
            tasks,
            preferredTaskId: task.id,
          ).copyWith(
            isUsingCachedData: false,
            lastSuccessfulSyncAt: syncedAt,
          );
      await _writeSnapshot(familyId, nextState, syncedAt);
      emit(nextState);
      await _loadHistoryForTask(nextState.currentTaskId);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.complete',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'taskId': task.id,
        },
      );
      emit(state.copyWith(isCompletingTask: false, error: '$error'));
    }
  }

  Future<bool> deleteCurrentTask() async {
    final familyId = _familySelectionCubit.state;
    final taskId = state.currentTaskId;
    if (familyId == null || taskId == null) {
      emit(state.copyWith(error: 'Family/task is not selected'));
      return false;
    }

    emit(
      state.copyWith(
        hasSelectedFamily: true,
        isDeletingTask: true,
        clearError: true,
      ),
    );

    try {
      await _repository.deleteTask(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        taskId: taskId,
      );

      final tasks = await _repository.listTasks(familyId: familyId);
      final syncedAt = DateTime.now().toUtc();
      final nextState =
          _buildLoadedState(
            tasks,
            preferredTaskId: tasks.any((task) => task.id == taskId)
                ? taskId
                : null,
          ).copyWith(
            isUsingCachedData: false,
            lastSuccessfulSyncAt: syncedAt,
          );
      await _writeSnapshot(familyId, nextState, syncedAt);
      emit(nextState);
      await _loadHistoryForTask(nextState.currentTaskId);
      return true;
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.deleteTask',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'taskId': taskId,
        },
      );
      emit(state.copyWith(isDeletingTask: false, error: '$error'));
      return false;
    }
  }

  TasksState _buildLoadedState(
    List<TaskDto> tasks, {
    int? preferredTaskId,
  }) {
    final selectedTaskId = _resolveCurrentTaskId(
      tasks,
      preferredTaskId: preferredTaskId,
    );

    return state.copyWith(
      hasSelectedFamily: true,
      isInitialLoading: false,
      isSavingTask: false,
      isCompletingTask: false,
      isDeletingTask: false,
      isHistoryLoading: selectedTaskId != null,
      tasks: tasks,
      history: selectedTaskId == state.currentTaskId ? state.history : const [],
      currentTaskId: selectedTaskId,
      clearError: true,
    );
  }

  int? _resolveCurrentTaskId(
    List<TaskDto> tasks, {
    int? preferredTaskId,
  }) {
    if (tasks.isEmpty) {
      return null;
    }

    if (preferredTaskId != null &&
        tasks.any((task) => task.id == preferredTaskId)) {
      return preferredTaskId;
    }

    final currentTaskId = state.currentTaskId;
    if (currentTaskId != null &&
        tasks.any((task) => task.id == currentTaskId)) {
      return currentTaskId;
    }

    for (final task in tasks) {
      if (task.status != 'completed') {
        return task.id;
      }
    }

    return tasks.first.id;
  }

  Future<void> _loadHistoryForTask(int? taskId) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null || taskId == null) {
      ++_historyRequestId;
      emit(
        state.copyWith(
          history: const [],
          isHistoryLoading: false,
        ),
      );
      return;
    }

    final requestId = ++_historyRequestId;
    if (state.currentTaskId != taskId) {
      emit(
        state.copyWith(
          currentTaskId: taskId,
          history: const [],
          isHistoryLoading: true,
          clearError: true,
        ),
      );
    } else if (!state.isHistoryLoading) {
      emit(
        state.copyWith(
          currentTaskId: taskId,
          isHistoryLoading: true,
          clearError: true,
        ),
      );
    }

    try {
      final history = await _repository.listTaskHistory(
        familyId: familyId,
        taskId: taskId,
      );
      if (isClosed ||
          requestId != _historyRequestId ||
          state.currentTaskId != taskId) {
        return;
      }

      emit(
        state.copyWith(
          history: history,
          isHistoryLoading: false,
          clearError: true,
        ),
      );
      await _writeSnapshot(
        familyId,
        state.copyWith(
          history: history,
          isHistoryLoading: false,
          isUsingCachedData: false,
        ),
        state.lastSuccessfulSyncAt ?? DateTime.now().toUtc(),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.listTaskHistory',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'taskId': taskId,
        },
      );
      if (isClosed ||
          requestId != _historyRequestId ||
          state.currentTaskId != taskId) {
        return;
      }

      emit(
        state.copyWith(
          isHistoryLoading: false,
          isUsingCachedData: state.tasks.isNotEmpty || state.history.isNotEmpty,
          error: '$error',
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }

  Future<void> _restoreSnapshot(int familyId) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      final snapshot = await snapshotStore.read(_cacheKey(familyId));
      if (snapshot == null || isClosed) {
        return;
      }

      final tasks = (snapshot.payload['tasks'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(TaskDto.fromJson)
          .toList();
      final history =
          (snapshot.payload['history'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map(TaskHistoryEntryDto.fromJson)
              .toList();
      emit(
        state.copyWith(
          hasSelectedFamily: true,
          isInitialLoading: false,
          tasks: tasks,
          history: history,
          currentTaskId: snapshot.payload['currentTaskId'] as int?,
          isHistoryLoading: false,
          isUsingCachedData: true,
          lastSuccessfulSyncAt: snapshot.updatedAt,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.restoreSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
    }
  }

  Future<void> _writeSnapshot(
    int familyId,
    TasksState snapshotState,
    DateTime syncedAt,
  ) async {
    final snapshotStore = _snapshotStore;
    if (snapshotStore == null) {
      return;
    }

    try {
      await snapshotStore.write(_cacheKey(familyId), {
        'currentTaskId': snapshotState.currentTaskId,
        'tasks': snapshotState.tasks.map((task) => task.toJson()).toList(),
        'history': snapshotState.history
            .map((entry) => entry.toJson())
            .toList(),
      }, updatedAt: syncedAt);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.writeSnapshot',
        error: error,
        stackTrace: stackTrace,
        context: {
          'familyId': familyId,
          'tasksCount': snapshotState.tasks.length,
          'historyCount': snapshotState.history.length,
        },
      );
    }
  }

  String _cacheKey(int familyId) => 'tasks/family/$familyId';
}

const _unset = Object();
