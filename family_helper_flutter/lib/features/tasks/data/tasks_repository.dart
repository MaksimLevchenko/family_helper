import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class TasksRepository {
  const TasksRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<List<TaskDto>> listTasks({required int familyId}) {
    return _apiClient.client.tasks.listTasks(familyId: familyId);
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
}
