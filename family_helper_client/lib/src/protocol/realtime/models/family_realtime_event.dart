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

abstract class FamilyRealtimeEvent implements _i1.SerializableModel {
  FamilyRealtimeEvent._({
    required this.familyId,
    required this.feature,
    required this.entityType,
    required this.entityId,
    required this.eventType,
    required this.changedAt,
  });

  factory FamilyRealtimeEvent({
    required int familyId,
    required String feature,
    required String entityType,
    required int entityId,
    required String eventType,
    required DateTime changedAt,
  }) = _FamilyRealtimeEventImpl;

  factory FamilyRealtimeEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return FamilyRealtimeEvent(
      familyId: jsonSerialization['familyId'] as int,
      feature: jsonSerialization['feature'] as String,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int,
      eventType: jsonSerialization['eventType'] as String,
      changedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['changedAt'],
      ),
    );
  }

  int familyId;

  String feature;

  String entityType;

  int entityId;

  String eventType;

  DateTime changedAt;

  /// Returns a shallow copy of this [FamilyRealtimeEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FamilyRealtimeEvent copyWith({
    int? familyId,
    String? feature,
    String? entityType,
    int? entityId,
    String? eventType,
    DateTime? changedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FamilyRealtimeEvent',
      'familyId': familyId,
      'feature': feature,
      'entityType': entityType,
      'entityId': entityId,
      'eventType': eventType,
      'changedAt': changedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FamilyRealtimeEventImpl extends FamilyRealtimeEvent {
  _FamilyRealtimeEventImpl({
    required int familyId,
    required String feature,
    required String entityType,
    required int entityId,
    required String eventType,
    required DateTime changedAt,
  }) : super._(
         familyId: familyId,
         feature: feature,
         entityType: entityType,
         entityId: entityId,
         eventType: eventType,
         changedAt: changedAt,
       );

  /// Returns a shallow copy of this [FamilyRealtimeEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FamilyRealtimeEvent copyWith({
    int? familyId,
    String? feature,
    String? entityType,
    int? entityId,
    String? eventType,
    DateTime? changedAt,
  }) {
    return FamilyRealtimeEvent(
      familyId: familyId ?? this.familyId,
      feature: feature ?? this.feature,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      eventType: eventType ?? this.eventType,
      changedAt: changedAt ?? this.changedAt,
    );
  }
}
