import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class TasksRepository {
  const TasksRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<List<TaskDto>> listTasks({required int familyId}) {
    return _apiClient.client.tasks.listTasks(familyId: familyId);
  }

  Future<List<TaskHistoryEntryDto>> listTaskHistory({
    required int familyId,
    required int taskId,
    int limit = 50,
  }) {
    return _apiClient.client.tasks.listTaskHistory(
      familyId: familyId,
      taskId: taskId,
      limit: limit,
    );
  }

  Future<TaskDto> upsertTask({
    required String clientOperationId,
    int? taskId,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    required String priority,
    DateTime? dueAt,
    String? dueInputMode,
    int? dueOffsetValue,
    String? dueOffsetUnit,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
  }) {
    return _apiClient.client.tasks.upsertTask(
      clientOperationId: clientOperationId,
      taskId: taskId,
      familyId: familyId,
      title: title,
      description: description,
      isPersonal: isPersonal,
      priority: priority,
      dueAt: dueAt,
      dueInputMode: dueInputMode,
      dueOffsetValue: dueOffsetValue,
      dueOffsetUnit: dueOffsetUnit,
      recurrenceMode: recurrenceMode,
      recurrenceRrule: recurrenceRrule,
      assigneeProfileId: assigneeProfileId,
    );
  }

  Future<TaskDto> completeTask({
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) {
    return _apiClient.client.tasks.completeTask(
      clientOperationId: clientOperationId,
      familyId: familyId,
      taskId: taskId,
    );
  }

  Future<OperationResult> deleteTask({
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) {
    return _apiClient.client.tasks.deleteTask(
      clientOperationId: clientOperationId,
      familyId: familyId,
      taskId: taskId,
    );
  }
}
