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

abstract class PushTokenRow implements _i1.SerializableModel {
  PushTokenRow._({
    this.id,
    required this.profileId,
    required this.token,
    required this.platform,
    this.provider,
    this.deviceId,
    this.appVersion,
    required this.createdAt,
    required this.updatedAt,
    this.lastSeenAt,
    this.lastErrorAt,
    this.deletedAt,
    this.disabledAt,
    required this.version,
  });

  factory PushTokenRow({
    int? id,
    required int profileId,
    required String token,
    required String platform,
    String? provider,
    String? deviceId,
    String? appVersion,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSeenAt,
    DateTime? lastErrorAt,
    DateTime? deletedAt,
    DateTime? disabledAt,
    required int version,
  }) = _PushTokenRowImpl;

  factory PushTokenRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushTokenRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      token: jsonSerialization['token'] as String,
      platform: jsonSerialization['platform'] as String,
      provider: jsonSerialization['provider'] as String?,
      deviceId: jsonSerialization['deviceId'] as String?,
      appVersion: jsonSerialization['appVersion'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
      lastErrorAt: jsonSerialization['lastErrorAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastErrorAt'],
            ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      disabledAt: jsonSerialization['disabledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['disabledAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int profileId;

  String token;

  String platform;

  String? provider;

  String? deviceId;

  String? appVersion;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? lastSeenAt;

  DateTime? lastErrorAt;

  DateTime? deletedAt;

  DateTime? disabledAt;

  int version;

  /// Returns a shallow copy of this [PushTokenRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PushTokenRow copyWith({
    int? id,
    int? profileId,
    String? token,
    String? platform,
    String? provider,
    String? deviceId,
    String? appVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSeenAt,
    DateTime? lastErrorAt,
    DateTime? deletedAt,
    DateTime? disabledAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushTokenRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'token': token,
      'platform': platform,
      if (provider != null) 'provider': provider,
      if (deviceId != null) 'deviceId': deviceId,
      if (appVersion != null) 'appVersion': appVersion,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      if (lastErrorAt != null) 'lastErrorAt': lastErrorAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (disabledAt != null) 'disabledAt': disabledAt?.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushTokenRowImpl extends PushTokenRow {
  _PushTokenRowImpl({
    int? id,
    required int profileId,
    required String token,
    required String platform,
    String? provider,
    String? deviceId,
    String? appVersion,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastSeenAt,
    DateTime? lastErrorAt,
    DateTime? deletedAt,
    DateTime? disabledAt,
    required int version,
  }) : super._(
         id: id,
         profileId: profileId,
         token: token,
         platform: platform,
         provider: provider,
         deviceId: deviceId,
         appVersion: appVersion,
         createdAt: createdAt,
         updatedAt: updatedAt,
         lastSeenAt: lastSeenAt,
         lastErrorAt: lastErrorAt,
         deletedAt: deletedAt,
         disabledAt: disabledAt,
         version: version,
       );

  /// Returns a shallow copy of this [PushTokenRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PushTokenRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? token,
    String? platform,
    Object? provider = _Undefined,
    Object? deviceId = _Undefined,
    Object? appVersion = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? lastSeenAt = _Undefined,
    Object? lastErrorAt = _Undefined,
    Object? deletedAt = _Undefined,
    Object? disabledAt = _Undefined,
    int? version,
  }) {
    return PushTokenRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      token: token ?? this.token,
      platform: platform ?? this.platform,
      provider: provider is String? ? provider : this.provider,
      deviceId: deviceId is String? ? deviceId : this.deviceId,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
      lastErrorAt: lastErrorAt is DateTime? ? lastErrorAt : this.lastErrorAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      disabledAt: disabledAt is DateTime? ? disabledAt : this.disabledAt,
      version: version ?? this.version,
    );
  }
}
