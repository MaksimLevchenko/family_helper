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

abstract class IdempotencyKeyRow implements _i1.SerializableModel {
  IdempotencyKeyRow._({
    this.id,
    required this.actorAuthUserId,
    required this.action,
    required this.clientOperationId,
    required this.createdAt,
  });

  factory IdempotencyKeyRow({
    int? id,
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    required DateTime createdAt,
  }) = _IdempotencyKeyRowImpl;

  factory IdempotencyKeyRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return IdempotencyKeyRow(
      id: jsonSerialization['id'] as int?,
      actorAuthUserId: jsonSerialization['actorAuthUserId'] as String,
      action: jsonSerialization['action'] as String,
      clientOperationId: jsonSerialization['clientOperationId'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String actorAuthUserId;

  String action;

  String clientOperationId;

  DateTime createdAt;

  /// Returns a shallow copy of this [IdempotencyKeyRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IdempotencyKeyRow copyWith({
    int? id,
    String? actorAuthUserId,
    String? action,
    String? clientOperationId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IdempotencyKeyRow',
      if (id != null) 'id': id,
      'actorAuthUserId': actorAuthUserId,
      'action': action,
      'clientOperationId': clientOperationId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IdempotencyKeyRowImpl extends IdempotencyKeyRow {
  _IdempotencyKeyRowImpl({
    int? id,
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorAuthUserId: actorAuthUserId,
         action: action,
         clientOperationId: clientOperationId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [IdempotencyKeyRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IdempotencyKeyRow copyWith({
    Object? id = _Undefined,
    String? actorAuthUserId,
    String? action,
    String? clientOperationId,
    DateTime? createdAt,
  }) {
    return IdempotencyKeyRow(
      id: id is int? ? id : this.id,
      actorAuthUserId: actorAuthUserId ?? this.actorAuthUserId,
      action: action ?? this.action,
      clientOperationId: clientOperationId ?? this.clientOperationId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
