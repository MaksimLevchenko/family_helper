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

abstract class PrivacyExportJobRow implements _i1.SerializableModel {
  PrivacyExportJobRow._({
    this.id,
    required this.profileId,
    required this.status,
    required this.objectKey,
    this.signedUrl,
    this.expiresAt,
    required this.createdAt,
    this.completedAt,
  });

  factory PrivacyExportJobRow({
    int? id,
    required int profileId,
    required String status,
    required String objectKey,
    String? signedUrl,
    DateTime? expiresAt,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _PrivacyExportJobRowImpl;

  factory PrivacyExportJobRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PrivacyExportJobRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      status: jsonSerialization['status'] as String,
      objectKey: jsonSerialization['objectKey'] as String,
      signedUrl: jsonSerialization['signedUrl'] as String?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int profileId;

  String status;

  String objectKey;

  String? signedUrl;

  DateTime? expiresAt;

  DateTime createdAt;

  DateTime? completedAt;

  /// Returns a shallow copy of this [PrivacyExportJobRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PrivacyExportJobRow copyWith({
    int? id,
    int? profileId,
    String? status,
    String? objectKey,
    String? signedUrl,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PrivacyExportJobRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'status': status,
      'objectKey': objectKey,
      if (signedUrl != null) 'signedUrl': signedUrl,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PrivacyExportJobRowImpl extends PrivacyExportJobRow {
  _PrivacyExportJobRowImpl({
    int? id,
    required int profileId,
    required String status,
    required String objectKey,
    String? signedUrl,
    DateTime? expiresAt,
    required DateTime createdAt,
    DateTime? completedAt,
  }) : super._(
         id: id,
         profileId: profileId,
         status: status,
         objectKey: objectKey,
         signedUrl: signedUrl,
         expiresAt: expiresAt,
         createdAt: createdAt,
         completedAt: completedAt,
       );

  /// Returns a shallow copy of this [PrivacyExportJobRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PrivacyExportJobRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? status,
    String? objectKey,
    Object? signedUrl = _Undefined,
    Object? expiresAt = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
  }) {
    return PrivacyExportJobRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      status: status ?? this.status,
      objectKey: objectKey ?? this.objectKey,
      signedUrl: signedUrl is String? ? signedUrl : this.signedUrl,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
    );
  }
}
