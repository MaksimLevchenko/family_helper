import 'package:test/test.dart';
import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

void main() {
  withServerpod(
    'Task complete generateOnComplete',
    (sessionBuilder, endpoints) {
      test('parallel complete does not create duplicate next task', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-task-$runId',
          title: 'Tasks Family',
        );

        final task = await endpoints.tasks.upsertTask(
          owner,
          clientOperationId: 'task-create-$runId',
          familyId: family.id,
          title: 'Take out trash',
          isPersonal: false,
          priority: 'normal',
          dueAt: DateTime.utc(2026, 2, 13, 10, 0, 0),
          recurrenceMode: 'generateOnComplete',
          recurrenceRrule: 'FREQ=DAILY;INTERVAL=1',
        );

        final results = await Future.wait([
          endpoints.tasks.completeTask(
            owner,
            clientOperationId: 'task-complete-a-$runId',
            familyId: family.id,
            taskId: task.id,
          ),
          endpoints.tasks.completeTask(
            owner,
            clientOperationId: 'task-complete-b-$runId',
            familyId: family.id,
            taskId: task.id,
          ),
        ]);

        expect(results.first.status, 'completed');
        expect(results.last.status, 'completed');

        final generatedCount = await withDbSession(owner, (session) async {
          return TaskRow.db.count(
            session,
            where: (t) =>
                t.sourceTaskId.equals(task.id) & t.deletedAt.equals(null),
          );
        });

        expect(generatedCount, 1);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
