import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/money_goals_service.dart';

class MoneyGoalsEndpoint extends Endpoint {
  MoneyGoalsEndpoint({MoneyGoalsService? service})
    : service = service ?? MoneyGoalsService();

  final MoneyGoalsService service;

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
    return service.upsertGoal(
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
    return service.addContribution(
      session,
      clientOperationId: clientOperationId,
      familyId: familyId,
      goalId: goalId,
      amountCents: amountCents,
      currency: currency,
      note: note,
    );
  }

  Future<List<MoneyGoalDto>> listGoals(
    Session session, {
    required int familyId,
  }) {
    return service.listGoals(session, familyId: familyId);
  }
}
