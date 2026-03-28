import 'browser_notification_service.dart';

class BrowserNotificationServiceImpl implements BrowserNotificationService {
  @override
  bool get isSupported => false;

  @override
  String get permissionStatus => 'unsupported';

  @override
  Future<String?> requestPermission() async => permissionStatus;

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {}

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  }) async {}

  @override
  Future<void> cancel(int id) async {}
}
