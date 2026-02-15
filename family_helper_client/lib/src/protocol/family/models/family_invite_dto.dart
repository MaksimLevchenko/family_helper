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

abstract class FamilyInviteDto implements _i1.SerializableModel {
  FamilyInviteDto._({
    required this.id,
    required this.familyId,
    required this.inviteType,
    this.email,
    required this.inviteCode,
    required this.token,
    required this.expiresAt,
    this.acceptedAt,
    required this.createdAt,
  });

  factory FamilyInviteDto({
    required int id,
    required int familyId,
    required String inviteType,
    String? email,
    required String inviteCode,
    required String token,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    required DateTime createdAt,
  }) = _FamilyInviteDtoImpl;

  factory FamilyInviteDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyInviteDto(
      id: jsonSerialization['id'] as int,
      familyId: jsonSerialization['familyId'] as int,
      inviteType: jsonSerialization['inviteType'] as String,
      email: jsonSerialization['email'] as String?,
      inviteCode: jsonSerialization['inviteCode'] as String,
      token: jsonSerialization['token'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int familyId;

  String inviteType;

  String? email;

  String inviteCode;

  String token;

  DateTime expiresAt;

  DateTime? acceptedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [FamilyInviteDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyInviteDto copyWith({
    int? id,
    int? familyId,
    String? inviteType,
    String? email,
    String? inviteCode,
    String? token,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyInviteDto',
      'id': id,
      'familyId': familyId,
      'inviteType': inviteType,
      if (email != null) 'email': email,
      'inviteCode': inviteCode,
      'token': token,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FamilyInviteDtoImpl extends FamilyInviteDto {
  _FamilyInviteDtoImpl({
    required int id,
    required int familyId,
    required String inviteType,
    String? email,
    required String inviteCode,
    required String token,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         familyId: familyId,
         inviteType: inviteType,
         email: email,
         inviteCode: inviteCode,
         token: token,
         expiresAt: expiresAt,
         acceptedAt: acceptedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FamilyInviteDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyInviteDto copyWith({
    int? id,
    int? familyId,
    String? inviteType,
    Object? email = _Undefined,
    String? inviteCode,
    String? token,
    DateTime? expiresAt,
    Object? acceptedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return FamilyInviteDto(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      inviteType: inviteType ?? this.inviteType,
      email: email is String? ? email : this.email,
      inviteCode: inviteCode ?? this.inviteCode,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
