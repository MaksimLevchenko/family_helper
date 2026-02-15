import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class MoneyGoalsRepository {
  const MoneyGoalsRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<List<MoneyGoalDto>> listGoals({required int familyId}) {
    return _apiClient.client.moneyGoals.listGoals(familyId: familyId);
  }

  Future<MoneyGoalDto> upsertGoal({
    required String clientOperationId,
    int? goalId,
    required int familyId,
    required String title,
    String? description,
    required int targetAmountCents,
    String currency = 'RUB',
    DateTime? deadlineAt,
  }) {
    return _apiClient.client.moneyGoals.upsertGoal(
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

  Future<MoneyContributionDto> addContribution({
    required String clientOperationId,
    required int familyId,
    required int goalId,
    required int amountCents,
    String currency = 'RUB',
    String? note,
  }) {
    return _apiClient.client.moneyGoals.addContribution(
      clientOperationId: clientOperationId,
      familyId: familyId,
      goalId: goalId,
      amountCents: amountCents,
      currency: currency,
      note: note,
    );
  }
}
