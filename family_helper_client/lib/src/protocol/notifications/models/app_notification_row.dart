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
import '../../core/models/app_profile_row.dart' as _i2;
import '../../family/models/family_row.dart' as _i3;
import 'package:family_helper_client/src/protocol/protocol.dart' as _i4;

abstract class AppNotificationRow implements _i1.SerializableModel {
  AppNotificationRow._({
    this.id,
    required this.profileId,
    this.profile,
    required this.familyId,
    this.family,
    required this.category,
    required this.title,
    required this.body,
    required this.entityType,
    required this.entityId,
    this.route,
    required this.payloadJson,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.pushedAt,
    required this.pushStatus,
    required this.version,
  });

  factory AppNotificationRow({
    int? id,
    required int profileId,
    _i2.AppProfileRow? profile,
    required int familyId,
    _i3.FamilyRow? family,
    required String category,
    required String title,
    required String body,
    required String entityType,
    required int entityId,
    String? route,
    required String payloadJson,
    required bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
    DateTime? pushedAt,
    required String pushStatus,
    required int version,
  }) = _AppNotificationRowImpl;

  factory AppNotificationRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppNotificationRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.AppProfileRow>(
              jsonSerialization['profile'],
            ),
      familyId: jsonSerialization['familyId'] as int,
      family: jsonSerialization['family'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.FamilyRow>(
              jsonSerialization['family'],
            ),
      category: jsonSerialization['category'] as String,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      route: jsonSerialization['route'] as String?,
      payloadJson: jsonSerialization['payloadJson'] as String,
      isRead: jsonSerialization['isRead'] as bool,
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      pushedAt: jsonSerialization['pushedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['pushedAt']),
      pushStatus: jsonSerialization['pushStatus'] as String,
      version: jsonSerialization['version'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int profileId;

  _i2.AppProfileRow? profile;

  int familyId;

  _i3.FamilyRow? family;

  String category;

  String title;

  String body;

  String entityType;

  int entityId;

  String? route;

  String payloadJson;

  bool isRead;

  DateTime? readAt;

  DateTime createdAt;

  DateTime? pushedAt;

  String pushStatus;

  int version;

  /// Returns a shallow copy of this [AppNotificationRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppNotificationRow copyWith({
    int? id,
    int? profileId,
    _i2.AppProfileRow? profile,
    int? familyId,
    _i3.FamilyRow? family,
    String? category,
    String? title,
    String? body,
    String? entityType,
    int? entityId,
    String? route,
    String? payloadJson,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? pushedAt,
    String? pushStatus,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppNotificationRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
      'familyId': familyId,
      if (family != null) 'family': family?.toJson(),
      'category': category,
      'title': title,
      'body': body,
      'entityType': entityType,
      'entityId': entityId,
      if (route != null) 'route': route,
      'payloadJson': payloadJson,
      'isRead': isRead,
      if (readAt != null) 'readAt': readAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (pushedAt != null) 'pushedAt': pushedAt?.toJson(),
      'pushStatus': pushStatus,
      'version': version,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppNotificationRowImpl extends AppNotificationRow {
  _AppNotificationRowImpl({
    int? id,
    required int profileId,
    _i2.AppProfileRow? profile,
    required int familyId,
    _i3.FamilyRow? family,
    required String category,
    required String title,
    required String body,
    required String entityType,
    required int entityId,
    String? route,
    required String payloadJson,
    required bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
    DateTime? pushedAt,
    required String pushStatus,
    required int version,
  }) : super._(
         id: id,
         profileId: profileId,
         profile: profile,
         familyId: familyId,
         family: family,
         category: category,
         title: title,
         body: body,
         entityType: entityType,
         entityId: entityId,
         route: route,
         payloadJson: payloadJson,
         isRead: isRead,
         readAt: readAt,
         createdAt: createdAt,
         pushedAt: pushedAt,
         pushStatus: pushStatus,
         version: version,
       );

  /// Returns a shallow copy of this [AppNotificationRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppNotificationRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    Object? profile = _Undefined,
    int? familyId,
    Object? family = _Undefined,
    String? category,
    String? title,
    String? body,
    String? entityType,
    int? entityId,
    Object? route = _Undefined,
    String? payloadJson,
    bool? isRead,
    Object? readAt = _Undefined,
    DateTime? createdAt,
    Object? pushedAt = _Undefined,
    String? pushStatus,
    int? version,
  }) {
    return AppNotificationRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      profile: profile is _i2.AppProfileRow?
          ? profile
          : this.profile?.copyWith(),
      familyId: familyId ?? this.familyId,
      family: family is _i3.FamilyRow? ? family : this.family?.copyWith(),
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      route: route is String? ? route : this.route,
      payloadJson: payloadJson ?? this.payloadJson,
      isRead: isRead ?? this.isRead,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      createdAt: createdAt ?? this.createdAt,
      pushedAt: pushedAt is DateTime? ? pushedAt : this.pushedAt,
      pushStatus: pushStatus ?? this.pushStatus,
      version: version ?? this.version,
    );
  }
}
