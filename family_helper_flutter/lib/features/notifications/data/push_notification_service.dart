import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../core/logging/app_error_logger.dart';
import '../../../firebase_options.dart';
import '../../../firebase_web_push_options.dart';
import 'local_notification_service.dart';
import 'notification_target.dart';

class PushNotificationService {
  PushNotificationService({
    required LocalNotificationService localNotificationService,
  }) : _localNotificationService = localNotificationService;

  final LocalNotificationService _localNotificationService;
  final StreamController<String> _tokenRefreshes =
      StreamController<String>.broadcast();
  final StreamController<NotificationOpenTarget> _openTargets =
      StreamController<NotificationOpenTarget>.broadcast();

  StreamSubscription<String>? _localTapSub;
  StreamSubscription<String>? _tokenSub;
  StreamSubscription<RemoteMessage>? _messageSub;
  StreamSubscription<RemoteMessage>? _openedSub;
  NotificationOpenTarget? _pendingInitialOpen;
  bool _initialized = false;

  bool get isConfigured => _firebaseOptions != null;

  Stream<String> get tokenRefreshes => _tokenRefreshes.stream;
  Stream<NotificationOpenTarget> get openTargets => _openTargets.stream;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    await _localNotificationService.initialize();
    _localTapSub = _localNotificationService.notificationResponses.listen(
      (payload) {
        final target = NotificationOpenTarget.fromPayloadJson(payload);
        if (target != null) {
          _openTargets.add(target);
        }
      },
    );

    final options = _firebaseOptions;
    if (options == null) {
      return;
    }

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    final messaging = FirebaseMessaging.instance;
    await messaging.setAutoInitEnabled(true);
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _tokenSub = messaging.onTokenRefresh.listen(_tokenRefreshes.add);
    _messageSub = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    _openedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final target = NotificationOpenTarget.fromDataMap(message.data);
      if (target != null) {
        _openTargets.add(target);
      }
    });

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _pendingInitialOpen = NotificationOpenTarget.fromDataMap(
        initialMessage.data,
      );
    }
  }

  Future<void> requestPermissions() async {
    await initialize();
    if (!isConfigured) {
      return;
    }
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getToken() async {
    await initialize();
    if (!isConfigured) {
      return null;
    }
    final vapidKey = _webVapidKey;
    return FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
  }

  NotificationOpenTarget? takePendingInitialOpen() {
    final target = _pendingInitialOpen;
    _pendingInitialOpen = null;
    return target;
  }

  Future<void> dispose() async {
    await _localTapSub?.cancel();
    await _tokenSub?.cancel();
    await _messageSub?.cancel();
    await _openedSub?.cancel();
    await _tokenRefreshes.close();
    await _openTargets.close();
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final title = notification?.title ?? 'Family Helper';
      final body = notification?.body ?? 'You have a new notification.';
      await _localNotificationService.showImmediateNotification(
        id: _notificationId(message),
        title: title,
        body: body,
        payload: jsonEncode(message.data),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'push.foregroundMessage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  int _notificationId(RemoteMessage message) {
    final explicit = int.tryParse(message.data['notificationId'] ?? '');
    if (explicit != null) {
      return explicit;
    }
    return message.messageId.hashCode;
  }

  FirebaseOptions? get _firebaseOptions {
    if (kIsWeb) {
      return DefaultFirebaseOptions.currentPlatform;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return DefaultFirebaseOptions.currentPlatform;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return null;
    }
  }

  String? get _webVapidKey {
    if (!kIsWeb) {
      return null;
    }
    final value = FirebaseWebPushOptions.vapidKey.trim();
    return value.isEmpty ? null : value;
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FirebaseOptions? options;
  if (kIsWeb) {
    options = DefaultFirebaseOptions.currentPlatform;
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        options = DefaultFirebaseOptions.currentPlatform;
        break;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        options = null;
        break;
    }
  }
  if (options == null) {
    return;
  }
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: options);
  }
}
