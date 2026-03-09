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

abstract class AuditLogRow implements _i1.SerializableModel {
  AuditLogRow._({
    this.id,
    this.familyId,
    required this.actorProfileId,
    required this.action,
    required this.payloadJson,
    required this.createdAt,
  });

  factory AuditLogRow({
    int? id,
    int? familyId,
    required int actorProfileId,
    required String action,
    required String payloadJson,
    required DateTime createdAt,
  }) = _AuditLogRowImpl;

  factory AuditLogRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLogRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int?,
      actorProfileId: jsonSerialization['actorProfileId'] as int,
      action: jsonSerialization['action'] as String,
      payloadJson: jsonSerialization['payloadJson'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? familyId;

  int actorProfileId;

  String action;

  String payloadJson;

  DateTime createdAt;

  /// Returns a shallow copy of this [AuditLogRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuditLogRow copyWith({
    int? id,
    int? familyId,
    int? actorProfileId,
    String? action,
    String? payloadJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLogRow',
      if (id != null) 'id': id,
      if (familyId != null) 'familyId': familyId,
      'actorProfileId': actorProfileId,
      'action': action,
      'payloadJson': payloadJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogRowImpl extends AuditLogRow {
  _AuditLogRowImpl({
    int? id,
    int? familyId,
    required int actorProfileId,
    required String action,
    required String payloadJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         familyId: familyId,
         actorProfileId: actorProfileId,
         action: action,
         payloadJson: payloadJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuditLogRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuditLogRow copyWith({
    Object? id = _Undefined,
    Object? familyId = _Undefined,
    int? actorProfileId,
    String? action,
    String? payloadJson,
    DateTime? createdAt,
  }) {
    return AuditLogRow(
      id: id is int? ? id : this.id,
      familyId: familyId is int? ? familyId : this.familyId,
      actorProfileId: actorProfileId ?? this.actorProfileId,
      action: action ?? this.action,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
