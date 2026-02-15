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

abstract class MediaObjectDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MediaObjectDto._({
    required this.id,
    this.familyId,
    required this.uploadedByProfileId,
    required this.objectKey,
    required this.bucket,
    required this.mimeType,
    required this.sizeBytes,
    required this.status,
    this.thumbnailKey,
    required this.createdAt,
    this.deletedAt,
  });

  factory MediaObjectDto({
    required int id,
    int? familyId,
    required int uploadedByProfileId,
    required String objectKey,
    required String bucket,
    required String mimeType,
    required int sizeBytes,
    required String status,
    String? thumbnailKey,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) = _MediaObjectDtoImpl;

  factory MediaObjectDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaObjectDto(
      id: jsonSerialization['id'] as int,
      familyId: jsonSerialization['familyId'] as int?,
      uploadedByProfileId: jsonSerialization['uploadedByProfileId'] as int,
      objectKey: jsonSerialization['objectKey'] as String,
      bucket: jsonSerialization['bucket'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      status: jsonSerialization['status'] as String,
      thumbnailKey: jsonSerialization['thumbnailKey'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
    );
  }

  int id;

  int? familyId;

  int uploadedByProfileId;

  String objectKey;

  String bucket;

  String mimeType;

  int sizeBytes;

  String status;

  String? thumbnailKey;

  DateTime createdAt;

  DateTime? deletedAt;

  /// Returns a shallow copy of this [MediaObjectDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MediaObjectDto copyWith({
    int? id,
    int? familyId,
    int? uploadedByProfileId,
    String? objectKey,
    String? bucket,
    String? mimeType,
    int? sizeBytes,
    String? status,
    String? thumbnailKey,
    DateTime? createdAt,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MediaObjectDto',
      'id': id,
      if (familyId != null) 'familyId': familyId,
      'uploadedByProfileId': uploadedByProfileId,
      'objectKey': objectKey,
      'bucket': bucket,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'status': status,
      if (thumbnailKey != null) 'thumbnailKey': thumbnailKey,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MediaObjectDto',
      'id': id,
      if (familyId != null) 'familyId': familyId,
      'uploadedByProfileId': uploadedByProfileId,
      'objectKey': objectKey,
      'bucket': bucket,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'status': status,
      if (thumbnailKey != null) 'thumbnailKey': thumbnailKey,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MediaObjectDtoImpl extends MediaObjectDto {
  _MediaObjectDtoImpl({
    required int id,
    int? familyId,
    required int uploadedByProfileId,
    required String objectKey,
    required String bucket,
    required String mimeType,
    required int sizeBytes,
    required String status,
    String? thumbnailKey,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) : super._(
         id: id,
         familyId: familyId,
         uploadedByProfileId: uploadedByProfileId,
         objectKey: objectKey,
         bucket: bucket,
         mimeType: mimeType,
         sizeBytes: sizeBytes,
         status: status,
         thumbnailKey: thumbnailKey,
         createdAt: createdAt,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [MediaObjectDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MediaObjectDto copyWith({
    int? id,
    Object? familyId = _Undefined,
    int? uploadedByProfileId,
    String? objectKey,
    String? bucket,
    String? mimeType,
    int? sizeBytes,
    String? status,
    Object? thumbnailKey = _Undefined,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
  }) {
    return MediaObjectDto(
      id: id ?? this.id,
      familyId: familyId is int? ? familyId : this.familyId,
      uploadedByProfileId: uploadedByProfileId ?? this.uploadedByProfileId,
      objectKey: objectKey ?? this.objectKey,
      bucket: bucket ?? this.bucket,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      thumbnailKey: thumbnailKey is String? ? thumbnailKey : this.thumbnailKey,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
    );
  }
}
