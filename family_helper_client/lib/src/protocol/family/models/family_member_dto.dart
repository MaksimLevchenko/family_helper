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

abstract class FamilyMemberDto implements _i1.SerializableModel {
  FamilyMemberDto._({
    required this.id,
    required this.familyId,
    required this.profileId,
    required this.displayName,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory FamilyMemberDto({
    required int id,
    required int familyId,
    required int profileId,
    required String displayName,
    required String role,
    required String status,
    required DateTime createdAt,
  }) = _FamilyMemberDtoImpl;

  factory FamilyMemberDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyMemberDto(
      id: jsonSerialization['id'] as int,
      familyId: jsonSerialization['familyId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      displayName: jsonSerialization['displayName'] as String,
      role: jsonSerialization['role'] as String,
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int familyId;

  int profileId;

  String displayName;

  String role;

  String status;

  DateTime createdAt;

  /// Returns a shallow copy of this [FamilyMemberDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyMemberDto copyWith({
    int? id,
    int? familyId,
    int? profileId,
    String? displayName,
    String? role,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyMemberDto',
      'id': id,
      'familyId': familyId,
      'profileId': profileId,
      'displayName': displayName,
      'role': role,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FamilyMemberDtoImpl extends FamilyMemberDto {
  _FamilyMemberDtoImpl({
    required int id,
    required int familyId,
    required int profileId,
    required String displayName,
    required String role,
    required String status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         familyId: familyId,
         profileId: profileId,
         displayName: displayName,
         role: role,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FamilyMemberDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyMemberDto copyWith({
    int? id,
    int? familyId,
    int? profileId,
    String? displayName,
    String? role,
    String? status,
    DateTime? createdAt,
  }) {
    return FamilyMemberDto(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      profileId: profileId ?? this.profileId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
