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

abstract class MoneyContributionDto
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MoneyContributionDto._({
    required this.id,
    required this.goalId,
    required this.profileId,
    required this.amountCents,
    required this.currency,
    this.note,
    required this.createdAt,
    this.revokedAt,
  });

  factory MoneyContributionDto({
    required int id,
    required int goalId,
    required int profileId,
    required int amountCents,
    required String currency,
    String? note,
    required DateTime createdAt,
    DateTime? revokedAt,
  }) = _MoneyContributionDtoImpl;

  factory MoneyContributionDto.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MoneyContributionDto(
      id: jsonSerialization['id'] as int,
      goalId: jsonSerialization['goalId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      amountCents: jsonSerialization['amountCents'] as int,
      currency: jsonSerialization['currency'] as String,
      note: jsonSerialization['note'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
    );
  }

  int id;

  int goalId;

  int profileId;

  int amountCents;

  String currency;

  String? note;

  DateTime createdAt;

  DateTime? revokedAt;

  /// Returns a shallow copy of this [MoneyContributionDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MoneyContributionDto copyWith({
    int? id,
    int? goalId,
    int? profileId,
    int? amountCents,
    String? currency,
    String? note,
    DateTime? createdAt,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MoneyContributionDto',
      'id': id,
      'goalId': goalId,
      'profileId': profileId,
      'amountCents': amountCents,
      'currency': currency,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MoneyContributionDto',
      'id': id,
      'goalId': goalId,
      'profileId': profileId,
      'amountCents': amountCents,
      'currency': currency,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MoneyContributionDtoImpl extends MoneyContributionDto {
  _MoneyContributionDtoImpl({
    required int id,
    required int goalId,
    required int profileId,
    required int amountCents,
    required String currency,
    String? note,
    required DateTime createdAt,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         goalId: goalId,
         profileId: profileId,
         amountCents: amountCents,
         currency: currency,
         note: note,
         createdAt: createdAt,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [MoneyContributionDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MoneyContributionDto copyWith({
    int? id,
    int? goalId,
    int? profileId,
    int? amountCents,
    String? currency,
    Object? note = _Undefined,
    DateTime? createdAt,
    Object? revokedAt = _Undefined,
  }) {
    return MoneyContributionDto(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      profileId: profileId ?? this.profileId,
      amountCents: amountCents ?? this.amountCents,
      currency: currency ?? this.currency,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}
