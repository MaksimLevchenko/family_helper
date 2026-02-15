import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/tasks_service.dart';

class TasksEndpoint extends Endpoint {
  TasksEndpoint({TasksService? service}) : service = service ?? TasksService();

  final TasksService service;

  Future<TaskDto> upsertTask(
    Session session, {
    required String clientOperationId,
    int? taskId,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    String priority = 'normal',
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
  }) {
    return service.upsertTask(
      session,
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

  Future<List<TaskDto>> listTasks(
    Session session, {
    required int familyId,
  }) {
    return service.listTasks(session, familyId: familyId);
  }

  Future<TaskDto> completeTask(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) {
    return service.completeTask(
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      taskId: taskId,
    );
  }
}
