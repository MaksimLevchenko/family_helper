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

abstract class ReminderDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReminderDto._({
    required this.id,
    required this.familyId,
    required this.entityType,
    required this.entityId,
    required this.profileId,
    required this.remindAt,
    required this.status,
    required this.payloadJson,
    this.firedAt,
    required this.createdAt,
  });

  factory ReminderDto({
    required int id,
    required int familyId,
    required String entityType,
    required int entityId,
    required int profileId,
    required DateTime remindAt,
    required String status,
    required String payloadJson,
    DateTime? firedAt,
    required DateTime createdAt,
  }) = _ReminderDtoImpl;

  factory ReminderDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReminderDto(
      id: jsonSerialization['id'] as int,
      familyId: jsonSerialization['familyId'] as int,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      remindAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['remindAt'],
      ),
      status: jsonSerialization['status'] as String,
      payloadJson: jsonSerialization['payloadJson'] as String,
      firedAt: jsonSerialization['firedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['firedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int familyId;

  String entityType;

  int entityId;

  int profileId;

  DateTime remindAt;

  String status;

  String payloadJson;

  DateTime? firedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [ReminderDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReminderDto copyWith({
    int? id,
    int? familyId,
    String? entityType,
    int? entityId,
    int? profileId,
    DateTime? remindAt,
    String? status,
    String? payloadJson,
    DateTime? firedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReminderDto',
      'id': id,
      'familyId': familyId,
      'entityType': entityType,
      'entityId': entityId,
      'profileId': profileId,
      'remindAt': remindAt.toJson(),
      'status': status,
      'payloadJson': payloadJson,
      if (firedAt != null) 'firedAt': firedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReminderDto',
      'id': id,
      'familyId': familyId,
      'entityType': entityType,
      'entityId': entityId,
      'profileId': profileId,
      'remindAt': remindAt.toJson(),
      'status': status,
      'payloadJson': payloadJson,
      if (firedAt != null) 'firedAt': firedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReminderDtoImpl extends ReminderDto {
  _ReminderDtoImpl({
    required int id,
    required int familyId,
    required String entityType,
    required int entityId,
    required int profileId,
    required DateTime remindAt,
    required String status,
    required String payloadJson,
    DateTime? firedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         familyId: familyId,
         entityType: entityType,
         entityId: entityId,
         profileId: profileId,
         remindAt: remindAt,
         status: status,
         payloadJson: payloadJson,
         firedAt: firedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReminderDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReminderDto copyWith({
    int? id,
    int? familyId,
    String? entityType,
    int? entityId,
    int? profileId,
    DateTime? remindAt,
    String? status,
    String? payloadJson,
    Object? firedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return ReminderDto(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      profileId: profileId ?? this.profileId,
      remindAt: remindAt ?? this.remindAt,
      status: status ?? this.status,
      payloadJson: payloadJson ?? this.payloadJson,
      firedAt: firedAt is DateTime? ? firedAt : this.firedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
