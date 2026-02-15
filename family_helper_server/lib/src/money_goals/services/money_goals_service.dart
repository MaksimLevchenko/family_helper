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
        final inserted = await session.db.unsafeQuery(
          '''
          INSERT INTO money_goal (
            family_id,
            title,
            description,
            target_amount_cents,
            current_amount_cents,
            currency,
            deadline_at,
            reached_at,
            created_by_profile_id,
            created_at,
            updated_at,
            deleted_at,
            version
          ) VALUES (
            @familyId,
            @title,
            @description,
            @targetAmount,
            0,
            @currency,
            @deadlineAt,
            NULL,
            @createdBy,
            @now,
            @now,
            NULL,
            1
          )
          RETURNING
            id,
            family_id,
            title,
            description,
            target_amount_cents,
            current_amount_cents,
            currency,
            deadline_at,
            reached_at,
            updated_at,
            version
          ''',
          parameters: QueryParameters.named({
            'familyId': familyId,
            'title': title,
            'description': description,
            'targetAmount': targetAmountCents,
            'currency': currency,
            'deadlineAt': deadlineAt?.toUtc(),
            'createdBy': actorProfileId,
            'now': now,
          }),
          transaction: transaction,
        );
        final dto = _mapGoal(inserted.first.toColumnMap());
        await _emitGoalChange(
          session,
          familyId: familyId,
          goalId: dto.id,
          operation: 'upserted',
          transaction: transaction,
        );
        return dto;
      }

      await session.db.unsafeExecute(
        '''
        UPDATE money_goal
        SET
          title = @title,
          description = @description,
          target_amount_cents = @targetAmount,
          currency = @currency,
          deadline_at = @deadlineAt,
          updated_at = @updatedAt,
          version = version + 1
        WHERE id = @id
          AND family_id = @familyId
          AND deleted_at IS NULL
        ''',
        parameters: QueryParameters.named({
          'id': goalId,
          'familyId': familyId,
          'title': title,
          'description': description,
          'targetAmount': targetAmountCents,
          'currency': currency,
          'deadlineAt': deadlineAt?.toUtc(),
          'updatedAt': now,
        }),
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

      final lockedGoalRows = await session.db.unsafeQuery(
        '''
        SELECT
          id,
          family_id,
          title,
          description,
          target_amount_cents,
          current_amount_cents,
          currency,
          deadline_at,
          reached_at,
          updated_at,
          version
        FROM money_goal
        WHERE id = @goalId
          AND family_id = @familyId
          AND deleted_at IS NULL
        FOR UPDATE
        ''',
        parameters: QueryParameters.named({'goalId': goalId, 'familyId': familyId}),
        transaction: transaction,
      );
      if (lockedGoalRows.isEmpty) {
        throw Exception('Goal not found');
      }

      final goal = _mapGoal(lockedGoalRows.first.toColumnMap());
      if (goal.currency != currency) {
        throw Exception('Contribution currency must match goal currency');
      }

      if (!started) {
        final existing = await session.db.unsafeQuery(
          '''
          SELECT
            id,
            goal_id,
            profile_id,
            amount_cents,
            currency,
            note,
            created_at,
            revoked_at
          FROM money_contribution
          WHERE goal_id = @goalId
            AND client_operation_id = @clientOperationId
          LIMIT 1
          ''',
          parameters: QueryParameters.named({
            'goalId': goalId,
            'clientOperationId': clientOperationId,
          }),
          transaction: transaction,
        );

        if (existing.isNotEmpty) {
          return _mapContribution(existing.first.toColumnMap());
        }
      }

      final now = DateTime.now().toUtc();
      final contributionRows = await session.db.unsafeQuery(
        '''
        INSERT INTO money_contribution (
          goal_id,
          profile_id,
          amount_cents,
          currency,
          note,
          client_operation_id,
          created_at,
          revoked_at
        ) VALUES (
          @goalId,
          @profileId,
          @amountCents,
          @currency,
          @note,
          @clientOperationId,
          @createdAt,
          NULL
        )
        ON CONFLICT (goal_id, client_operation_id)
        DO NOTHING
        RETURNING
          id,
          goal_id,
          profile_id,
          amount_cents,
          currency,
          note,
          created_at,
          revoked_at
        ''',
        parameters: QueryParameters.named({
          'goalId': goalId,
          'profileId': actorProfileId,
          'amountCents': amountCents,
          'currency': currency,
          'note': note,
          'clientOperationId': clientOperationId,
          'createdAt': now,
        }),
        transaction: transaction,
      );

      MoneyContributionDto contribution;
      if (contributionRows.isEmpty) {
        final existing = await session.db.unsafeQuery(
          '''
          SELECT
            id,
            goal_id,
            profile_id,
            amount_cents,
            currency,
            note,
            created_at,
            revoked_at
          FROM money_contribution
          WHERE goal_id = @goalId
            AND client_operation_id = @clientOperationId
          LIMIT 1
          ''',
          parameters: QueryParameters.named({
            'goalId': goalId,
            'clientOperationId': clientOperationId,
          }),
          transaction: transaction,
        );
        contribution = _mapContribution(existing.first.toColumnMap());
      } else {
        contribution = _mapContribution(contributionRows.first.toColumnMap());
      }

      await session.db.unsafeExecute(
        '''
        UPDATE money_goal
        SET
          current_amount_cents = current_amount_cents + @amountCents,
          reached_at = CASE
            WHEN reached_at IS NULL AND current_amount_cents + @amountCents >= target_amount_cents
              THEN @now
            ELSE reached_at
          END,
          updated_at = @now,
          version = version + 1
        WHERE id = @goalId
        ''',
        parameters: QueryParameters.named({
          'goalId': goalId,
          'amountCents': amountCents,
          'now': now,
        }),
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

    final rows = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        title,
        description,
        target_amount_cents,
        current_amount_cents,
        currency,
        deadline_at,
        reached_at,
        updated_at,
        version
      FROM money_goal
      WHERE family_id = @familyId
        AND deleted_at IS NULL
      ORDER BY id DESC
      ''',
      parameters: QueryParameters.named({'familyId': familyId}),
    );

    return rows.map((row) => _mapGoal(row.toColumnMap())).toList();
  }

  Future<MoneyGoalDto> _findGoal(
    Session session,
    int goalId, {
    Transaction? transaction,
  }) async {
    final rows = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        title,
        description,
        target_amount_cents,
        current_amount_cents,
        currency,
        deadline_at,
        reached_at,
        updated_at,
        version
      FROM money_goal
      WHERE id = @id
      LIMIT 1
      ''',
      parameters: QueryParameters.named({'id': goalId}),
      transaction: transaction,
    );

    return _mapGoal(rows.first.toColumnMap());
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

  MoneyGoalDto _mapGoal(Map<String, dynamic> row) {
    return MoneyGoalDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int,
      title: row['title'] as String,
      description: row['description'] as String?,
      targetAmountCents: row['target_amount_cents'] as int,
      currentAmountCents: row['current_amount_cents'] as int,
      currency: row['currency'] as String,
      deadlineAt: row['deadline_at'] as DateTime?,
      reachedAt: row['reached_at'] as DateTime?,
      updatedAt: row['updated_at'] as DateTime,
      version: row['version'] as int,
    );
  }

  MoneyContributionDto _mapContribution(Map<String, dynamic> row) {
    return MoneyContributionDto(
      id: row['id'] as int,
      goalId: row['goal_id'] as int,
      profileId: row['profile_id'] as int,
      amountCents: row['amount_cents'] as int,
      currency: row['currency'] as String,
      note: row['note'] as String?,
      createdAt: row['created_at'] as DateTime,
      revokedAt: row['revoked_at'] as DateTime?,
    );
  }
}
