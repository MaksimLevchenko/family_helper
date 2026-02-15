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

abstract class TaskDto implements _i1.SerializableModel {
  TaskDto._({
    required this.id,
    required this.familyId,
    required this.title,
    this.description,
    required this.isPersonal,
    required this.priority,
    required this.status,
    this.dueAt,
    this.recurrenceMode,
    this.recurrenceRrule,
    this.assigneeProfileId,
    this.completedAt,
    required this.updatedAt,
    required this.version,
  });

  factory TaskDto({
    required int id,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    required String priority,
    required String status,
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
    DateTime? completedAt,
    required DateTime updatedAt,
    required int version,
  }) = _TaskDtoImpl;

  factory TaskDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskDto(
      id: jsonSerialization['id'] as int,
      familyId: jsonSerialization['familyId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      isPersonal: jsonSerialization['isPersonal'] as bool,
      priority: jsonSerialization['priority'] as String,
      status: jsonSerialization['status'] as String,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      recurrenceMode: jsonSerialization['recurrenceMode'] as String?,
      recurrenceRrule: jsonSerialization['recurrenceRrule'] as String?,
      assigneeProfileId: jsonSerialization['assigneeProfileId'] as int?,
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  int id;

  int familyId;

  String title;

  String? description;

  bool isPersonal;

  String priority;

  String status;

  DateTime? dueAt;

  String? recurrenceMode;

  String? recurrenceRrule;

  int? assigneeProfileId;

  DateTime? completedAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [TaskDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskDto copyWith({
    int? id,
    int? familyId,
    String? title,
    String? description,
    bool? isPersonal,
    String? priority,
    String? status,
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
    DateTime? completedAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskDto',
      'id': id,
      'familyId': familyId,
      'title': title,
      if (description != null) 'description': description,
      'isPersonal': isPersonal,
      'priority': priority,
      'status': status,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      if (recurrenceMode != null) 'recurrenceMode': recurrenceMode,
      if (recurrenceRrule != null) 'recurrenceRrule': recurrenceRrule,
      if (assigneeProfileId != null) 'assigneeProfileId': assigneeProfileId,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskDtoImpl extends TaskDto {
  _TaskDtoImpl({
    required int id,
    required int familyId,
    required String title,
    String? description,
    required bool isPersonal,
    required String priority,
    required String status,
    DateTime? dueAt,
    String? recurrenceMode,
    String? recurrenceRrule,
    int? assigneeProfileId,
    DateTime? completedAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         title: title,
         description: description,
         isPersonal: isPersonal,
         priority: priority,
         status: status,
         dueAt: dueAt,
         recurrenceMode: recurrenceMode,
         recurrenceRrule: recurrenceRrule,
         assigneeProfileId: assigneeProfileId,
         completedAt: completedAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [TaskDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskDto copyWith({
    int? id,
    int? familyId,
    String? title,
    Object? description = _Undefined,
    bool? isPersonal,
    String? priority,
    String? status,
    Object? dueAt = _Undefined,
    Object? recurrenceMode = _Undefined,
    Object? recurrenceRrule = _Undefined,
    Object? assigneeProfileId = _Undefined,
    Object? completedAt = _Undefined,
    DateTime? updatedAt,
    int? version,
  }) {
    return TaskDto(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      isPersonal: isPersonal ?? this.isPersonal,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      recurrenceMode: recurrenceMode is String?
          ? recurrenceMode
          : this.recurrenceMode,
      recurrenceRrule: recurrenceRrule is String?
          ? recurrenceRrule
          : this.recurrenceRrule,
      assigneeProfileId: assigneeProfileId is int?
          ? assigneeProfileId
          : this.assigneeProfileId,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
