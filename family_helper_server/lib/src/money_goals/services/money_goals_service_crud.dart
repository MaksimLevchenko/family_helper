part of 'money_goals_service.dart';

Future<MoneyGoalDto> _upsertGoalImpl(
  MoneyGoalsService service,
  Session session, {
  required String clientOperationId,
  int? goalId,
  required int familyId,
  required String title,
  String? description,
  required int targetAmountCents,
  String currency = 'RUB',
  DateTime? deadlineAt,
}) async {
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
      action: 'money.upsertGoal',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    if (!isFresh && goalId != null) {
      return _findGoal(service, session, goalId, transaction: transaction);
    }
    if (!isFresh) {
      final binding = await service.idempotency.getBinding(
        session,
        actorAuthUserId: authUserId,
        action: 'money.upsertGoal',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (binding?.resourceType == 'money_goal') {
        return _findGoal(
          service,
          session,
          binding!.resourceId,
          transaction: transaction,
        );
      }
    }

    final now = service.clock.nowUtc();
    if (goalId == null) {
      final inserted = await MoneyGoalRow.db.insertRow(
        session,
        MoneyGoalRow(
          familyId: familyId,
          title: title,
          description: description,
          targetAmountCents: targetAmountCents,
          currentAmountCents: 0,
          currency: currency,
          deadlineAt: deadlineAt?.toUtc(),
          reachedAt: null,
          archivedAt: null,
          createdByProfileId: actorProfileId,
          createdAt: now,
          updatedAt: now,
          deletedAt: null,
          version: 1,
        ),
        transaction: transaction,
      );
      final dto = _mapGoal(inserted);
      await service.idempotency.bindResource(
        session,
        actorAuthUserId: authUserId,
        action: 'money.upsertGoal',
        clientOperationId: clientOperationId,
        resourceType: 'money_goal',
        resourceId: dto.id,
        transaction: transaction,
      );
      await _emitGoalChange(
        service,
        session,
        familyId: familyId,
        goalId: dto.id,
        operation: 'upserted',
        transaction: transaction,
      );
      return dto;
    }

    final row = await _lockGoalRow(
      service,
      session,
      familyId: familyId,
      goalId: goalId,
      transaction: transaction,
    );
    await MoneyGoalRow.db.updateRow(
      session,
      row.copyWith(
        title: title,
        description: description,
        targetAmountCents: targetAmountCents,
        currency: currency,
        deadlineAt: deadlineAt?.toUtc(),
        archivedAt: null,
        updatedAt: now,
        version: row.version + 1,
      ),
      transaction: transaction,
    );

    final updated = await _findGoal(
      service,
      session,
      goalId,
      transaction: transaction,
    );
    await _emitGoalChange(
      service,
      session,
      familyId: familyId,
      goalId: updated.id,
      operation: 'upserted',
      transaction: transaction,
    );
    return updated;
  });
}

Future<MoneyGoalDto> _archiveGoalImpl(
  MoneyGoalsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required int goalId,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'money.archiveGoal',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );
    if (!isFresh) {
      return _findGoal(service, session, goalId, transaction: transaction);
    }

    final row = await _lockGoalRow(
      service,
      session,
      familyId: familyId,
      goalId: goalId,
      transaction: transaction,
    );
    if (row.archivedAt != null) {
      return _mapGoal(row);
    }

    final now = service.clock.nowUtc();
    await MoneyGoalRow.db.updateRow(
      session,
      row.copyWith(
        archivedAt: now,
        reachedAt: row.reachedAt ?? now,
        updatedAt: now,
        version: row.version + 1,
      ),
      transaction: transaction,
    );

    final updatedGoal = await _findGoal(
      service,
      session,
      goalId,
      transaction: transaction,
    );
    await _emitGoalChange(
      service,
      session,
      familyId: familyId,
      goalId: goalId,
      operation: 'archived',
      transaction: transaction,
    );
    return updatedGoal;
  });
}

Future<OperationResult> _deleteGoalImpl(
  MoneyGoalsService service,
  Session session, {
  required String clientOperationId,
  required int familyId,
  required int goalId,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'money.deleteGoal',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );
    if (!isFresh) {
      return OperationResult(success: true, message: 'Already deleted');
    }

    final row = await _lockGoalRowOrNull(
      session,
      familyId: familyId,
      goalId: goalId,
      transaction: transaction,
    );
    if (row == null) {
      return OperationResult(success: true, message: 'Already deleted');
    }

    final now = service.clock.nowUtc();
    await MoneyGoalRow.db.updateRow(
      session,
      row.copyWith(
        deletedAt: now,
        updatedAt: now,
        version: row.version + 1,
      ),
      transaction: transaction,
    );

    await _emitGoalChange(
      service,
      session,
      familyId: familyId,
      goalId: goalId,
      operation: 'deleted',
      transaction: transaction,
    );

    return OperationResult(success: true, message: 'Goal deleted');
  });
}

Future<List<MoneyGoalDto>> _listGoalsImpl(
  MoneyGoalsService service,
  Session session, {
  required int familyId,
}) async {
  await service.rbac.ensureFamilyRole(
    session,
    familyId: familyId,
    minRole: 'member',
  );

  final rows = await MoneyGoalRow.db.find(
    session,
    where: (t) => t.familyId.equals(familyId) & t.deletedAt.equals(null),
  );
  rows.sort((left, right) {
    final leftArchived = left.archivedAt != null;
    final rightArchived = right.archivedAt != null;
    if (leftArchived != rightArchived) {
      return leftArchived ? 1 : -1;
    }
    return right.updatedAt.compareTo(left.updatedAt);
  });

  return rows.map(_mapGoal).toList();
}

Future<List<MoneyGoalHistoryEntryDto>> _listGoalHistoryImpl(
  MoneyGoalsService service,
  Session session, {
  required int familyId,
  required int goalId,
  int limit = 50,
}) async {
  await service.rbac.ensureFamilyRole(
    session,
    familyId: familyId,
    minRole: 'member',
  );

  final goal = await _lockGoalRowOrNull(
    session,
    familyId: familyId,
    goalId: goalId,
  );
  if (goal == null) {
    throw FileNotFoundException(message: 'Goal not found.');
  }

  final rows = await MoneyContributionRow.db.find(
    session,
    where: (t) => t.goalId.equals(goalId) & t.revokedAt.equals(null),
    limit: limit,
    orderBy: (t) => t.createdAt,
    orderDescending: true,
  );
  final profileIds = rows.map((row) => row.profileId).toSet();
  final profiles = profileIds.isEmpty
      ? <AppProfileRow>[]
      : await AppProfileRow.db.find(
          session,
          where: (t) => t.id.inSet(profileIds),
        );
  final profilesById = {for (final profile in profiles) profile.id!: profile};

  return rows
      .map(
        (row) => _mapHistoryEntry(
          row,
          profilesById[row.profileId],
        ),
      )
      .toList();
}
