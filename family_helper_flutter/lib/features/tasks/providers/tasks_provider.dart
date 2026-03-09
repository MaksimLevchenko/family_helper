import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../core/utils/operation_id.dart';
import '../../family_invites/providers/family_provider.dart';
import '../data/tasks_repository.dart';

class TasksState {
  const TasksState({
    required this.isLoading,
    required this.tasks,
    this.error,
  });

  final bool isLoading;
  final List<TaskDto> tasks;
  final String? error;

  factory TasksState.initial() {
    return const TasksState(isLoading: false, tasks: []);
  }

  TasksState copyWith({
    bool? isLoading,
    List<TaskDto>? tasks,
    String? error,
    bool clearError = false,
  }) {
    return TasksState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({
    required TasksRepository repository,
    required FamilySelectionCubit familySelectionCubit,
  }) : _repository = repository,
       _familySelectionCubit = familySelectionCubit,
       super(TasksState.initial()) {
    _familySub = _familySelectionCubit.stream.listen((_) {
      unawaited(reload());
    });
    unawaited(reload());
  }

  final TasksRepository _repository;
  final FamilySelectionCubit _familySelectionCubit;
  StreamSubscription<int?>? _familySub;

  Future<void> reload() async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(const TasksState(isLoading: false, tasks: []));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final tasks = await _repository.listTasks(familyId: familyId);
      emit(
        state.copyWith(
          isLoading: false,
          tasks: tasks,
          clearError: true,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.reload',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> createTask({
    required String title,
    required bool isPersonal,
    DateTime? dueAt,
    bool recurringOnComplete = false,
  }) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _repository.upsertTask(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        title: title,
        isPersonal: isPersonal,
        priority: 'normal',
        dueAt: dueAt,
        recurrenceMode: recurringOnComplete ? 'generateOnComplete' : null,
        recurrenceRrule: recurringOnComplete ? 'FREQ=DAILY;INTERVAL=1' : null,
      );

      await reload();
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'tasks.createTask',
        error: error,
        stackTrace: stackTrace,
        context: {'familyId': familyId},
      );
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  Future<void> complete(TaskDto task) async {
    final familyId = _familySelectionCubit.state;
    if (familyId == null) {
      emit(state.copyWith(error: 'Family is not selected'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _repository.completeTask(
        clientOperationId: OperationId.next(),
        familyId: familyId,
        taskId: task.id,
      );

      await reload();
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
      emit(state.copyWith(isLoading: false, error: '$error'));
    }
  }

  @override
  Future<void> close() async {
    await _familySub?.cancel();
    return super.close();
  }
}
