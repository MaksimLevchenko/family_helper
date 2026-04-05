import 'package:family_helper_server/src/generated/protocol.dart';
import 'package:family_helper_server/src/notifications/services/app_notification_service.dart';
import 'package:family_helper_server/src/notifications/services/notifications_service.dart';
import 'package:test/test.dart';

void main() {
  group('buildDeactivatedDuplicatePushTokens', () {
    test('deactivates the same token for other profiles only', () {
      final now = DateTime.utc(2026, 3, 28, 10, 0);
      final tokens = [
        PushTokenRow(
          id: 1,
          profileId: 10,
          token: 'shared-token',
          platform: 'android',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
          version: 1,
        ),
        PushTokenRow(
          id: 2,
          profileId: 11,
          token: 'shared-token',
          platform: 'android',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
          version: 4,
        ),
        PushTokenRow(
          id: 3,
          profileId: 11,
          token: 'another-token',
          platform: 'android',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
          version: 2,
        ),
        PushTokenRow(
          id: 4,
          profileId: 12,
          token: 'shared-token',
          platform: 'android',
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
          deletedAt: now.subtract(const Duration(hours: 1)),
          version: 3,
        ),
      ];

      final deactivated = buildDeactivatedDuplicatePushTokens(
        tokens: tokens,
        profileId: 11,
        token: 'shared-token',
        now: now,
      );

      expect(deactivated, hasLength(1));
      expect(deactivated.single.id, 1);
      expect(deactivated.single.deletedAt, now);
      expect(deactivated.single.updatedAt, now);
      expect(deactivated.single.version, 2);
    });
  });

  group('buildAppNotificationPayload', () {
    test('injects canonical navigation fields and preserves payload', () {
      final payload = buildAppNotificationPayload(
        familyId: 7,
        entityType: 'task',
        entityId: 11,
        route: '/home/tasks',
        payload: {
          'category': 'task_assigned',
          'taskId': 11,
        },
      );

      expect(payload['familyId'], 7);
      expect(payload['entityType'], 'task');
      expect(payload['entityId'], 11);
      expect(payload['route'], '/home/tasks');
      expect(payload['taskId'], 11);
      expect(payload['category'], 'task_assigned');
    });

    test('fills default routes for due reminders and debug notifications', () {
      final dueReminderPayload = buildAppNotificationPayload(
        familyId: 9,
        entityType: 'calendar',
        entityId: 42,
        payload: {
          'occurrenceStart': '2026-04-05T12:00:00.000Z',
        },
      );
      final debugPayload = buildAppNotificationPayload(
        familyId: 9,
        entityType: 'notification',
        entityId: 99,
        payload: {
          'category': 'debug_test_push',
        },
      );
      final familyInvitePayload = buildAppNotificationPayload(
        familyId: 9,
        entityType: 'invite',
        entityId: 77,
        payload: {
          'inviteId': 77,
          'category': 'family_invite_created',
        },
      );

      expect(dueReminderPayload['route'], '/home/calendar');
      expect(dueReminderPayload['entityType'], 'calendar');
      expect(dueReminderPayload['entityId'], 42);
      expect(debugPayload['route'], '/home/notifications/settings');
      expect(debugPayload['entityType'], 'notification');
      expect(debugPayload['entityId'], 99);
      expect(familyInvitePayload['route'], '/home/settings/family');
      expect(familyInvitePayload['entityType'], 'invite');
      expect(familyInvitePayload['entityId'], 77);
    });
  });
}
