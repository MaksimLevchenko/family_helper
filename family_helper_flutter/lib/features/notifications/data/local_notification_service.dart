import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/notification_models.dart';

class LocalNotificationService {
  LocalNotificationService({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _plugin = FlutterLocalNotificationsPlugin(),
       _storage = storage;

  static const _permissionChannel = MethodChannel(
    'family_helper/notification_permissions',
  );
  static const _permissionRequestedKey =
      'notifications_permission_requested_once';

  final FlutterLocalNotificationsPlugin _plugin;
  final FlutterSecureStorage _storage;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz_data.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<NotificationPermissionStatus> getPermissionStatus() async {
    await initialize();

    if (kIsWeb) {
      return NotificationPermissionStatus.granted;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _getAndroidPermissionStatus();
      case TargetPlatform.iOS:
        return _getDarwinPermissionStatus();
      case TargetPlatform.macOS:
        return _getMacPermissionStatus();
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return NotificationPermissionStatus.granted;
    }
  }

  Future<NotificationPermissionStatus> requestPermissions() async {
    await initialize();

    if (kIsWeb) {
      return NotificationPermissionStatus.granted;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        await _storage.write(key: _permissionRequestedKey, value: 'true');
        final androidPlugin = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        await androidPlugin?.requestNotificationsPermission();
        return _getAndroidPermissionStatus();
      case TargetPlatform.iOS:
        final iosPlugin = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        await iosPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return _getDarwinPermissionStatus();
      case TargetPlatform.macOS:
        final macPlugin = _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();
        await macPlugin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return _getMacPermissionStatus();
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return NotificationPermissionStatus.granted;
    }
  }

  Future<bool> openNotificationSettings() async {
    if (kIsWeb) {
      return false;
    }

    try {
      final result = await _permissionChannel.invokeMethod<bool>(
        'openNotificationSettings',
      );
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
  }) async {
    await initialize();

    final androidDetails = const AndroidNotificationDetails(
      'reminders',
      'Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    final now = DateTime.now();
    if (!scheduledAt.isAfter(now)) {
      await _plugin.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails),
      );
      return;
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledAt, tz.local),
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<NotificationPermissionStatus> _getAndroidPermissionStatus() async {
    final state = await _permissionChannel.invokeMapMethod<String, dynamic>(
      'getNotificationPermissionStatus',
    );
    final requestedBefore =
        await _storage.read(key: _permissionRequestedKey) == 'true';
    return mapAndroidPermissionStatus(
      state,
      requestedBefore: requestedBefore,
    );
  }

  Future<NotificationPermissionStatus> _getDarwinPermissionStatus() async {
    final status = await _permissionChannel.invokeMethod<String>(
      'getNotificationPermissionStatus',
    );
    return mapDarwinPermissionStatus(status);
  }

  Future<NotificationPermissionStatus> _getMacPermissionStatus() async {
    final macPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    final permissions = await macPlugin?.checkPermissions();
    final enabled =
        permissions?.isAlertEnabled == true ||
        permissions?.isBadgeEnabled == true ||
        permissions?.isSoundEnabled == true;
    return enabled
        ? NotificationPermissionStatus.granted
        : NotificationPermissionStatus.notDetermined;
  }

  static NotificationPermissionStatus mapAndroidPermissionStatus(
    Map<String, dynamic>? state, {
    required bool requestedBefore,
  }) {
    final isGranted = state?['isGranted'] == true;
    if (isGranted) {
      return NotificationPermissionStatus.granted;
    }

    final needsRuntimePermission = state?['needsRuntimePermission'] == true;
    final notificationsEnabled = state?['notificationsEnabled'] == true;
    if (!needsRuntimePermission) {
      return notificationsEnabled
          ? NotificationPermissionStatus.granted
          : NotificationPermissionStatus.permanentlyDenied;
    }

    final canAskAgain = state?['canAskAgain'] == true;
    if (!requestedBefore) {
      return NotificationPermissionStatus.notDetermined;
    }
    if (canAskAgain) {
      return NotificationPermissionStatus.denied;
    }
    return NotificationPermissionStatus.permanentlyDenied;
  }

  static NotificationPermissionStatus mapDarwinPermissionStatus(
    String? status,
  ) {
    return switch (status) {
      'granted' => NotificationPermissionStatus.granted,
      'denied' => NotificationPermissionStatus.denied,
      'permanentlyDenied' => NotificationPermissionStatus.permanentlyDenied,
      _ => NotificationPermissionStatus.notDetermined,
    };
  }
}
