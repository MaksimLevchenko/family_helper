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
import '../../media/models/media_object_row.dart' as _i2;
import '../../core/models/app_profile_row.dart' as _i3;
import 'package:family_helper_client/src/protocol/protocol.dart' as _i4;

abstract class MediaAttachmentRow implements _i1.SerializableModel {
  MediaAttachmentRow._({
    this.id,
    required this.mediaId,
    this.media,
    required this.entityType,
    required this.entityId,
    required this.createdByProfileId,
    this.createdByProfile,
    required this.createdAt,
    this.deletedAt,
    required this.version,
  });

  factory MediaAttachmentRow({
    int? id,
    required int mediaId,
    _i2.MediaObjectRow? media,
    required String entityType,
    required int entityId,
    required int createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
    required DateTime createdAt,
    DateTime? deletedAt,
    required int version,
  }) = _MediaAttachmentRowImpl;

  factory MediaAttachmentRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaAttachmentRow(
      id: jsonSerialization['id'] as int?,
      mediaId: jsonSerialization['mediaId'] as int,
      media: jsonSerialization['media'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.MediaObjectRow>(
              jsonSerialization['media'],
            ),
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
      createdByProfile: jsonSerialization['createdByProfile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['createdByProfile'],
            ),
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

  _i2.MediaObjectRow? media;

  String entityType;

  int entityId;

  int createdByProfileId;

  _i3.AppProfileRow? createdByProfile;

  DateTime createdAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [MediaAttachmentRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MediaAttachmentRow copyWith({
    int? id,
    int? mediaId,
    _i2.MediaObjectRow? media,
    String? entityType,
    int? entityId,
    int? createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
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
      if (media != null) 'media': media?.toJson(),
      'entityType': entityType,
      'entityId': entityId,
      'createdByProfileId': createdByProfileId,
      if (createdByProfile != null)
        'createdByProfile': createdByProfile?.toJson(),
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
    _i2.MediaObjectRow? media,
    required String entityType,
    required int entityId,
    required int createdByProfileId,
    _i3.AppProfileRow? createdByProfile,
    required DateTime createdAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         mediaId: mediaId,
         media: media,
         entityType: entityType,
         entityId: entityId,
         createdByProfileId: createdByProfileId,
         createdByProfile: createdByProfile,
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
    Object? media = _Undefined,
    String? entityType,
    int? entityId,
    int? createdByProfileId,
    Object? createdByProfile = _Undefined,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return MediaAttachmentRow(
      id: id is int? ? id : this.id,
      mediaId: mediaId ?? this.mediaId,
      media: media is _i2.MediaObjectRow? ? media : this.media?.copyWith(),
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdByProfile: createdByProfile is _i3.AppProfileRow?
          ? createdByProfile
          : this.createdByProfile?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
