import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

part 'money_goals_service_crud.dart';
part 'money_goals_service_helpers.dart';

class MoneyGoalsService {
  MoneyGoalsService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
  final ClockService clock;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;

  Future<MoneyGoalDto> upsertGoal(
    Session session, {
    required String clientOperationId,
    int? goalId,
    required int familyId,
    required String title,
    String? description,
    required int targetAmountCents,
    String currency = 'RUB',
    DateTime? deadlineAt,
  }) {
    return _upsertGoalImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      goalId: goalId,
      familyId: familyId,
      title: title,
      description: description,
      targetAmountCents: targetAmountCents,
      currency: currency,
      deadlineAt: deadlineAt,
    );
  }

  Future<MoneyContributionDto> addContribution(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int goalId,
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) {
    return _changeGoalAmount(
      this,
      session,
      action: 'money.addContribution',
      clientOperationId: clientOperationId,
      familyId: familyId,
      goalId: goalId,
      amountCents: amountCents,
      currency: currency,
      note: note,
      deltaAmountCents: amountCents,
      operation: 'contribution_added',
      insufficientFundsMessage: null,
    );
  }

  Future<MoneyContributionDto> withdrawFunds(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int goalId,
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) {
    return _changeGoalAmount(
      this,
      session,
      action: 'money.withdrawFunds',
      clientOperationId: clientOperationId,
      familyId: familyId,
      goalId: goalId,
      amountCents: amountCents,
      currency: currency,
      note: note,
      deltaAmountCents: -amountCents,
      operation: 'funds_withdrawn',
      insufficientFundsMessage:
          'Cannot withdraw more than the current goal balance.',
    );
  }

  Future<MoneyGoalDto> archiveGoal(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int goalId,
  }) {
    return _archiveGoalImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      goalId: goalId,
    );
  }

  Future<OperationResult> deleteGoal(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int goalId,
  }) {
    return _deleteGoalImpl(
      this,
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      goalId: goalId,
    );
  }

  Future<List<MoneyGoalDto>> listGoals(
    Session session, {
    required int familyId,
  }) {
    return _listGoalsImpl(this, session, familyId: familyId);
  }

  Future<List<MoneyGoalHistoryEntryDto>> listGoalHistory(
    Session session, {
    required int familyId,
    required int goalId,
    int limit = 50,
  }) {
    return _listGoalHistoryImpl(
      this,
      session,
      familyId: familyId,
      goalId: goalId,
      limit: limit,
    );
  }
}
