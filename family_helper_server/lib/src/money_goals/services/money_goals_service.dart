import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class MoneyGoalsService {
  MoneyGoalsService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
  });

  final AuthContext authContext;
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

      final now = DateTime.now().toUtc();
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
            createdByProfileId: actorProfileId,
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
            version: 1,
          ),
          transaction: transaction,
        );
        final dto = _mapGoal(inserted);
        await _emitGoalChange(
          session,
          familyId: familyId,
          goalId: dto.id,
          operation: 'upserted',
          transaction: transaction,
        );
        return dto;
      }

      final row = await MoneyGoalRow.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(goalId) &
            t.familyId.equals(familyId) &
            t.deletedAt.equals(null),
        transaction: transaction,
      );
      if (row == null) throw Exception('Goal not found');
      await MoneyGoalRow.db.updateRow(
        session,
        row.copyWith(
          title: title,
          description: description,
          targetAmountCents: targetAmountCents,
          currency: currency,
          deadlineAt: deadlineAt?.toUtc(),
          updatedAt: now,
          version: row.version + 1,
        ),
        transaction: transaction,
      );

      final updated = await _findGoal(session, goalId, transaction: transaction);
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
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final started = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'money.addContribution',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final goalRow = await MoneyGoalRow.db.findFirstRow(
        session,
        where: (t) =>
            t.id.equals(goalId) &
            t.familyId.equals(familyId) &
            t.deletedAt.equals(null),
        transaction: transaction,
      );
      if (goalRow == null) {
        throw Exception('Goal not found');
      }

      final goal = _mapGoal(goalRow);
      if (goal.currency != currency) {
        throw Exception('Contribution currency must match goal currency');
      }

      if (!started) {
        final existing = await MoneyContributionRow.db.findFirstRow(
          session,
          where: (t) =>
              t.goalId.equals(goalId) &
              t.clientOperationId.equals(clientOperationId),
          transaction: transaction,
        );

        if (existing != null) {
          return _mapContribution(existing);
        }
      }

      final now = DateTime.now().toUtc();
      final contributionRow = await MoneyContributionRow.db.findFirstRow(
            session,
            where: (t) =>
                t.goalId.equals(goalId) &
                t.clientOperationId.equals(clientOperationId),
            transaction: transaction,
          ) ??
          await MoneyContributionRow.db.insertRow(
            session,
            MoneyContributionRow(
              goalId: goalId,
              profileId: actorProfileId,
              amountCents: amountCents,
              currency: currency,
              note: note,
              clientOperationId: clientOperationId,
              createdAt: now,
              revokedAt: null,
            ),
            transaction: transaction,
          );
      final contribution = _mapContribution(contributionRow);

      final nextAmount = goalRow.currentAmountCents + amountCents;
      final nextReachedAt =
          goalRow.reachedAt == null && nextAmount >= goalRow.targetAmountCents
          ? now
          : goalRow.reachedAt;
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
        operation: 'contribution_added',
        transaction: transaction,
      );

      return contribution;
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
      orderBy: (t) => t.id,
      orderDescending: true,
    );

    return rows.map(_mapGoal).toList();
  }

  Future<MoneyGoalDto> _findGoal(
    Session session,
    int goalId, {
    Transaction? transaction,
  }) async {
    final row = await MoneyGoalRow.db.findById(
      session,
      goalId,
      transaction: transaction,
    );
    return _mapGoal(row!);
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
        eventType: operation == 'contribution_added'
            ? 'contribution_added'
            : 'money_goal.updated',
        changedAt: DateTime.now().toUtc(),
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
}


