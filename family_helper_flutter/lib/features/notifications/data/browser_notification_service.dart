import 'browser_notification_service_stub.dart'
    if (dart.library.html) 'browser_notification_service_web.dart';

abstract class BrowserNotificationService {
  factory BrowserNotificationService() = BrowserNotificationServiceImpl;

  bool get isSupported;

  String get permissionStatus;

  Future<String?> requestPermission();

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  });

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  });

  Future<void> cancel(int id);
}
