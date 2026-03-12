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

abstract class MoneyGoalHistoryEntryDto implements _i1.SerializableModel {
  MoneyGoalHistoryEntryDto._({
    required this.id,
    required this.goalId,
    required this.profileId,
    required this.actorDisplayName,
    required this.amountCents,
    required this.currency,
    this.note,
    required this.createdAt,
  });

  factory MoneyGoalHistoryEntryDto({
    required int id,
    required int goalId,
    required int profileId,
    required String actorDisplayName,
    required int amountCents,
    required String currency,
    String? note,
    required DateTime createdAt,
  }) = _MoneyGoalHistoryEntryDtoImpl;

  factory MoneyGoalHistoryEntryDto.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MoneyGoalHistoryEntryDto(
      id: jsonSerialization['id'] as int,
      goalId: jsonSerialization['goalId'] as int,
      profileId: jsonSerialization['profileId'] as int,
      actorDisplayName: jsonSerialization['actorDisplayName'] as String,
      amountCents: jsonSerialization['amountCents'] as int,
      currency: jsonSerialization['currency'] as String,
      note: jsonSerialization['note'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int goalId;

  int profileId;

  String actorDisplayName;

  int amountCents;

  String currency;

  String? note;

  DateTime createdAt;

  /// Returns a shallow copy of this [MoneyGoalHistoryEntryDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MoneyGoalHistoryEntryDto copyWith({
    int? id,
    int? goalId,
    int? profileId,
    String? actorDisplayName,
    int? amountCents,
    String? currency,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MoneyGoalHistoryEntryDto',
      'id': id,
      'goalId': goalId,
      'profileId': profileId,
      'actorDisplayName': actorDisplayName,
      'amountCents': amountCents,
      'currency': currency,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MoneyGoalHistoryEntryDtoImpl extends MoneyGoalHistoryEntryDto {
  _MoneyGoalHistoryEntryDtoImpl({
    required int id,
    required int goalId,
    required int profileId,
    required String actorDisplayName,
    required int amountCents,
    required String currency,
    String? note,
    required DateTime createdAt,
  }) : super._(
         id: id,
         goalId: goalId,
         profileId: profileId,
         actorDisplayName: actorDisplayName,
         amountCents: amountCents,
         currency: currency,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MoneyGoalHistoryEntryDto]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MoneyGoalHistoryEntryDto copyWith({
    int? id,
    int? goalId,
    int? profileId,
    String? actorDisplayName,
    int? amountCents,
    String? currency,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return MoneyGoalHistoryEntryDto(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      profileId: profileId ?? this.profileId,
      actorDisplayName: actorDisplayName ?? this.actorDisplayName,
      amountCents: amountCents ?? this.amountCents,
      currency: currency ?? this.currency,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
