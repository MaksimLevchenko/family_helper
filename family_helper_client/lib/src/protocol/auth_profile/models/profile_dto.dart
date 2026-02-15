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

abstract class ProfileDto implements _i1.SerializableModel {
  ProfileDto._({
    required this.id,
    required this.authUserId,
    required this.displayName,
    required this.timezone,
    this.avatarMediaId,
    required this.analyticsOptIn,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileDto({
    required int id,
    required String authUserId,
    required String displayName,
    required String timezone,
    int? avatarMediaId,
    required bool analyticsOptIn,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProfileDtoImpl;

  factory ProfileDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProfileDto(
      id: jsonSerialization['id'] as int,
      authUserId: jsonSerialization['authUserId'] as String,
      displayName: jsonSerialization['displayName'] as String,
      timezone: jsonSerialization['timezone'] as String,
      avatarMediaId: jsonSerialization['avatarMediaId'] as int?,
      analyticsOptIn: jsonSerialization['analyticsOptIn'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int id;

  String authUserId;

  String displayName;

  String timezone;

  int? avatarMediaId;

  bool analyticsOptIn;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ProfileDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProfileDto copyWith({
    int? id,
    String? authUserId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool? analyticsOptIn,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProfileDto',
      'id': id,
      'authUserId': authUserId,
      'displayName': displayName,
      'timezone': timezone,
      if (avatarMediaId != null) 'avatarMediaId': avatarMediaId,
      'analyticsOptIn': analyticsOptIn,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProfileDtoImpl extends ProfileDto {
  _ProfileDtoImpl({
    required int id,
    required String authUserId,
    required String displayName,
    required String timezone,
    int? avatarMediaId,
    required bool analyticsOptIn,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         displayName: displayName,
         timezone: timezone,
         avatarMediaId: avatarMediaId,
         analyticsOptIn: analyticsOptIn,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProfileDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProfileDto copyWith({
    int? id,
    String? authUserId,
    String? displayName,
    String? timezone,
    Object? avatarMediaId = _Undefined,
    bool? analyticsOptIn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileDto(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      timezone: timezone ?? this.timezone,
      avatarMediaId: avatarMediaId is int? ? avatarMediaId : this.avatarMediaId,
      analyticsOptIn: analyticsOptIn ?? this.analyticsOptIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
