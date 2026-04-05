import 'dart:convert';

import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/features/notifications/data/notification_target.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotificationOpenTarget', () {
    test('builds from app notification with sparse payloadJson', () {
      final notification = AppNotificationDto(
        id: 12,
        profileId: 3,
        familyId: 7,
        category: 'task_assigned',
        title: 'Assigned',
        body: 'Task body',
        entityType: 'task',
        entityId: 44,
        route: '/home/tasks',
        payloadJson: jsonEncode({'taskId': 44}),
        isRead: false,
        createdAt: DateTime.utc(2026, 4, 5),
        pushStatus: 'pending',
        version: 1,
      );

      final target = NotificationOpenTarget.fromAppNotification(notification);

      expect(target, isNotNull);
      expect(target!.familyId, 7);
      expect(target.entityType, 'task');
      expect(target.entityId, 44);
      expect(target.route, '/home/tasks');
      expect(target.payload!['taskId'], 44);
    });

    test('merges outer push data with nested payloadJson', () {
      final target = NotificationOpenTarget.fromDataMap({
        'notificationId': '21',
        'familyId': '5',
        'entityType': 'calendar',
        'entityId': '88',
        'route': '/home/calendar',
        'payloadJson': jsonEncode({
          'eventId': 88,
          'occurrenceStart': '2026-04-05T12:30:00.000Z',
        }),
      });

      expect(target, isNotNull);
      expect(target!.entityType, 'calendar');
      expect(target.entityId, 88);
      expect(target.route, '/home/calendar');
      expect(
        target.occurrenceStart,
        DateTime.utc(2026, 4, 5, 12, 30).toLocal(),
      );
    });

    test('opens family invite notifications via invite target', () {
      final target = NotificationOpenTarget.fromDataMap({
        'familyId': 9,
        'inviteId': 101,
        'route': '/home/settings/family',
        'payloadJson': jsonEncode({
          'category': 'family_invite_created',
        }),
      });

      expect(target, isNotNull);
      expect(target!.entityType, 'invite');
      expect(target.entityId, 101);
      expect(target.route, '/home/settings/family');
    });
  });

  group('buildNotificationTargetPayloadJson', () {
    test('creates payload for local task reminders', () {
      final raw = buildNotificationTargetPayloadJson(
        familyId: 4,
        entityType: 'task',
        entityId: 33,
        payload: {'taskId': 33},
      );
      final payload = jsonDecode(raw) as Map<String, dynamic>;

      expect(payload['familyId'], 4);
      expect(payload['entityType'], 'task');
      expect(payload['entityId'], 33);
      expect(payload['route'], '/home/tasks');
      expect(payload['taskId'], 33);
    });

    test('creates payload for local calendar reminders', () {
      final raw = buildNotificationTargetPayloadJson(
        familyId: 4,
        entityType: 'calendar',
        entityId: 77,
        payload: {
          'eventId': 77,
          'occurrenceStart': '2026-04-05T14:00:00.000Z',
        },
      );
      final payload = jsonDecode(raw) as Map<String, dynamic>;

      expect(payload['familyId'], 4);
      expect(payload['entityType'], 'calendar');
      expect(payload['entityId'], 77);
      expect(payload['route'], '/home/calendar');
      expect(payload['occurrenceStart'], '2026-04-05T14:00:00.000Z');
    });

    test('creates payload for debug notification route', () {
      final raw = buildNotificationTargetPayloadJson(
        familyId: 4,
        entityType: 'notification',
        entityId: 55,
        payload: {'category': 'debug_test_push'},
      );
      final payload = jsonDecode(raw) as Map<String, dynamic>;

      expect(payload['route'], '/home/notifications/settings');
      expect(payload['entityType'], 'notification');
      expect(payload['entityId'], 55);
    });
  });
}
