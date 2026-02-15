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

abstract class NotificationPreferenceDto implements _i1.SerializableModel {
  NotificationPreferenceDto._({
    required this.id,
    required this.profileId,
    required this.notificationType,
    required this.enabled,
    this.quietHoursStart,
    this.quietHoursEnd,
    required this.updatedAt,
  });

  factory NotificationPreferenceDto({
    required int id,
    required int profileId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    required DateTime updatedAt,
  }) = _NotificationPreferenceDtoImpl;

  factory NotificationPreferenceDto.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreferenceDto(
      id: jsonSerialization['id'] as int,
      profileId: jsonSerialization['profileId'] as int,
      notificationType: jsonSerialization['notificationType'] as String,
      enabled: jsonSerialization['enabled'] as bool,
      quietHoursStart: jsonSerialization['quietHoursStart'] as String?,
      quietHoursEnd: jsonSerialization['quietHoursEnd'] as String?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  int id;

  int profileId;

  String notificationType;

  bool enabled;

  String? quietHoursStart;

  String? quietHoursEnd;

  DateTime updatedAt;

  /// Returns a shallow copy of this [NotificationPreferenceDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationPreferenceDto copyWith({
    int? id,
    int? profileId,
    String? notificationType,
    bool? enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreferenceDto',
      'id': id,
      'profileId': profileId,
      'notificationType': notificationType,
      'enabled': enabled,
      if (quietHoursStart != null) 'quietHoursStart': quietHoursStart,
      if (quietHoursEnd != null) 'quietHoursEnd': quietHoursEnd,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationPreferenceDtoImpl extends NotificationPreferenceDto {
  _NotificationPreferenceDtoImpl({
    required int id,
    required int profileId,
    required String notificationType,
    required bool enabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         profileId: profileId,
         notificationType: notificationType,
         enabled: enabled,
         quietHoursStart: quietHoursStart,
         quietHoursEnd: quietHoursEnd,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationPreferenceDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationPreferenceDto copyWith({
    int? id,
    int? profileId,
    String? notificationType,
    bool? enabled,
    Object? quietHoursStart = _Undefined,
    Object? quietHoursEnd = _Undefined,
    DateTime? updatedAt,
  }) {
    return NotificationPreferenceDto(
      id: id ?? this.id,
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
    );
  }
}
