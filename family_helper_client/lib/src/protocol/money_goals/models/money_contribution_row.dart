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
import '../../money_goals/models/money_goal_row.dart' as _i2;
import '../../core/models/app_profile_row.dart' as _i3;
import 'package:family_helper_client/src/protocol/protocol.dart' as _i4;

abstract class MoneyContributionRow implements _i1.SerializableModel {
  MoneyContributionRow._({
    this.id,
    required this.goalId,
    this.goal,
    required this.profileId,
    this.profile,
    required this.amountCents,
    required this.currency,
    this.note,
    this.clientOperationId,
    required this.createdAt,
    this.revokedAt,
  });

  factory MoneyContributionRow({
    int? id,
    required int goalId,
    _i2.MoneyGoalRow? goal,
    required int profileId,
    _i3.AppProfileRow? profile,
    required int amountCents,
    required String currency,
    String? note,
    String? clientOperationId,
    required DateTime createdAt,
    DateTime? revokedAt,
  }) = _MoneyContributionRowImpl;

  factory MoneyContributionRow.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MoneyContributionRow(
      id: jsonSerialization['id'] as int?,
      goalId: jsonSerialization['goalId'] as int,
      goal: jsonSerialization['goal'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.MoneyGoalRow>(
              jsonSerialization['goal'],
            ),
      profileId: jsonSerialization['profileId'] as int,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.AppProfileRow>(
              jsonSerialization['profile'],
            ),
      amountCents: jsonSerialization['amountCents'] as int,
      currency: jsonSerialization['currency'] as String,
      note: jsonSerialization['note'] as String?,
      clientOperationId: jsonSerialization['clientOperationId'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int goalId;

  _i2.MoneyGoalRow? goal;

  int profileId;

  _i3.AppProfileRow? profile;

  int amountCents;

  String currency;

  String? note;

  String? clientOperationId;

  DateTime createdAt;

  DateTime? revokedAt;

  /// Returns a shallow copy of this [MoneyContributionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MoneyContributionRow copyWith({
    int? id,
    int? goalId,
    _i2.MoneyGoalRow? goal,
    int? profileId,
    _i3.AppProfileRow? profile,
    int? amountCents,
    String? currency,
    String? note,
    String? clientOperationId,
    DateTime? createdAt,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MoneyContributionRow',
      if (id != null) 'id': id,
      'goalId': goalId,
      if (goal != null) 'goal': goal?.toJson(),
      'profileId': profileId,
      if (profile != null) 'profile': profile?.toJson(),
      'amountCents': amountCents,
      'currency': currency,
      if (note != null) 'note': note,
      if (clientOperationId != null) 'clientOperationId': clientOperationId,
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

class _MoneyContributionRowImpl extends MoneyContributionRow {
  _MoneyContributionRowImpl({
    int? id,
    required int goalId,
    _i2.MoneyGoalRow? goal,
    required int profileId,
    _i3.AppProfileRow? profile,
    required int amountCents,
    required String currency,
    String? note,
    String? clientOperationId,
    required DateTime createdAt,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         goalId: goalId,
         goal: goal,
         profileId: profileId,
         profile: profile,
         amountCents: amountCents,
         currency: currency,
         note: note,
         clientOperationId: clientOperationId,
         createdAt: createdAt,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [MoneyContributionRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MoneyContributionRow copyWith({
    Object? id = _Undefined,
    int? goalId,
    Object? goal = _Undefined,
    int? profileId,
    Object? profile = _Undefined,
    int? amountCents,
    String? currency,
    Object? note = _Undefined,
    Object? clientOperationId = _Undefined,
    DateTime? createdAt,
    Object? revokedAt = _Undefined,
  }) {
    return MoneyContributionRow(
      id: id is int? ? id : this.id,
      goalId: goalId ?? this.goalId,
      goal: goal is _i2.MoneyGoalRow? ? goal : this.goal?.copyWith(),
      profileId: profileId ?? this.profileId,
      profile: profile is _i3.AppProfileRow?
          ? profile
          : this.profile?.copyWith(),
      amountCents: amountCents ?? this.amountCents,
      currency: currency ?? this.currency,
      note: note is String? ? note : this.note,
      clientOperationId: clientOperationId is String?
          ? clientOperationId
          : this.clientOperationId,
      createdAt: createdAt ?? this.createdAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}
