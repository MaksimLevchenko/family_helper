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

abstract class MoneyGoalRow implements _i1.SerializableModel {
  MoneyGoalRow._({
    this.id,
    required this.familyId,
    required this.title,
    this.description,
    required this.targetAmountCents,
    required this.currentAmountCents,
    required this.currency,
    this.deadlineAt,
    this.reachedAt,
    this.archivedAt,
    required this.createdByProfileId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });

  factory MoneyGoalRow({
    int? id,
    required int familyId,
    required String title,
    String? description,
    required int targetAmountCents,
    required int currentAmountCents,
    required String currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    DateTime? archivedAt,
    required int createdByProfileId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) = _MoneyGoalRowImpl;

  factory MoneyGoalRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return MoneyGoalRow(
      id: jsonSerialization['id'] as int?,
      familyId: jsonSerialization['familyId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      targetAmountCents: jsonSerialization['targetAmountCents'] as int,
      currentAmountCents: jsonSerialization['currentAmountCents'] as int,
      currency: jsonSerialization['currency'] as String,
      deadlineAt: jsonSerialization['deadlineAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deadlineAt']),
      reachedAt: jsonSerialization['reachedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['reachedAt']),
      archivedAt: jsonSerialization['archivedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['archivedAt']),
      createdByProfileId: jsonSerialization['createdByProfileId'] as int,
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

  int familyId;

  String title;

  String? description;

  int targetAmountCents;

  int currentAmountCents;

  String currency;

  DateTime? deadlineAt;

  DateTime? reachedAt;

  DateTime? archivedAt;

  int createdByProfileId;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deletedAt;

  int version;

  /// Returns a shallow copy of this [MoneyGoalRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MoneyGoalRow copyWith({
    int? id,
    int? familyId,
    String? title,
    String? description,
    int? targetAmountCents,
    int? currentAmountCents,
    String? currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    DateTime? archivedAt,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MoneyGoalRow',
      if (id != null) 'id': id,
      'familyId': familyId,
      'title': title,
      if (description != null) 'description': description,
      'targetAmountCents': targetAmountCents,
      'currentAmountCents': currentAmountCents,
      'currency': currency,
      if (deadlineAt != null) 'deadlineAt': deadlineAt?.toJson(),
      if (reachedAt != null) 'reachedAt': reachedAt?.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
      'createdByProfileId': createdByProfileId,
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

class _MoneyGoalRowImpl extends MoneyGoalRow {
  _MoneyGoalRowImpl({
    int? id,
    required int familyId,
    required String title,
    String? description,
    required int targetAmountCents,
    required int currentAmountCents,
    required String currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    DateTime? archivedAt,
    required int createdByProfileId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required int version,
  }) : super._(
         id: id,
         familyId: familyId,
         title: title,
         description: description,
         targetAmountCents: targetAmountCents,
         currentAmountCents: currentAmountCents,
         currency: currency,
         deadlineAt: deadlineAt,
         reachedAt: reachedAt,
         archivedAt: archivedAt,
         createdByProfileId: createdByProfileId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deletedAt: deletedAt,
         version: version,
       );

  /// Returns a shallow copy of this [MoneyGoalRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MoneyGoalRow copyWith({
    Object? id = _Undefined,
    int? familyId,
    String? title,
    Object? description = _Undefined,
    int? targetAmountCents,
    int? currentAmountCents,
    String? currency,
    Object? deadlineAt = _Undefined,
    Object? reachedAt = _Undefined,
    Object? archivedAt = _Undefined,
    int? createdByProfileId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _Undefined,
    int? version,
  }) {
    return MoneyGoalRow(
      id: id is int? ? id : this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      targetAmountCents: targetAmountCents ?? this.targetAmountCents,
      currentAmountCents: currentAmountCents ?? this.currentAmountCents,
      currency: currency ?? this.currency,
      deadlineAt: deadlineAt is DateTime? ? deadlineAt : this.deadlineAt,
      reachedAt: reachedAt is DateTime? ? reachedAt : this.reachedAt,
      archivedAt: archivedAt is DateTime? ? archivedAt : this.archivedAt,
      createdByProfileId: createdByProfileId ?? this.createdByProfileId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      version: version ?? this.version,
    );
  }
}
