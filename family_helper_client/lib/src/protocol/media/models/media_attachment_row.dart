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

abstract class MediaAttachmentRow implements _i1.SerializableModel {
  MediaAttachmentRow._({
    this.id,
    required this.mediaId,
    required this.entityType,
    required this.entityId,
    required this.createdByProfileId,
    required this.createdAt,
    this.deletedAt,
    required this.version,
  });

  factory MediaAttachmentRow({
    int? id,
    required int mediaId,
    required String entityType,
    required int entityId,
    required int createdByProfileId,
    required DateTime createdAt,
    DateTime? deletedAt,
    required int version,
  }) = _MediaAttachmentRowImpl;

  factory MediaAttachmentRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaAttachmentRow(
      id: jsonSerialization['id'] as int?,
      mediaId: jsonSerialization['mediaId'] as int,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
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

  int mediaId;

  String entityType;

  int entityId;

  int createdByProfileId;

  DateTime createdAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [MediaAttachmentRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MediaAttachmentRow copyWith({
    int? id,
    int? mediaId,
    String? entityType,
    int? entityId,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MediaAttachmentRow',
      if (id != null) 'id': id,
      'mediaId': mediaId,
      'entityType': entityType,
      'entityId': entityId,
      'createdByProfileId': createdByProfileId,
      'createdAt': createdAt.toJson(),
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

class _MediaAttachmentRowImpl extends MediaAttachmentRow {
  _MediaAttachmentRowImpl({
    int? id,
    required int mediaId,
    required String entityType,
    required int entityId,
    required int createdByProfileId,
    required DateTime createdAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         mediaId: mediaId,
         entityType: entityType,
         entityId: entityId,
         createdByProfileId: createdByProfileId,
         createdAt: createdAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [MediaAttachmentRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MediaAttachmentRow copyWith({
    Object? id = _Undefined,
    int? mediaId,
    String? entityType,
    int? entityId,
    int? createdByProfileId,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return MediaAttachmentRow(
      id: id is int? ? id : this.id,
      mediaId: mediaId ?? this.mediaId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
