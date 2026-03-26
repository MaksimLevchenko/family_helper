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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class TaskHistoryEntryDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TaskHistoryEntryDto._({
    required this.id,
    required this.taskId,
    required this.profileId,
    required this.actorDisplayName,
    required this.eventType,
    required this.details,
    required this.createdAt,
  });

  factory TaskHistoryEntryDto({
    required int id,
    required int taskId,
    required int profileId,
    required String actorDisplayName,
    required String eventType,
    required String details,
    required DateTime createdAt,
  }) = _TaskHistoryEntryDtoImpl;

  factory TaskHistoryEntryDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskHistoryEntryDto(
      id: jsonSerialization['id'] as int,
      taskId: jsonSerialization['taskId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      actorDisplayName: jsonSerialization['actorDisplayName'] as String,
      eventType: jsonSerialization['eventType'] as String,
      details: jsonSerialization['details'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int taskId;

  int profileId;

  String actorDisplayName;

  String eventType;

  String details;

  DateTime createdAt;

  /// Returns a shallow copy of this [TaskHistoryEntryDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskHistoryEntryDto copyWith({
    int? id,
    int? taskId,
    int? profileId,
    String? actorDisplayName,
    String? eventType,
    String? details,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskHistoryEntryDto',
      'id': id,
      'taskId': taskId,
      'profileId': profileId,
      'actorDisplayName': actorDisplayName,
      'eventType': eventType,
      'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskHistoryEntryDto',
      'id': id,
      'taskId': taskId,
      'profileId': profileId,
      'actorDisplayName': actorDisplayName,
      'eventType': eventType,
      'details': details,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TaskHistoryEntryDtoImpl extends TaskHistoryEntryDto {
  _TaskHistoryEntryDtoImpl({
    required int id,
    required int taskId,
    required int profileId,
    required String actorDisplayName,
    required String eventType,
    required String details,
    required DateTime createdAt,
  }) : super._(
         id: id,
         taskId: taskId,
         profileId: profileId,
         actorDisplayName: actorDisplayName,
         eventType: eventType,
         details: details,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TaskHistoryEntryDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskHistoryEntryDto copyWith({
    int? id,
    int? taskId,
    int? profileId,
    String? actorDisplayName,
    String? eventType,
    String? details,
    DateTime? createdAt,
  }) {
    return TaskHistoryEntryDto(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      profileId: profileId ?? this.profileId,
      actorDisplayName: actorDisplayName ?? this.actorDisplayName,
      eventType: eventType ?? this.eventType,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
