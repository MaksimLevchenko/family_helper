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

abstract class FamilyListDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FamilyListDto._({
    required this.id,
    required this.familyId,
    required this.title,
    required this.listType,
    required this.createdByProfileId,
    required this.updatedAt,
    required this.version,
  });

  factory FamilyListDto({
    required int id,
    required int familyId,
    required String title,
    required String listType,
    required int createdByProfileId,
    required DateTime updatedAt,
    required int version,
  }) = _FamilyListDtoImpl;

  factory FamilyListDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyListDto(
      id: jsonSerialization['id'] as int,
      familyId: jsonSerialization['familyId'] as int,
      title: jsonSerialization['title'] as String,
      listType: jsonSerialization['listType'] as String,
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  int id;

  int familyId;

  String title;

  String listType;

  int createdByProfileId;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [FamilyListDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyListDto copyWith({
    int? id,
    int? familyId,
    String? title,
    String? listType,
    int? createdByProfileId,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyListDto',
      'id': id,
      'familyId': familyId,
      'title': title,
      'listType': listType,
      'createdByProfileId': createdByProfileId,
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FamilyListDto',
      'id': id,
      'familyId': familyId,
      'title': title,
      'listType': listType,
      'createdByProfileId': createdByProfileId,
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FamilyListDtoImpl extends FamilyListDto {
  _FamilyListDtoImpl({
    required int id,
    required int familyId,
    required String title,
    required String listType,
    required int createdByProfileId,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         title: title,
         listType: listType,
         createdByProfileId: createdByProfileId,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [FamilyListDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyListDto copyWith({
    int? id,
    int? familyId,
    String? title,
    String? listType,
    int? createdByProfileId,
    DateTime? updatedAt,
    int? version,
  }) {
    return FamilyListDto(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      listType: listType ?? this.listType,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
