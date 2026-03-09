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

abstract class TaskRow implements _i1.SerializableModel {
  TaskRow._({
    this.id,
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
    required this.createdByProfileId,
    this.completedAt,
    this.sourceTaskId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory TaskRow({
    int? id,
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
    required int createdByProfileId,
    DateTime? completedAt,
    int? sourceTaskId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _TaskRowImpl;

  factory TaskRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskRow(
      id: jsonSerialization['id'] as int?,
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
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      sourceTaskId: jsonSerialization['sourceTaskId'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

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

  int createdByProfileId;

  DateTime? completedAt;

  int? sourceTaskId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [TaskRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskRow copyWith({
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
    int? createdByProfileId,
    DateTime? completedAt,
    int? sourceTaskId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskRow',
      if (id != null) 'id': id,
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
      'createdByProfileId': createdByProfileId,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (sourceTaskId != null) 'sourceTaskId': sourceTaskId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskRowImpl extends TaskRow {
  _TaskRowImpl({
    int? id,
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
    required int createdByProfileId,
    DateTime? completedAt,
    int? sourceTaskId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
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
         createdByProfileId: createdByProfileId,
         completedAt: completedAt,
         sourceTaskId: sourceTaskId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [TaskRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskRow copyWith({
    Object? id = _Undefined,
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
    int? createdByProfileId,
    Object? completedAt = _Undefined,
    Object? sourceTaskId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return TaskRow(
      id: id is int? ? id : this.id,
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
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      sourceTaskId: sourceTaskId is int? ? sourceTaskId : this.sourceTaskId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
