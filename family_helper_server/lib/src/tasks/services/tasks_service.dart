import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';
import '../../notifications/services/app_notification_service.dart';

part 'tasks_service_crud.dart';
part 'tasks_service_helpers.dart';

class TasksService {
  TasksService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
    AppNotificationService? appNotifications,
  }) : appNotifications = appNotifications ?? AppNotificationService();

  final AuthContext authContext;
  final ClockService clock;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;
  final AppNotificationService appNotifications;

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
    String? dueInputMode,
    int? dueOffsetValue,
    String? dueOffsetUnit,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
  }) {
    return _upsertTaskImpl(
      this,
      session,
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

  Future<List<TaskDto>> listTasks(
    Session session, {
    required int familyId,
  }) {
    return _listTasksImpl(this, session, familyId: familyId);
  }

  Future<List<TaskHistoryEntryDto>> listTaskHistory(
    Session session, {
    required int familyId,
    required int taskId,
    int limit = 50,
  }) {
    return _listTaskHistoryImpl(
      this,
      session,
      familyId: familyId,
      taskId: taskId,
      limit: limit,
    );
  }

  Future<TaskDto> completeTask(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) {
    return _completeTaskImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      taskId: taskId,
    );
  }

  Future<OperationResult> deleteTask(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int taskId,
  }) {
    return _deleteTaskImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      taskId: taskId,
    );
  }
}
