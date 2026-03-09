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

abstract class NotificationPreferenceRow implements _i1.SerializableModel {
  NotificationPreferenceRow._({
    this.id,
    required this.profileId,
    required this.notificationType,
    required this.enabled,
    this.quietHoursStart,
    this.quietHoursEnd,
    required this.updatedAt,
    required this.version,
  });

  factory NotificationPreferenceRow({
    int? id,
    required int profileId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    required DateTime updatedAt,
    required int version,
  }) = _NotificationPreferenceRowImpl;

  factory NotificationPreferenceRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreferenceRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      notificationType: jsonSerialization['notificationType'] as String,
      enabled: jsonSerialization['enabled'] as bool,
      quietHoursStart: jsonSerialization['quietHoursStart'] as String?,
      quietHoursEnd: jsonSerialization['quietHoursEnd'] as String?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int profileId;

  String notificationType;

  bool enabled;

  String? quietHoursStart;

  String? quietHoursEnd;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [NotificationPreferenceRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationPreferenceRow copyWith({
    int? id,
    int? profileId,
    String? notificationType,
    bool? enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreferenceRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'notificationType': notificationType,
      'enabled': enabled,
      if (quietHoursStart != null) 'quietHoursStart': quietHoursStart,
      if (quietHoursEnd != null) 'quietHoursEnd': quietHoursEnd,
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationPreferenceRowImpl extends NotificationPreferenceRow {
  _NotificationPreferenceRowImpl({
    int? id,
    required int profileId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         profileId: profileId,
         notificationType: notificationType,
         enabled: enabled,
         quietHoursStart: quietHoursStart,
         quietHoursEnd: quietHoursEnd,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [NotificationPreferenceRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationPreferenceRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? notificationType,
    bool? enabled,
    Object? quietHoursStart = _Undefined,
    Object? quietHoursEnd = _Undefined,
    DateTime? updatedAt,
    int? version,
  }) {
    return NotificationPreferenceRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      notificationType: notificationType ?? this.notificationType,
      enabled: enabled ?? this.enabled,
      quietHoursStart: quietHoursStart is String?
          ? quietHoursStart
          : this.quietHoursStart,
      quietHoursEnd: quietHoursEnd is String?
          ? quietHoursEnd
          : this.quietHoursEnd,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
