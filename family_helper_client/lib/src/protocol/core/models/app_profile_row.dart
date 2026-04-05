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
import 'package:family_helper_client/src/protocol/protocol.dart' as _i3;

abstract class AppProfileRow implements _i1.SerializableModel {
  AppProfileRow._({
    this.id,
    required this.authUserId,
    required this.displayName,
    required this.timezone,
    String? locale,
    this.avatarMediaId,
    this.avatarMedia,
    required this.analyticsOptIn,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  }) : locale = locale ?? 'en';

  factory AppProfileRow({
    int? id,
    required String authUserId,
    required String displayName,
    required String timezone,
    String? locale,
    int? avatarMediaId,
    _i2.MediaObjectRow? avatarMedia,
    required bool analyticsOptIn,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _AppProfileRowImpl;

  factory AppProfileRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppProfileRow(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] as String,
      displayName: jsonSerialization['displayName'] as String,
      timezone: jsonSerialization['timezone'] as String,
      locale: jsonSerialization['locale'] as String?,
      avatarMediaId: jsonSerialization['avatarMediaId'] as int?,
      avatarMedia: jsonSerialization['avatarMedia'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.MediaObjectRow>(
              jsonSerialization['avatarMedia'],
            ),
      analyticsOptIn: jsonSerialization['analyticsOptIn'] as bool,
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

  String authUserId;

  String displayName;

  String timezone;

  String locale;

  int? avatarMediaId;

  _i2.MediaObjectRow? avatarMedia;

  bool analyticsOptIn;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [AppProfileRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppProfileRow copyWith({
    int? id,
    String? authUserId,
    String? displayName,
    String? timezone,
    String? locale,
    int? avatarMediaId,
    _i2.MediaObjectRow? avatarMedia,
    bool? analyticsOptIn,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppProfileRow',
      if (id != null) 'id': id,
      'authUserId': authUserId,
      'displayName': displayName,
      'timezone': timezone,
      'locale': locale,
      if (avatarMediaId != null) 'avatarMediaId': avatarMediaId,
      if (avatarMedia != null) 'avatarMedia': avatarMedia?.toJson(),
      'analyticsOptIn': analyticsOptIn,
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

class _AppProfileRowImpl extends AppProfileRow {
  _AppProfileRowImpl({
    int? id,
    required String authUserId,
    required String displayName,
    required String timezone,
    String? locale,
    int? avatarMediaId,
    _i2.MediaObjectRow? avatarMedia,
    required bool analyticsOptIn,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         authUserId: authUserId,
         displayName: displayName,
         timezone: timezone,
         locale: locale,
         avatarMediaId: avatarMediaId,
         avatarMedia: avatarMedia,
         analyticsOptIn: analyticsOptIn,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [AppProfileRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppProfileRow copyWith({
    Object? id = _Undefined,
    String? authUserId,
    String? displayName,
    String? timezone,
    String? locale,
    Object? avatarMediaId = _Undefined,
    Object? avatarMedia = _Undefined,
    bool? analyticsOptIn,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return AppProfileRow(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      timezone: timezone ?? this.timezone,
      locale: locale ?? this.locale,
      avatarMediaId: avatarMediaId is int? ? avatarMediaId : this.avatarMediaId,
      avatarMedia: avatarMedia is _i2.MediaObjectRow?
          ? avatarMedia
          : this.avatarMedia?.copyWith(),
      analyticsOptIn: analyticsOptIn ?? this.analyticsOptIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
