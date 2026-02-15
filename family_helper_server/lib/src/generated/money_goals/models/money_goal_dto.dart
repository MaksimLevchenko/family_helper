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

abstract class MoneyGoalDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MoneyGoalDto._({
    required this.id,
    required this.familyId,
    required this.title,
    this.description,
    required this.targetAmountCents,
    required this.currentAmountCents,
    required this.currency,
    this.deadlineAt,
    this.reachedAt,
    required this.updatedAt,
    required this.version,
  });

  factory MoneyGoalDto({
    required int id,
    required int familyId,
    required String title,
    String? description,
    required int targetAmountCents,
    required int currentAmountCents,
    required String currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    required DateTime updatedAt,
    required int version,
  }) = _MoneyGoalDtoImpl;

  factory MoneyGoalDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return MoneyGoalDto(
      id: jsonSerialization['id'] as int,
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
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  int id;

  int familyId;

  String title;

  String? description;

  int targetAmountCents;

  int currentAmountCents;

  String currency;

  DateTime? deadlineAt;

  DateTime? reachedAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [MoneyGoalDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MoneyGoalDto copyWith({
    int? id,
    int? familyId,
    String? title,
    String? description,
    int? targetAmountCents,
    int? currentAmountCents,
    String? currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MoneyGoalDto',
      'id': id,
      'familyId': familyId,
      'title': title,
      if (description != null) 'description': description,
      'targetAmountCents': targetAmountCents,
      'currentAmountCents': currentAmountCents,
      'currency': currency,
      if (deadlineAt != null) 'deadlineAt': deadlineAt?.toJson(),
      if (reachedAt != null) 'reachedAt': reachedAt?.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MoneyGoalDto',
      'id': id,
      'familyId': familyId,
      'title': title,
      if (description != null) 'description': description,
      'targetAmountCents': targetAmountCents,
      'currentAmountCents': currentAmountCents,
      'currency': currency,
      if (deadlineAt != null) 'deadlineAt': deadlineAt?.toJson(),
      if (reachedAt != null) 'reachedAt': reachedAt?.toJson(),
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

class _MoneyGoalDtoImpl extends MoneyGoalDto {
  _MoneyGoalDtoImpl({
    required int id,
    required int familyId,
    required String title,
    String? description,
    required int targetAmountCents,
    required int currentAmountCents,
    required String currency,
    DateTime? deadlineAt,
    DateTime? reachedAt,
    required DateTime updatedAt,
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
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [MoneyGoalDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MoneyGoalDto copyWith({
    int? id,
    int? familyId,
    String? title,
    Object? description = _Undefined,
    int? targetAmountCents,
    int? currentAmountCents,
    String? currency,
    Object? deadlineAt = _Undefined,
    Object? reachedAt = _Undefined,
    DateTime? updatedAt,
    int? version,
  }) {
    return MoneyGoalDto(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      targetAmountCents: targetAmountCents ?? this.targetAmountCents,
      currentAmountCents: currentAmountCents ?? this.currentAmountCents,
      currency: currency ?? this.currency,
      deadlineAt: deadlineAt is DateTime? ? deadlineAt : this.deadlineAt,
      reachedAt: reachedAt is DateTime? ? reachedAt : this.reachedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
