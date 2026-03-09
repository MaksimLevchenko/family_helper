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

abstract class SecurityEventRow implements _i1.SerializableModel {
  SecurityEventRow._({
    this.id,
    required this.authUserId,
    required this.eventType,
    required this.success,
    required this.payloadJson,
    required this.createdAt,
  });

  factory SecurityEventRow({
    int? id,
    required String authUserId,
    required String eventType,
    required bool success,
    required String payloadJson,
    required DateTime createdAt,
  }) = _SecurityEventRowImpl;

  factory SecurityEventRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return SecurityEventRow(
      id: jsonSerialization['id'] as int?,
      authUserId: jsonSerialization['authUserId'] as String,
      eventType: jsonSerialization['eventType'] as String,
      success: jsonSerialization['success'] as bool,
      payloadJson: jsonSerialization['payloadJson'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String authUserId;

  String eventType;

  bool success;

  String payloadJson;

  DateTime createdAt;

  /// Returns a shallow copy of this [SecurityEventRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SecurityEventRow copyWith({
    int? id,
    String? authUserId,
    String? eventType,
    bool? success,
    String? payloadJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SecurityEventRow',
      if (id != null) 'id': id,
      'authUserId': authUserId,
      'eventType': eventType,
      'success': success,
      'payloadJson': payloadJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SecurityEventRowImpl extends SecurityEventRow {
  _SecurityEventRowImpl({
    int? id,
    required String authUserId,
    required String eventType,
    required bool success,
    required String payloadJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         eventType: eventType,
         success: success,
         payloadJson: payloadJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SecurityEventRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SecurityEventRow copyWith({
    Object? id = _Undefined,
    String? authUserId,
    String? eventType,
    bool? success,
    String? payloadJson,
    DateTime? createdAt,
  }) {
    return SecurityEventRow(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      eventType: eventType ?? this.eventType,
      success: success ?? this.success,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
