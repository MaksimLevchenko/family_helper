import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Task complete generateOnComplete', (sessionBuilder, endpoints) {
    test('parallel complete does not create duplicate next task', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-task-001',
        title: 'Tasks Family',
      );

      final task = await endpoints.tasks.upsertTask(
        owner,
        clientOperationId: 'task-create-001',
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
          clientOperationId: 'task-complete-001',
          familyId: family.id,
          taskId: task.id,
        ),
        endpoints.tasks.completeTask(
          owner,
          clientOperationId: 'task-complete-002',
          familyId: family.id,
          taskId: task.id,
        ),
      ]);

      expect(results.first.status, 'completed');
      expect(results.last.status, 'completed');

      final generatedCount = await withDbSession(owner, (session) async {
        final rows = await session.db.unsafeQuery(
          '''
          SELECT COUNT(*) AS total
          FROM task
          WHERE source_task_id = @sourceTaskId
            AND deleted_at IS NULL
          ''',
          parameters: QueryParameters.named({'sourceTaskId': task.id}),
        );
        return rows.first.toColumnMap()['total'] as int;
      });

      expect(generatedCount, 1);
    });
  });
}
