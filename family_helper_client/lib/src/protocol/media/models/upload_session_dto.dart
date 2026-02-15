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

abstract class UploadSessionDto implements _i1.SerializableModel {
  UploadSessionDto._({
    required this.mediaId,
    required this.objectKey,
    required this.uploadUrl,
    required this.expiresAt,
  });

  factory UploadSessionDto({
    required int mediaId,
    required String objectKey,
    required String uploadUrl,
    required DateTime expiresAt,
  }) = _UploadSessionDtoImpl;

  factory UploadSessionDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return UploadSessionDto(
      mediaId: jsonSerialization['mediaId'] as int,
      objectKey: jsonSerialization['objectKey'] as String,
      uploadUrl: jsonSerialization['uploadUrl'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  int mediaId;

  String objectKey;

  String uploadUrl;

  DateTime expiresAt;

  /// Returns a shallow copy of this [UploadSessionDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UploadSessionDto copyWith({
    int? mediaId,
    String? objectKey,
    String? uploadUrl,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UploadSessionDto',
      'mediaId': mediaId,
      'objectKey': objectKey,
      'uploadUrl': uploadUrl,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UploadSessionDtoImpl extends UploadSessionDto {
  _UploadSessionDtoImpl({
    required int mediaId,
    required String objectKey,
    required String uploadUrl,
    required DateTime expiresAt,
  }) : super._(
         mediaId: mediaId,
         objectKey: objectKey,
         uploadUrl: uploadUrl,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [UploadSessionDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UploadSessionDto copyWith({
    int? mediaId,
    String? objectKey,
    String? uploadUrl,
    DateTime? expiresAt,
  }) {
    return UploadSessionDto(
      mediaId: mediaId ?? this.mediaId,
      objectKey: objectKey ?? this.objectKey,
      uploadUrl: uploadUrl ?? this.uploadUrl,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
