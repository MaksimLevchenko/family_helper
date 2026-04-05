/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../tasks/models/task_row.dart' as _i2;
import '../../core/models/app_profile_row.dart' as _i3;
import 'package:family_helper_client/src/protocol/protocol.dart' as _i4;

abstract class TaskHistoryRow implements _i1.SerializableModel {
  TaskHistoryRow._({
    this.id,
    required this.taskId,
    this.task,
    required this.actorProfileId,
    this.actorProfile,
    required this.eventType,
    this.details,
    required this.createdAt,
  });

  factory TaskHistoryRow({
    int? id,
    required int taskId,
    _i2.TaskRow? task,
    required int actorProfileId,
    _i3.AppProfileRow? actorProfile,
    required String eventType,
    String? details,
    required DateTime createdAt,
  }) = _TaskHistoryRowImpl;

  factory TaskHistoryRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskHistoryRow(
      id: jsonSerialization['id'] as int?,
      taskId: jsonSerialization['taskId'] as int,
      task: jsonSerialization['task'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.TaskRow>(jsonSerialization['task']),
      actorProfileId: jsonSerialization['actorProfileId'] as int,
      actorProfile: jsonSerialization['actorProfile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['actorProfile'],
            ),
      eventType: jsonSerialization['eventType'] as String,
      details: jsonSerialization['details'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int taskId;

  _i2.TaskRow? task;

  int actorProfileId;

  _i3.AppProfileRow? actorProfile;

  String eventType;

  String? details;

  DateTime createdAt;

  /// Returns a shallow copy of this [TaskHistoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskHistoryRow copyWith({
    int? id,
    int? taskId,
    _i2.TaskRow? task,
    int? actorProfileId,
    _i3.AppProfileRow? actorProfile,
    String? eventType,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskHistoryRow',
      if (id != null) 'id': id,
      'taskId': taskId,
      if (task != null) 'task': task?.toJson(),
      'actorProfileId': actorProfileId,
      if (actorProfile != null) 'actorProfile': actorProfile?.toJson(),
      'eventType': eventType,
      if (details != null) 'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskHistoryRowImpl extends TaskHistoryRow {
  _TaskHistoryRowImpl({
    int? id,
    required int taskId,
    _i2.TaskRow? task,
    required int actorProfileId,
    _i3.AppProfileRow? actorProfile,
    required String eventType,
    String? details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         taskId: taskId,
         task: task,
         actorProfileId: actorProfileId,
         actorProfile: actorProfile,
         eventType: eventType,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TaskHistoryRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskHistoryRow copyWith({
    Object? id = _Undefined,
    int? taskId,
    Object? task = _Undefined,
    int? actorProfileId,
    Object? actorProfile = _Undefined,
    String? eventType,
    Object? details = _Undefined,
    DateTime? createdAt,
  }) {
    return TaskHistoryRow(
      id: id is int? ? id : this.id,
      taskId: taskId ?? this.taskId,
      task: task is _i2.TaskRow? ? task : this.task?.copyWith(),
      actorProfileId: actorProfileId ?? this.actorProfileId,
      actorProfile: actorProfile is _i3.AppProfileRow?
          ? actorProfile
          : this.actorProfile?.copyWith(),
      eventType: eventType ?? this.eventType,
      details: details is String? ? details : this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
