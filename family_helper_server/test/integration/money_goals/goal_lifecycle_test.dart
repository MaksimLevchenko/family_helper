import 'package:test/test.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Money goal lifecycle',
    (sessionBuilder, endpoints) {
      test('withdraw, archive, delete, and expose history actors', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final member = authenticatedBuilder(sessionBuilder, user2Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-goal-lifecycle-$runId',
          title: 'Goal Lifecycle Family',
        );

        await endpoints.profile.update(
          owner,
          clientOperationId: 'profile-owner-goal-lifecycle-$runId',
          displayName: 'Owner Tester',
          clearAvatarMedia: false,
        );

        final invite = await endpoints.family.createInvite(
          owner,
          familyId: family.id,
          clientOperationId: 'family-invite-goal-lifecycle-$runId',
          inviteType: 'code',
        );

        await endpoints.family.acceptInvite(
          member,
          clientOperationId: 'family-accept-goal-lifecycle-$runId',
          tokenOrCode: invite.inviteCode,
        );

        await endpoints.profile.update(
          member,
          clientOperationId: 'profile-member-goal-lifecycle-$runId',
          displayName: 'Member Tester',
          clearAvatarMedia: false,
        );

        final goal = await endpoints.moneyGoals.upsertGoal(
          owner,
          clientOperationId: 'goal-create-lifecycle-$runId',
          familyId: family.id,
          title: 'Renovation',
          targetAmountCents: 100000,
          currency: 'RUB',
        );

        await endpoints.moneyGoals.addContribution(
          owner,
          clientOperationId: 'goal-contribution-lifecycle-$runId',
          familyId: family.id,
          goalId: goal.id,
          amountCents: 40000,
          currency: 'RUB',
        );

        await endpoints.moneyGoals.withdrawFunds(
          member,
          clientOperationId: 'goal-withdraw-lifecycle-$runId',
          familyId: family.id,
          goalId: goal.id,
          amountCents: 15000,
          currency: 'RUB',
        );

        final history = await endpoints.moneyGoals.listGoalHistory(
          owner,
          familyId: family.id,
          goalId: goal.id,
          limit: 50,
        );

        expect(history, hasLength(2));
        expect(history.first.actorDisplayName, 'Member Tester');
        expect(history.first.amountCents, -15000);
        expect(history.last.actorDisplayName, 'Owner Tester');
        expect(history.last.amountCents, 40000);

        final archivedGoal = await endpoints.moneyGoals.archiveGoal(
          owner,
          clientOperationId: 'goal-archive-lifecycle-$runId',
          familyId: family.id,
          goalId: goal.id,
        );

        expect(archivedGoal.currentAmountCents, 25000);
        expect(archivedGoal.archivedAt, isNotNull);
        expect(archivedGoal.reachedAt, isNotNull);

        final listedGoals = await endpoints.moneyGoals.listGoals(
          owner,
          familyId: family.id,
        );
        expect(listedGoals.single.archivedAt, isNotNull);

        final deleteResult = await endpoints.moneyGoals.deleteGoal(
          owner,
          clientOperationId: 'goal-delete-lifecycle-$runId',
          familyId: family.id,
          goalId: goal.id,
        );

        expect(deleteResult.success, isTrue);

        final afterDelete = await endpoints.moneyGoals.listGoals(
          owner,
          familyId: family.id,
        );
        expect(afterDelete, isEmpty);

        final deletedRow = await withDbSession(owner, (session) async {
          return MoneyGoalRow.db.findById(session, goal.id);
        });
        expect(deletedRow?.deletedAt, isNotNull);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
