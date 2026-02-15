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

abstract class SyncChangeDto implements _i1.SerializableModel {
  SyncChangeDto._({
    required this.id,
    this.familyId,
    required this.feature,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.changedAt,
    required this.tombstone,
    required this.version,
    required this.payloadJson,
  });

  factory SyncChangeDto({
    required int id,
    int? familyId,
    required String feature,
    required String entityType,
    required int entityId,
    required String operation,
    required DateTime changedAt,
    required bool tombstone,
    required int version,
    required String payloadJson,
  }) = _SyncChangeDtoImpl;

  factory SyncChangeDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncChangeDto(
      id: jsonSerialization['id'] as int,
      familyId: jsonSerialization['familyId'] as int?,
      feature: jsonSerialization['feature'] as String,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      operation: jsonSerialization['operation'] as String,
      changedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['changedAt'],
      ),
      tombstone: jsonSerialization['tombstone'] as bool,
      version: jsonSerialization['version'] as int,
      payloadJson: jsonSerialization['payloadJson'] as String,
    );
  }

  int id;

  int? familyId;

  String feature;

  String entityType;

  int entityId;

  String operation;

  DateTime changedAt;

  bool tombstone;

  int version;

  String payloadJson;

  /// Returns a shallow copy of this [SyncChangeDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SyncChangeDto copyWith({
    int? id,
    int? familyId,
    String? feature,
    String? entityType,
    int? entityId,
    String? operation,
    DateTime? changedAt,
    bool? tombstone,
    int? version,
    String? payloadJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncChangeDto',
      'id': id,
      if (familyId != null) 'familyId': familyId,
      'feature': feature,
      'entityType': entityType,
      'entityId': entityId,
      'operation': operation,
      'changedAt': changedAt.toJson(),
      'tombstone': tombstone,
      'version': version,
      'payloadJson': payloadJson,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SyncChangeDtoImpl extends SyncChangeDto {
  _SyncChangeDtoImpl({
    required int id,
    int? familyId,
    required String feature,
    required String entityType,
    required int entityId,
    required String operation,
    required DateTime changedAt,
    required bool tombstone,
    required int version,
    required String payloadJson,
  }) : super._(
         id: id,
         familyId: familyId,
         feature: feature,
         entityType: entityType,
         entityId: entityId,
         operation: operation,
         changedAt: changedAt,
         tombstone: tombstone,
         version: version,
         payloadJson: payloadJson,
       );

  /// Returns a shallow copy of this [SyncChangeDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SyncChangeDto copyWith({
    int? id,
    Object? familyId = _Undefined,
    String? feature,
    String? entityType,
    int? entityId,
    String? operation,
    DateTime? changedAt,
    bool? tombstone,
    int? version,
    String? payloadJson,
  }) {
    return SyncChangeDto(
      id: id ?? this.id,
      familyId: familyId is int? ? familyId : this.familyId,
      feature: feature ?? this.feature,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      changedAt: changedAt ?? this.changedAt,
      tombstone: tombstone ?? this.tombstone,
      version: version ?? this.version,
      payloadJson: payloadJson ?? this.payloadJson,
    );
  }
}
