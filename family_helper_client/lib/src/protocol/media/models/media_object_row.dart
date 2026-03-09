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

abstract class MediaObjectRow implements _i1.SerializableModel {
  MediaObjectRow._({
    this.id,
    this.familyId,
    required this.uploadedByProfileId,
    required this.objectKey,
    required this.bucket,
    required this.mimeType,
    required this.sizeBytes,
    required this.status,
    this.thumbnailKey,
    this.clientOperationId,
    this.uploadExpiresAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory MediaObjectRow({
    int? id,
    int? familyId,
    required int uploadedByProfileId,
    required String objectKey,
    required String bucket,
    required String mimeType,
    required int sizeBytes,
    required String status,
    String? thumbnailKey,
    String? clientOperationId,
    DateTime? uploadExpiresAt,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _MediaObjectRowImpl;

  factory MediaObjectRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaObjectRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int?,
      uploadedByProfileId: jsonSerialization['uploadedByProfileId'] as int,
      objectKey: jsonSerialization['objectKey'] as String,
      bucket: jsonSerialization['bucket'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      status: jsonSerialization['status'] as String,
      thumbnailKey: jsonSerialization['thumbnailKey'] as String?,
      clientOperationId: jsonSerialization['clientOperationId'] as String?,
      uploadExpiresAt: jsonSerialization['uploadExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['uploadExpiresAt'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
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

  int? familyId;

  int uploadedByProfileId;

  String objectKey;

  String bucket;

  String mimeType;

  int sizeBytes;

  String status;

  String? thumbnailKey;

  String? clientOperationId;

  DateTime? uploadExpiresAt;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [MediaObjectRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MediaObjectRow copyWith({
    int? id,
    int? familyId,
    int? uploadedByProfileId,
    String? objectKey,
    String? bucket,
    String? mimeType,
    int? sizeBytes,
    String? status,
    String? thumbnailKey,
    String? clientOperationId,
    DateTime? uploadExpiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MediaObjectRow',
      if (id != null) 'id': id,
      if (familyId != null) 'familyId': familyId,
      'uploadedByProfileId': uploadedByProfileId,
      'objectKey': objectKey,
      'bucket': bucket,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'status': status,
      if (thumbnailKey != null) 'thumbnailKey': thumbnailKey,
      if (clientOperationId != null) 'clientOperationId': clientOperationId,
      if (uploadExpiresAt != null) 'uploadExpiresAt': uploadExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
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

class _MediaObjectRowImpl extends MediaObjectRow {
  _MediaObjectRowImpl({
    int? id,
    int? familyId,
    required int uploadedByProfileId,
    required String objectKey,
    required String bucket,
    required String mimeType,
    required int sizeBytes,
    required String status,
    String? thumbnailKey,
    String? clientOperationId,
    DateTime? uploadExpiresAt,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required int version,
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
         clientOperationId: clientOperationId,
         uploadExpiresAt: uploadExpiresAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [MediaObjectRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MediaObjectRow copyWith({
    Object? id = _Undefined,
    Object? familyId = _Undefined,
    int? uploadedByProfileId,
    String? objectKey,
    String? bucket,
    String? mimeType,
    int? sizeBytes,
    String? status,
    Object? thumbnailKey = _Undefined,
    Object? clientOperationId = _Undefined,
    Object? uploadExpiresAt = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return MediaObjectRow(
      id: id is int? ? id : this.id,
      familyId: familyId is int? ? familyId : this.familyId,
      uploadedByProfileId: uploadedByProfileId ?? this.uploadedByProfileId,
      objectKey: objectKey ?? this.objectKey,
      bucket: bucket ?? this.bucket,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      status: status ?? this.status,
      thumbnailKey: thumbnailKey is String? ? thumbnailKey : this.thumbnailKey,
      clientOperationId: clientOperationId is String?
          ? clientOperationId
          : this.clientOperationId,
      uploadExpiresAt: uploadExpiresAt is DateTime?
          ? uploadExpiresAt
          : this.uploadExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
