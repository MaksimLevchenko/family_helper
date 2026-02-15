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

abstract class FamilyDto implements _i1.SerializableModel {
  FamilyDto._({
    required this.id,
    required this.title,
    required this.ownerProfileId,
    required this.memberLimit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FamilyDto({
    required int id,
    required String title,
    required int ownerProfileId,
    required int memberLimit,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FamilyDtoImpl;

  factory FamilyDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyDto(
      id: jsonSerialization['id'] as int,
      title: jsonSerialization['title'] as String,
      ownerProfileId: jsonSerialization['ownerProfileId'] as int,
      memberLimit: jsonSerialization['memberLimit'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int id;

  String title;

  int ownerProfileId;

  int memberLimit;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [FamilyDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyDto copyWith({
    int? id,
    String? title,
    int? ownerProfileId,
    int? memberLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyDto',
      'id': id,
      'title': title,
      'ownerProfileId': ownerProfileId,
      'memberLimit': memberLimit,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FamilyDtoImpl extends FamilyDto {
  _FamilyDtoImpl({
    required int id,
    required String title,
    required int ownerProfileId,
    required int memberLimit,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         title: title,
         ownerProfileId: ownerProfileId,
         memberLimit: memberLimit,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FamilyDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyDto copyWith({
    int? id,
    String? title,
    int? ownerProfileId,
    int? memberLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyDto(
      id: id ?? this.id,
      title: title ?? this.title,
      ownerProfileId: ownerProfileId ?? this.ownerProfileId,
      memberLimit: memberLimit ?? this.memberLimit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
