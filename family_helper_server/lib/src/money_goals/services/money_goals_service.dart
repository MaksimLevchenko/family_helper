import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

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
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'money.upsertGoal',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh && goalId != null) {
        return _findGoal(session, goalId, transaction: transaction);
      }
      if (!isFresh) {
        final binding = await idempotency.getBinding(
          session,
          actorAuthUserId: authUserId,
          action: 'money.upsertGoal',
          clientOperationId: clientOperationId,
          transaction: transaction,
        );
        if (binding?.resourceType == 'money_goal') {
          return _findGoal(
            session,
            binding!.resourceId,
            transaction: transaction,
          );
        }
      }

      final now = clock.nowUtc();
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
        await idempotency.bindResource(
          session,
          actorAuthUserId: authUserId,
          action: 'money.upsertGoal',
          clientOperationId: clientOperationId,
          resourceType: 'money_goal',
          resourceId: dto.id,
          transaction: transaction,
        );
        await _emitGoalChange(
          session,
          familyId: familyId,
          goalId: dto.id,
          operation: 'upserted',
          transaction: transaction,
        );
        return dto;
      }

      final row = await _lockGoalRow(
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
        session,
        goalId,
        transaction: transaction,
      );
      await _emitGoalChange(
        session,
        familyId: familyId,
        goalId: updated.id,
        operation: 'upserted',
        transaction: transaction,
      );
      return updated;
    });
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
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'money.archiveGoal',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (!isFresh) {
        return _findGoal(session, goalId, transaction: transaction);
      }

      final row = await _lockGoalRow(
        session,
        familyId: familyId,
        goalId: goalId,
        transaction: transaction,
      );
      if (row.archivedAt != null) {
        return _mapGoal(row);
      }

      final now = clock.nowUtc();
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
        session,
        goalId,
        transaction: transaction,
      );
      await _emitGoalChange(
        session,
        familyId: familyId,
        goalId: goalId,
        operation: 'archived',
        transaction: transaction,
      );
      return updatedGoal;
    });
  }

  Future<OperationResult> deleteGoal(
    Session session, {
    required String clientOperationId,
    required int familyId,
    required int goalId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
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

      final now = clock.nowUtc();
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
        session,
        familyId: familyId,
        goalId: goalId,
        operation: 'deleted',
        transaction: transaction,
      );

      return OperationResult(success: true, message: 'Goal deleted');
    });
  }

  Future<List<MoneyGoalDto>> listGoals(
    Session session, {
    required int familyId,
  }) async {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');

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

  Future<List<MoneyGoalHistoryEntryDto>> listGoalHistory(
    Session session, {
    required int familyId,
    required int goalId,
    int limit = 50,
  }) async {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');

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

  Future<MoneyGoalDto> _findGoal(
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

    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: action,
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final goalRow = await _lockGoalRow(
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

      final now = clock.nowUtc();
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
    Session session, {
    required int familyId,
    required int goalId,
    required String operation,
    Transaction? transaction,
  }) async {
    await changeFeed.appendChange(
      session,
      feature: 'money_goals',
      entityType: 'goal',
      entityId: goalId,
      operation: operation,
      familyId: familyId,
      version: 1,
      transaction: transaction,
    );

    await realtime.publish(
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
        changedAt: clock.nowUtc(),
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
}
