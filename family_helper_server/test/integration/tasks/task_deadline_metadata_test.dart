import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Task deadline metadata persistence',
    (sessionBuilder, endpoints) {
      test('upsertTask persists relative deadline metadata', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-deadline-$runId',
          title: 'Deadline Metadata Family',
        );

        final created = await endpoints.tasks.upsertTask(
          owner,
          clientOperationId: 'task-create-deadline-$runId',
          familyId: family.id,
          title: 'Take vitamins',
          isPersonal: false,
          priority: 'normal',
          dueAt: DateTime.utc(2026, 3, 29, 12),
          dueInputMode: 'relative',
          dueOffsetValue: 3,
          dueOffsetUnit: 'days',
        );

        expect(created.dueInputMode, 'relative');
        expect(created.dueOffsetValue, 3);
        expect(created.dueOffsetUnit, 'days');

        final listed = await endpoints.tasks.listTasks(
          owner,
          familyId: family.id,
        );
        final reloaded = listed.singleWhere((task) => task.id == created.id);

        expect(reloaded.dueAt, DateTime.utc(2026, 3, 29, 12));
        expect(reloaded.dueInputMode, 'relative');
        expect(reloaded.dueOffsetValue, 3);
        expect(reloaded.dueOffsetUnit, 'days');
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
