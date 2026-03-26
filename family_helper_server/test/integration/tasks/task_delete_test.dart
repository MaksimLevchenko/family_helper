import 'package:family_helper_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Task delete',
    (sessionBuilder, endpoints) {
      test('deleteTask soft deletes task and is idempotent', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-task-delete-$runId',
          title: 'Task Delete Family',
        );

        final task = await endpoints.tasks.upsertTask(
          owner,
          clientOperationId: 'task-create-delete-$runId',
          familyId: family.id,
          title: 'Delete me',
          isPersonal: false,
          priority: 'normal',
        );

        final firstDelete = await endpoints.tasks.deleteTask(
          owner,
          clientOperationId: 'task-delete-a-$runId',
          familyId: family.id,
          taskId: task.id,
        );
        final secondDelete = await endpoints.tasks.deleteTask(
          owner,
          clientOperationId: 'task-delete-b-$runId',
          familyId: family.id,
          taskId: task.id,
        );

        expect(firstDelete.success, isTrue);
        expect(firstDelete.message, 'Task deleted');
        expect(secondDelete.success, isTrue);
        expect(secondDelete.message, 'Already deleted');

        final listedTasks = await endpoints.tasks.listTasks(
          owner,
          familyId: family.id,
        );
        expect(listedTasks.where((item) => item.id == task.id), isEmpty);

        final deletedRow = await withDbSession(owner, (session) async {
          return TaskRow.db.findById(session, task.id);
        });
        expect(deletedRow, isNotNull);
        expect(deletedRow!.deletedAt, isNotNull);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
