part of 'money_goals_service.dart';

Future<MoneyGoalDto> _findGoal(
  MoneyGoalsService service,
  Session session,
  int goalId, {
  Transaction? transaction,
}) async {
  final row = await MoneyGoalRow.db.findFirstRow(
    session,
    where: (t) => t.id.equals(goalId) & t.deletedAt.equals(null),
    transaction: transaction,
  );
  return _mapGoal(row!);
}

Future<MoneyContributionDto> _changeGoalAmount(
  MoneyGoalsService service,
  Session session, {
  required String action,
  required String clientOperationId,
  required int familyId,
  required int goalId,
  required int amountCents,
  required String currency,
  required String? note,
  required int deltaAmountCents,
  required String operation,
  required String? insufficientFundsMessage,
}) async {
  if (amountCents <= 0) {
    throw ArgumentError.value(
      amountCents,
      'amountCents',
      'Amount must be greater than zero.',
    );
  }

  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: action,
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    final goalRow = await _lockGoalRow(
      service,
      session,
      familyId: familyId,
      goalId: goalId,
      transaction: transaction,
    );
    if (goalRow.archivedAt != null) {
      throw StateError('Archived goals cannot be changed.');
    }
    if (goalRow.currency != currency) {
      throw ArgumentError.value(
        currency,
        'currency',
        'Contribution currency must match goal currency.',
      );
    }

    if (!isFresh) {
      final existing = await _findContributionByOperationId(
        session,
        goalId: goalId,
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (existing != null) {
        return _mapContribution(existing);
      }
    }

    final nextAmount = goalRow.currentAmountCents + deltaAmountCents;
    if (insufficientFundsMessage != null && nextAmount < 0) {
      throw ArgumentError.value(
        amountCents,
        'amountCents',
        insufficientFundsMessage,
      );
    }

    final now = service.clock.nowUtc();
    MoneyContributionRow contributionRow;
    try {
      contributionRow = await MoneyContributionRow.db.insertRow(
        session,
        MoneyContributionRow(
          goalId: goalId,
          profileId: actorProfileId,
          amountCents: deltaAmountCents,
          currency: currency,
          note: note,
          clientOperationId: clientOperationId,
          createdAt: now,
          revokedAt: null,
        ),
        transaction: transaction,
      );
    } on DatabaseInsertRowException {
      final existing = await _findContributionByOperationId(
        session,
        goalId: goalId,
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (existing != null) {
        return _mapContribution(existing);
      }
      rethrow;
    } on DatabaseQueryException catch (error) {
      if (error.code != '23505') {
        rethrow;
      }
      final existing = await _findContributionByOperationId(
        session,
        goalId: goalId,
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (existing != null) {
        return _mapContribution(existing);
      }
      rethrow;
    }

    final nextReachedAt = nextAmount >= goalRow.targetAmountCents
        ? (goalRow.reachedAt ?? now)
        : null;
    await MoneyGoalRow.db.updateRow(
      session,
      goalRow.copyWith(
        currentAmountCents: nextAmount,
        reachedAt: nextReachedAt,
        updatedAt: now,
        version: goalRow.version + 1,
      ),
      transaction: transaction,
    );

    await _emitGoalChange(
      service,
      session,
      familyId: familyId,
      goalId: goalId,
      operation: operation,
      transaction: transaction,
    );

    return _mapContribution(contributionRow);
  });
}

Future<MoneyGoalRow> _lockGoalRow(
  MoneyGoalsService service,
  Session session, {
  required int familyId,
  required int goalId,
  Transaction? transaction,
}) async {
  await session.db.unsafeQuery(
    'SELECT "id" FROM "money_goal" WHERE "id" = @goalId AND "familyId" = @familyId AND "deletedAt" IS NULL FOR UPDATE',
    transaction: transaction,
    parameters: QueryParameters.named({
      'goalId': goalId,
      'familyId': familyId,
    }),
  );

  final row = await _lockGoalRowOrNull(
    session,
    familyId: familyId,
    goalId: goalId,
    transaction: transaction,
  );
  if (row == null) {
    throw FileNotFoundException(message: 'Goal not found.');
  }
  return row;
}

Future<MoneyGoalRow?> _lockGoalRowOrNull(
  Session session, {
  required int familyId,
  required int goalId,
  Transaction? transaction,
}) {
  return MoneyGoalRow.db.findFirstRow(
    session,
    where: (t) =>
        t.id.equals(goalId) &
        t.familyId.equals(familyId) &
        t.deletedAt.equals(null),
    transaction: transaction,
  );
}

Future<MoneyContributionRow?> _findContributionByOperationId(
  Session session, {
  required int goalId,
  required String clientOperationId,
  Transaction? transaction,
}) {
  return MoneyContributionRow.db.findFirstRow(
    session,
    where: (t) =>
        t.goalId.equals(goalId) &
        t.clientOperationId.equals(clientOperationId),
    transaction: transaction,
  );
}

Future<void> _emitGoalChange(
  MoneyGoalsService service,
  Session session, {
  required int familyId,
  required int goalId,
  required String operation,
  Transaction? transaction,
}) async {
  await service.changeFeed.appendChange(
    session,
    feature: 'money_goals',
    entityType: 'goal',
    entityId: goalId,
    operation: operation,
    familyId: familyId,
    version: 1,
    transaction: transaction,
  );

  await service.realtime.publish(
    session,
    familyId: familyId,
    event: FamilyRealtimeEvent(
      familyId: familyId,
      feature: 'money_goals',
      entityType: 'goal',
      entityId: goalId,
      eventType: switch (operation) {
        'contribution_added' => 'money_goal.contribution_added',
        'funds_withdrawn' => 'money_goal.funds_withdrawn',
        'deleted' => 'money_goal.deleted',
        'archived' => 'money_goal.archived',
        _ => 'money_goal.updated',
      },
      changedAt: service.clock.nowUtc(),
    ),
  );
}

MoneyGoalDto _mapGoal(MoneyGoalRow row) {
  return MoneyGoalDto(
    id: row.id!,
    familyId: row.familyId,
    title: row.title,
    description: row.description,
    targetAmountCents: row.targetAmountCents,
    currentAmountCents: row.currentAmountCents,
    currency: row.currency,
    deadlineAt: row.deadlineAt,
    reachedAt: row.reachedAt,
    archivedAt: row.archivedAt,
    updatedAt: row.updatedAt,
    version: row.version,
  );
}

MoneyContributionDto _mapContribution(MoneyContributionRow row) {
  return MoneyContributionDto(
    id: row.id!,
    goalId: row.goalId,
    profileId: row.profileId,
    amountCents: row.amountCents,
    currency: row.currency,
    note: row.note,
    createdAt: row.createdAt,
    revokedAt: row.revokedAt,
  );
}

MoneyGoalHistoryEntryDto _mapHistoryEntry(
  MoneyContributionRow row,
  AppProfileRow? profile,
) {
  return MoneyGoalHistoryEntryDto(
    id: row.id!,
    goalId: row.goalId,
    profileId: row.profileId,
    actorDisplayName: profile?.displayName ?? 'User #${row.profileId}',
    amountCents: row.amountCents,
    currency: row.currency,
    note: row.note,
    createdAt: row.createdAt,
  );
}
