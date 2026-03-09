import 'package:test/test.dart';
import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

void main() {
  withServerpod(
    'Money contributions',
    (sessionBuilder, endpoints) {
      test('concurrent addContribution keeps aggregate consistent', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-money-$runId',
          title: 'Money Family',
        );

        final goal = await endpoints.moneyGoals.upsertGoal(
          owner,
          clientOperationId: 'goal-create-$runId',
          familyId: family.id,
          title: 'Vacation',
          targetAmountCents: 100000,
          currency: 'RUB',
        );

        await Future.wait([
          endpoints.moneyGoals.addContribution(
            owner,
            clientOperationId: 'contribution-a-$runId',
            familyId: family.id,
            goalId: goal.id,
            amountCents: 25000,
            currency: 'RUB',
          ),
          endpoints.moneyGoals.addContribution(
            owner,
            clientOperationId: 'contribution-b-$runId',
            familyId: family.id,
            goalId: goal.id,
            amountCents: 15000,
            currency: 'RUB',
          ),
        ]);

        final currentAmount = await withDbSession(owner, (session) async {
          final row = await MoneyGoalRow.db.findById(session, goal.id);
          return row!.currentAmountCents;
        });

        expect(currentAmount, 40000);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
