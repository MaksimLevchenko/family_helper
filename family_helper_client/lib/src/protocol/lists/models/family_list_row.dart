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

abstract class FamilyListRow implements _i1.SerializableModel {
  FamilyListRow._({
    this.id,
    required this.familyId,
    required this.title,
    required this.listType,
    required this.createdByProfileId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory FamilyListRow({
    int? id,
    required int familyId,
    required String title,
    required String listType,
    required int createdByProfileId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _FamilyListRowImpl;

  factory FamilyListRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyListRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      title: jsonSerialization['title'] as String,
      listType: jsonSerialization['listType'] as String,
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
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

  String listType;

  int createdByProfileId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [FamilyListRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyListRow copyWith({
    int? id,
    int? familyId,
    String? title,
    String? listType,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyListRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'title': title,
      'listType': listType,
      'createdByProfileId': createdByProfileId,
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

class _FamilyListRowImpl extends FamilyListRow {
  _FamilyListRowImpl({
    int? id,
    required int familyId,
    required String title,
    required String listType,
    required int createdByProfileId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         title: title,
         listType: listType,
         createdByProfileId: createdByProfileId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [FamilyListRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyListRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    String? title,
    String? listType,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return FamilyListRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      listType: listType ?? this.listType,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
