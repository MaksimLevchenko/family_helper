import 'package:family_helper_flutter/features/notifications/data/local_notification_service.dart';
import 'package:family_helper_flutter/features/notifications/domain/notification_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'maps Android permission states to not determined before first prompt',
    () {
      final status = LocalNotificationService.mapAndroidPermissionStatus(
        const {
          'isGranted': false,
          'notificationsEnabled': false,
          'needsRuntimePermission': true,
          'canAskAgain': false,
        },
        requestedBefore: false,
      );

      expect(status, NotificationPermissionStatus.notDetermined);
    },
  );

  test('maps Android blocked notifications to permanently denied', () {
    final status = LocalNotificationService.mapAndroidPermissionStatus(
      const {
        'isGranted': false,
        'notificationsEnabled': false,
        'needsRuntimePermission': false,
        'canAskAgain': false,
      },
      requestedBefore: true,
    );

    expect(status, NotificationPermissionStatus.permanentlyDenied);
  });

  test('maps Darwin granted and denied statuses', () {
    expect(
      LocalNotificationService.mapDarwinPermissionStatus('granted'),
      NotificationPermissionStatus.granted,
    );
    expect(
      LocalNotificationService.mapDarwinPermissionStatus('denied'),
      NotificationPermissionStatus.denied,
    );
  });
}
