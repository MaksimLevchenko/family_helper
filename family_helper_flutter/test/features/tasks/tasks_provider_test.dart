import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/offline/in_memory_offline_snapshot_store.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:family_helper_flutter/features/tasks/data/tasks_repository.dart';
import 'package:family_helper_flutter/features/tasks/providers/tasks_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestFamilySelectionCubit extends FamilySelectionCubit {
  _TestFamilySelectionCubit(int? initialFamilyId) : super() {
    emit(initialFamilyId);
  }

  void setFamily(int? familyId) {
    emit(familyId);
  }

  @override
  Future<void> bootstrap() async {}
}

class _FakeTasksRepository implements TasksRepository {
  final Map<int, List<TaskDto>> _tasksByFamily = {};
  final Map<int, List<TaskHistoryEntryDto>> _historyByTask = {};
  final List<int> historyRequests = [];

  void seedFamily(int familyId, List<TaskDto> tasks) {
    _tasksByFamily[familyId] = tasks.map((task) => task.copyWith()).toList();
  }

  void seedHistory(int taskId, List<TaskHistoryEntryDto> history) {
    _historyByTask[taskId] = history.map((entry) => entry.copyWith()).toList();
  }

  @override
  Future<TaskDto> completeTask({
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) async {
    final tasks = _tasksByFamily[familyId] ?? <TaskDto>[];
    final index = tasks.indexWhere((task) => task.id == taskId);
    final updated = tasks[index].copyWith(
      status: 'completed',
      completedAt: DateTime.utc(2026, 3, 26, 12),
      updatedAt: DateTime.utc(2026, 3, 26, 12),
    );
    tasks[index] = updated;
    _historyByTask[taskId] = [
      TaskHistoryEntryDto(
        id: 1000 + taskId,
        taskId: taskId,
        profileId: 7,
        actorDisplayName: 'Alex',
        eventType: 'completed',
        details: 'Task completed',
        createdAt: DateTime.utc(2026, 3, 26, 12),
      ),
    ];
    return updated;
  }

  @override
  Future<List<TaskHistoryEntryDto>> listTaskHistory({
    required int familyId,
    required int taskId,
    int limit = 50,
  }) async {
    historyRequests.add(taskId);
    return (_historyByTask[taskId] ?? const [])
        .take(limit)
        .map((entry) => entry.copyWith())
        .toList();
  }

  @override
  Future<List<TaskDto>> listTasks({required int familyId}) async {
    return (_tasksByFamily[familyId] ?? const [])
        .map((task) => task.copyWith())
        .toList();
  }

  @override
  Future<TaskDto> upsertTask({
    required String clientOperationId,
    int? taskId,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    required String priority,
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
  }) async {
    final tasks = _tasksByFamily.putIfAbsent(familyId, () => []);
    final existingIndex = taskId == null
        ? -1
        : tasks.indexWhere((task) => task.id == taskId);
    final nextTask = TaskDto(
      id:
          taskId ??
          (tasks.isEmpty
              ? 1
              : tasks.map((task) => task.id).reduce((a, b) => a > b ? a : b) +
                    1),
      familyId: familyId,
      title: title,
      description: description,
      isPersonal: isPersonal,
      priority: priority,
      status: 'open',
      dueAt: dueAt,
      recurrenceMode: recurrenceMode,
      recurrenceRrule: recurrenceRrule,
      assigneeProfileId: assigneeProfileId,
      updatedAt: DateTime.utc(2026, 3, 26, 11),
      version: 1,
    );
    if (existingIndex == -1) {
      tasks.add(nextTask);
    } else {
      tasks[existingIndex] = nextTask;
    }
    _historyByTask[nextTask.id] = [
      TaskHistoryEntryDto(
        id: 2000 + nextTask.id,
        taskId: nextTask.id,
        profileId: 7,
        actorDisplayName: 'Alex',
        eventType: taskId == null ? 'created' : 'updated',
        details: taskId == null ? 'Task created' : 'Task updated',
        createdAt: DateTime.utc(2026, 3, 26, 11),
      ),
    ];
    return nextTask;
  }
}

Future<void> _flushAsync() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  test(
    'family change resets selection/history and reloads task data',
    () async {
      final familySelectionCubit = _TestFamilySelectionCubit(1);
      final repository = _FakeTasksRepository()
        ..seedFamily(1, [_task(id: 1, title: 'Family one task')])
        ..seedHistory(1, [_history(id: 1, taskId: 1, eventType: 'created')])
        ..seedFamily(2, [_task(id: 2, title: 'Family two task')])
        ..seedHistory(2, [_history(id: 2, taskId: 2, eventType: 'updated')]);

      final cubit = TasksCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
        snapshotStore: InMemoryOfflineSnapshotStore(),
      );
      addTearDown(cubit.close);

      await _flushAsync();
      expect(cubit.state.currentTaskId, 1);
      expect(cubit.state.history.single.taskId, 1);

      familySelectionCubit.setFamily(2);
      await _flushAsync();

      expect(cubit.state.hasSelectedFamily, isTrue);
      expect(cubit.state.currentTaskId, 2);
      expect(cubit.state.tasks.single.title, 'Family two task');
      expect(cubit.state.history.single.taskId, 2);
    },
  );

  test('setCurrentTask lazily loads history for selected task', () async {
    final familySelectionCubit = _TestFamilySelectionCubit(42);
    final repository = _FakeTasksRepository()
      ..seedFamily(42, [
        _task(id: 1, title: 'First task'),
        _task(id: 2, title: 'Second task'),
      ])
      ..seedHistory(1, [_history(id: 1, taskId: 1, eventType: 'created')])
      ..seedHistory(2, [_history(id: 2, taskId: 2, eventType: 'updated')]);

    final cubit = TasksCubit(
      repository: repository,
      familySelectionCubit: familySelectionCubit,
    );
    addTearDown(cubit.close);

    await _flushAsync();
    expect(repository.historyRequests, contains(1));

    cubit.setCurrentTask(2);
    await _flushAsync();

    expect(cubit.state.currentTaskId, 2);
    expect(cubit.state.history.single.taskId, 2);
    expect(repository.historyRequests.last, 2);
  });

  test(
    'complete moves the selected task from open tasks into archive',
    () async {
      final familySelectionCubit = _TestFamilySelectionCubit(42);
      final repository = _FakeTasksRepository()
        ..seedFamily(42, [_task(id: 1, title: 'Finish dishes')])
        ..seedHistory(1, [_history(id: 1, taskId: 1, eventType: 'created')]);

      final cubit = TasksCubit(
        repository: repository,
        familySelectionCubit: familySelectionCubit,
      );
      addTearDown(cubit.close);

      await _flushAsync();
      await cubit.complete(cubit.state.tasks.single);
      await _flushAsync();

      expect(cubit.state.openTasks, isEmpty);
      expect(cubit.state.completedTasks.single.id, 1);
      expect(cubit.state.completedTasks.single.status, 'completed');
      expect(cubit.state.history.single.eventType, 'completed');
    },
  );
}

TaskDto _task({
  required int id,
  required String title,
}) {
  return TaskDto(
    id: id,
    familyId: 42,
    title: title,
    description: null,
    isPersonal: false,
    priority: 'normal',
    status: 'open',
    updatedAt: DateTime.utc(2026, 3, 26, 8, id),
    version: 1,
  );
}

TaskHistoryEntryDto _history({
  required int id,
  required int taskId,
  required String eventType,
}) {
  return TaskHistoryEntryDto(
    id: id,
    taskId: taskId,
    profileId: 7,
    actorDisplayName: 'Alex',
    eventType: eventType,
    details: 'History event',
    createdAt: DateTime.utc(2026, 3, 26, 9, id),
  );
}
