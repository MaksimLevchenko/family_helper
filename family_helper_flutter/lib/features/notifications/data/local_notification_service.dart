import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'browser_notification_service.dart';
import '../domain/notification_models.dart';

class LocalNotificationService {
  LocalNotificationService({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
    BrowserNotificationService? browserNotificationService,
  }) : _plugin = FlutterLocalNotificationsPlugin(),
       _storage = storage,
       _browserNotificationService =
           browserNotificationService ?? BrowserNotificationService();

  static const _permissionChannel = MethodChannel(
    'family_helper/notification_permissions',
  );
  static const _permissionRequestedKey =
      'notifications_permission_requested_once';
  static const _exactAlarmsNotPermittedCode = 'exact_alarms_not_permitted';

  final FlutterLocalNotificationsPlugin _plugin;
  final FlutterSecureStorage _storage;
  final BrowserNotificationService _browserNotificationService;
  final StreamController<String> _notificationResponses =
      StreamController<String>.broadcast();
  bool _initialized = false;

  Stream<String> get notificationResponses => _notificationResponses.stream;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    if (kIsWeb) {
      _initialized = true;
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
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _notificationResponses.add(payload);
        }
      },
    );
    _initialized = true;
  }

  Future<NotificationPermissionStatus> getPermissionStatus() async {
    await initialize();

    if (kIsWeb) {
      return mapBrowserPermissionStatus(
        _browserNotificationService.permissionStatus,
      );
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
      final status = await _browserNotificationService.requestPermission();
      return mapBrowserPermissionStatus(status);
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
    String? payload,
  }) async {
    await initialize();
    if (kIsWeb) {
      await _browserNotificationService.schedule(
        id: id,
        title: title,
        body: body,
        scheduledAt: scheduledAt,
        payload: payload,
      );
      return;
    }
    final details = _defaultNotificationDetails(
      channelId: 'reminders',
      channelName: 'Reminders',
    );

    final now = DateTime.now();
    if (!scheduledAt.isAfter(now)) {
      await _plugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
      return;
    }

    final scheduledDate = tz.TZDateTime.from(scheduledAt, tz.local);
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } on PlatformException catch (error) {
      if (!_shouldFallbackToInexactSchedule(error)) {
        rethrow;
      }
      debugPrint(
        'Exact alarms are not permitted on this device. '
        'Falling back to inexact reminder scheduling.',
      );
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    }
  }

  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();
    if (kIsWeb) {
      await _browserNotificationService.show(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
      return;
    }
    await _plugin.show(
      id,
      title,
      body,
      _defaultNotificationDetails(
        channelId: 'family_helper_inbox',
        channelName: 'Family notifications',
      ),
      payload: payload,
    );
  }

  Future<void> cancelReminder(int id) async {
    await initialize();
    if (kIsWeb) {
      await _browserNotificationService.cancel(id);
      return;
    }
    await _plugin.cancel(id);
  }

  Future<void> syncReminderSet({
    required String namespace,
    required List<LocalReminderSchedule> reminders,
  }) async {
    await initialize();

    final storageKey = 'scheduled_reminders_$namespace';
    final raw = await _storage.read(key: storageKey);
    final previousIds = raw == null
        ? <int>{}
        : (jsonDecode(raw) as List<dynamic>)
              .map((value) => value as int)
              .toSet();
    final nextIds = reminders.map((reminder) => reminder.id).toSet();

    for (final staleId in previousIds.difference(nextIds)) {
      await _plugin.cancel(staleId);
    }

    for (final reminder in reminders) {
      await scheduleReminder(
        id: reminder.id,
        title: reminder.title,
        body: reminder.body,
        scheduledAt: reminder.scheduledAt,
      );
    }

    await _storage.write(
      key: storageKey,
      value: jsonEncode(nextIds.toList()..sort()),
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

  static NotificationPermissionStatus mapBrowserPermissionStatus(
    String? status,
  ) {
    return switch (status) {
      'granted' => NotificationPermissionStatus.granted,
      'denied' => NotificationPermissionStatus.denied,
      'unsupported' => NotificationPermissionStatus.denied,
      _ => NotificationPermissionStatus.notDetermined,
    };
  }

  NotificationDetails _defaultNotificationDetails({
    required String channelId,
    required String channelName,
  }) {
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    return NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );
  }

  Future<void> dispose() async {
    await _notificationResponses.close();
  }

  bool _shouldFallbackToInexactSchedule(PlatformException error) {
    return defaultTargetPlatform == TargetPlatform.android &&
        error.code == _exactAlarmsNotPermittedCode;
  }
}

class LocalReminderSchedule {
  const LocalReminderSchedule({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledAt;
}
