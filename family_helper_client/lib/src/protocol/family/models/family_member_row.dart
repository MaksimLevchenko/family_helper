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
import '../../family/models/family_row.dart' as _i2;
import '../../core/models/app_profile_row.dart' as _i3;
import 'package:family_helper_client/src/protocol/protocol.dart' as _i4;

abstract class FamilyMemberRow implements _i1.SerializableModel {
  FamilyMemberRow._({
    this.id,
    required this.familyId,
    this.family,
    required this.profileId,
    this.profile,
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
    _i2.FamilyRow? family,
    required int profileId,
    _i3.AppProfileRow? profile,
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
      family: jsonSerialization['family'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.FamilyRow>(
              jsonSerialization['family'],
            ),
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['profile'],
            ),
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

  _i2.FamilyRow? family;

  int profileId;

  _i3.AppProfileRow? profile;

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
    _i2.FamilyRow? family,
    int? profileId,
    _i3.AppProfileRow? profile,
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
      if (family != null) 'family': family?.toJson(),
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
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
    _i2.FamilyRow? family,
    required int profileId,
    _i3.AppProfileRow? profile,
    required String role,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         family: family,
         profileId: profileId,
         profile: profile,
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
    Object? family = _Undefined,
    int? profileId,
    Object? profile = _Undefined,
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
      family: family is _i2.FamilyRow? ? family : this.family?.copyWith(),
      profileId: profileId ?? this.profileId,
      profile: profile is _i3.AppProfileRow?
          ? profile
          : this.profile?.copyWith(),
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
