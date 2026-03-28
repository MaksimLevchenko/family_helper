// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

import 'browser_notification_service.dart';

class BrowserNotificationServiceImpl implements BrowserNotificationService {
  final Map<int, Timer> _scheduledTimers = <int, Timer>{};

  @override
  bool get isSupported => html.Notification.supported;

  @override
  String get permissionStatus {
    if (!isSupported) {
      return 'unsupported';
    }
    return html.Notification.permission ?? 'default';
  }

  @override
  Future<String?> requestPermission() async {
    if (!isSupported) {
      return permissionStatus;
    }
    return html.Notification.requestPermission();
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_canShowNotifications) {
      return;
    }

    final notification = html.Notification(
      title,
      body: body,
      tag: '$id',
    );
    notification.onClick.listen((_) {
      notification.close();
    });
  }

  @override
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  }) async {
    await cancel(id);

    final delay = scheduledAt.difference(DateTime.now());
    if (delay <= Duration.zero) {
      await show(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
      return;
    }

    _scheduledTimers[id] = Timer(delay, () {
      unawaited(
        show(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
      _scheduledTimers.remove(id);
    });
  }

  @override
  Future<void> cancel(int id) async {
    _scheduledTimers.remove(id)?.cancel();
  }

  bool get _canShowNotifications =>
      isSupported && html.Notification.permission == 'granted';
}
