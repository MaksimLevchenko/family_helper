import 'package:test/test.dart';

import 'package:family_helper_server/src/core/auth/auth_context.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Notifications self delivery',
    (sessionBuilder, endpoints) {
      test('calendar event creation creates a self notification', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        await _registerPushToken(
          endpoints,
          owner,
          suffix: 'calendar-$runId',
        );

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-calendar-self-$runId',
          title: 'Calendar Self Family',
        );

        final event = await endpoints.calendar.upsertEvent(
          owner,
          clientOperationId: 'calendar-create-self-$runId',
          familyId: family.id,
          title: 'Doctor visit',
          startsAt: DateTime.utc(2026, 4, 1, 10, 0),
          endsAt: DateTime.utc(2026, 4, 1, 11, 0),
          timezone: 'UTC',
          scope: 'all',
        );

        final notifications = await _loadNotifications(
          owner,
          familyId: family.id,
          category: 'calendar_created',
        );

        expect(notifications, hasLength(1));
        expect(notifications.single.entityType, 'calendar');
        expect(notifications.single.entityId, event.id);
        expect(notifications.single.pushStatus, 'skipped');
      });

      test('task completion creates a self notification', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        await _registerPushToken(
          endpoints,
          owner,
          suffix: 'task-$runId',
        );

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-task-self-$runId',
          title: 'Task Self Family',
        );

        final task = await endpoints.tasks.upsertTask(
          owner,
          clientOperationId: 'task-create-self-$runId',
          familyId: family.id,
          title: 'Wash dishes',
          isPersonal: false,
          priority: 'normal',
        );

        await endpoints.tasks.completeTask(
          owner,
          clientOperationId: 'task-complete-self-$runId',
          familyId: family.id,
          taskId: task.id,
        );

        final notifications = await _loadNotifications(
          owner,
          familyId: family.id,
          category: 'task_completed',
        );

        expect(notifications, hasLength(1));
        expect(notifications.single.entityType, 'task');
        expect(notifications.single.entityId, task.id);
        expect(notifications.single.pushStatus, 'skipped');
      });

      test('family invite creation creates a self notification', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        await _registerPushToken(
          endpoints,
          owner,
          suffix: 'invite-created-$runId',
        );

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-invite-self-$runId',
          title: 'Invite Self Family',
        );

        final invite = await endpoints.family.createInvite(
          owner,
          familyId: family.id,
          clientOperationId: 'family-invite-self-$runId',
          inviteType: 'code',
        );

        final notifications = await _loadNotifications(
          owner,
          familyId: family.id,
          category: 'family_invite_created',
        );

        expect(notifications, hasLength(1));
        expect(notifications.single.entityType, 'invite');
        expect(notifications.single.entityId, invite.id);
        expect(notifications.single.pushStatus, 'skipped');
      });

      test('family invite acceptance creates a self notification', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final member = authenticatedBuilder(sessionBuilder, user2Id);
        final runId = DateTime.now().microsecondsSinceEpoch;

        final family = await endpoints.family.createFamily(
          owner,
          clientOperationId: 'family-create-accept-self-$runId',
          title: 'Accept Self Family',
        );

        final invite = await endpoints.family.createInvite(
          owner,
          familyId: family.id,
          clientOperationId: 'family-invite-accept-self-$runId',
          inviteType: 'code',
        );

        await _registerPushToken(
          endpoints,
          member,
          suffix: 'invite-accepted-$runId',
        );

        await endpoints.family.acceptInvite(
          member,
          clientOperationId: 'family-accept-self-$runId',
          tokenOrCode: invite.inviteCode,
        );

        final notifications = await _loadNotifications(
          member,
          familyId: family.id,
          category: 'family_invite_accepted',
        );

        expect(notifications, hasLength(1));
        expect(notifications.single.entityType, 'invite');
        expect(notifications.single.entityId, invite.id);
        expect(notifications.single.pushStatus, 'skipped');
      });
    },
  );
}

Future<void> _registerPushToken(
  TestEndpoints endpoints,
  TestSessionBuilder builder, {
  required String suffix,
}) async {
  final result = await endpoints.notifications.registerPushToken(
    builder,
    clientOperationId: 'register-push-token-$suffix',
    token: 'fcm-token-$suffix',
    platform: 'android',
    provider: 'fcm',
    deviceId: 'device-$suffix',
    appVersion: '1.0.0',
  );
  expect(result.success, isTrue);
}

Future<List<AppNotificationRow>> _loadNotifications(
  TestSessionBuilder builder, {
  required int familyId,
  required String category,
}) async {
  final authContext = const AuthContext();
  return withDbSession(builder, (session) async {
    final profileId = await authContext.ensureProfileId(session);
    return AppNotificationRow.db.find(
      session,
      where: (t) =>
          t.profileId.equals(profileId) &
          t.familyId.equals(familyId) &
          t.category.equals(category),
      orderBy: (t) => t.id,
    );
  });
}
