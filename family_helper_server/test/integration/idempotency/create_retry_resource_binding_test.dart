import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Create retry resource binding', (sessionBuilder, endpoints) {
    test('calendar create retry returns the original event', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'binding-family-calendar-001',
        title: 'Calendar Binding Family',
      );

      final first = await endpoints.calendar.upsertEvent(
        owner,
        clientOperationId: 'binding-calendar-create-001',
        familyId: family.id,
        title: 'Dinner',
        startsAt: DateTime.utc(2026, 3, 10, 18, 0),
        endsAt: DateTime.utc(2026, 3, 10, 19, 0),
        timezone: 'UTC',
      );
      final second = await endpoints.calendar.upsertEvent(
        owner,
        clientOperationId: 'binding-calendar-create-001',
        familyId: family.id,
        title: 'Changed title',
        startsAt: DateTime.utc(2026, 3, 11, 18, 0),
        endsAt: DateTime.utc(2026, 3, 11, 19, 0),
        timezone: 'Europe/Moscow',
      );

      expect(second.id, first.id);
      expect(second.title, first.title);
      expect(second.startsAt, first.startsAt);
    });

    test('list create retry returns the original list', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'binding-family-list-001',
        title: 'List Binding Family',
      );

      final first = await endpoints.lists.upsertList(
        owner,
        clientOperationId: 'binding-list-create-001',
        familyId: family.id,
        title: 'Shopping',
        listType: 'shopping',
      );
      final second = await endpoints.lists.upsertList(
        owner,
        clientOperationId: 'binding-list-create-001',
        familyId: family.id,
        title: 'Errand',
        listType: 'todo',
      );

      expect(second.id, first.id);
      expect(second.title, first.title);
      expect(second.listType, first.listType);
    });

    test('goal create retry returns the original goal', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'binding-family-goal-001',
        title: 'Goal Binding Family',
      );

      final first = await endpoints.moneyGoals.upsertGoal(
        owner,
        clientOperationId: 'binding-goal-create-001',
        familyId: family.id,
        title: 'Vacation',
        targetAmountCents: 100000,
        currency: 'RUB',
      );
      final second = await endpoints.moneyGoals.upsertGoal(
        owner,
        clientOperationId: 'binding-goal-create-001',
        familyId: family.id,
        title: 'Different title',
        targetAmountCents: 200000,
        currency: 'USD',
      );

      expect(second.id, first.id);
      expect(second.title, first.title);
      expect(second.currency, first.currency);
    });

    test('task create retry returns the original task', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'binding-family-task-001',
        title: 'Task Binding Family',
      );

      final first = await endpoints.tasks.upsertTask(
        owner,
        clientOperationId: 'binding-task-create-001',
        familyId: family.id,
        title: 'Take out trash',
        isPersonal: false,
        priority: 'normal',
      );
      final second = await endpoints.tasks.upsertTask(
        owner,
        clientOperationId: 'binding-task-create-001',
        familyId: family.id,
        title: 'Different task',
        isPersonal: true,
        priority: 'high',
      );

      expect(second.id, first.id);
      expect(second.title, first.title);
      expect(second.isPersonal, first.isPersonal);
    });
  });
}
