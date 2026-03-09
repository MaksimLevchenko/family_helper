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

abstract class FamilyMemberRow implements _i1.SerializableModel {
  FamilyMemberRow._({
    this.id,
    required this.familyId,
    required this.profileId,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory FamilyMemberRow({
    int? id,
    required int familyId,
    required int profileId,
    required String role,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _FamilyMemberRowImpl;

  factory FamilyMemberRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyMemberRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      role: jsonSerialization['role'] as String,
      status: jsonSerialization['status'] as String,
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

  int profileId;

  String role;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [FamilyMemberRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyMemberRow copyWith({
    int? id,
    int? familyId,
    int? profileId,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyMemberRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'profileId': profileId,
      'role': role,
      'status': status,
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

class _FamilyMemberRowImpl extends FamilyMemberRow {
  _FamilyMemberRowImpl({
    int? id,
    required int familyId,
    required int profileId,
    required String role,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         profileId: profileId,
         role: role,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [FamilyMemberRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyMemberRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    int? profileId,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return FamilyMemberRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      profileId: profileId ?? this.profileId,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
