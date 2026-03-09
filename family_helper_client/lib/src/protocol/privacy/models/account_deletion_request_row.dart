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

abstract class AccountDeletionRequestRow implements _i1.SerializableModel {
  AccountDeletionRequestRow._({
    this.id,
    required this.profileId,
    required this.status,
    required this.scheduledHardDeleteAt,
    required this.createdAt,
    this.cancelledAt,
  });

  factory AccountDeletionRequestRow({
    int? id,
    required int profileId,
    required String status,
    required DateTime scheduledHardDeleteAt,
    required DateTime createdAt,
    DateTime? cancelledAt,
  }) = _AccountDeletionRequestRowImpl;

  factory AccountDeletionRequestRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountDeletionRequestRow(
      id: jsonSerialization['id'] as int?,
      profileId: jsonSerialization['profileId'] as int,
      status: jsonSerialization['status'] as String,
      scheduledHardDeleteAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledHardDeleteAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['cancelledAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int profileId;

  String status;

  DateTime scheduledHardDeleteAt;

  DateTime createdAt;

  DateTime? cancelledAt;

  /// Returns a shallow copy of this [AccountDeletionRequestRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountDeletionRequestRow copyWith({
    int? id,
    int? profileId,
    String? status,
    DateTime? scheduledHardDeleteAt,
    DateTime? createdAt,
    DateTime? cancelledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountDeletionRequestRow',
      if (id != null) 'id': id,
      'profileId': profileId,
      'status': status,
      'scheduledHardDeleteAt': scheduledHardDeleteAt.toJson(),
      'createdAt': createdAt.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountDeletionRequestRowImpl extends AccountDeletionRequestRow {
  _AccountDeletionRequestRowImpl({
    int? id,
    required int profileId,
    required String status,
    required DateTime scheduledHardDeleteAt,
    required DateTime createdAt,
    DateTime? cancelledAt,
  }) : super._(
         id: id,
         profileId: profileId,
         status: status,
         scheduledHardDeleteAt: scheduledHardDeleteAt,
         createdAt: createdAt,
         cancelledAt: cancelledAt,
       );

  /// Returns a shallow copy of this [AccountDeletionRequestRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountDeletionRequestRow copyWith({
    Object? id = _Undefined,
    int? profileId,
    String? status,
    DateTime? scheduledHardDeleteAt,
    DateTime? createdAt,
    Object? cancelledAt = _Undefined,
  }) {
    return AccountDeletionRequestRow(
      id: id is int? ? id : this.id,
      profileId: profileId ?? this.profileId,
      status: status ?? this.status,
      scheduledHardDeleteAt:
          scheduledHardDeleteAt ?? this.scheduledHardDeleteAt,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt is DateTime? ? cancelledAt : this.cancelledAt,
    );
  }
}
