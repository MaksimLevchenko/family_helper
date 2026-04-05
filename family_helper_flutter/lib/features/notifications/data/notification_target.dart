import 'dart:convert';

import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/routing/app_routes.dart';

class NotificationOpenTarget {
  const NotificationOpenTarget({
    required this.familyId,
    required this.entityType,
    required this.entityId,
    required this.category,
    this.notificationId,
    this.route,
    this.payload,
  });

  final int familyId;
  final String entityType;
  final int entityId;
  final String category;
  final int? notificationId;
  final String? route;
  final Map<String, dynamic>? payload;

  DateTime? get occurrenceStart {
    final value = payload?['occurrenceStart'];
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value)?.toLocal();
    }
    return null;
  }

  static NotificationOpenTarget? fromAppNotification(
    AppNotificationDto notification,
  ) {
    return fromDataMap({
      'notificationId': notification.id,
      'familyId': notification.familyId,
      'category': notification.category,
      'entityType': notification.entityType,
      'entityId': notification.entityId,
      if (notification.route != null) 'route': notification.route,
      'payloadJson': notification.payloadJson,
    });
  }

  static NotificationOpenTarget? fromPayloadJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return fromDataMap(decoded);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static NotificationOpenTarget? fromDataMap(Map<String, dynamic> data) {
    final normalized = normalizeNotificationDataMap(data);
    final familyId = _parseInt(normalized['familyId']);
    final entityId = _parseInt(
      normalized['entityId'] ??
          normalized['taskId'] ??
          normalized['eventId'] ??
          normalized['goalId'] ??
          normalized['listId'] ??
          normalized['inviteId'],
    );
    final entityType =
        '${normalized['entityType'] ?? _inferEntityType(normalized)}'.trim();
    final category = '${normalized['category'] ?? ''}'.trim();
    if (familyId == null || entityId == null || entityType.isEmpty) {
      return null;
    }
    final route = '${normalized['route'] ?? ''}'.trim();
    return NotificationOpenTarget(
      familyId: familyId,
      entityType: entityType,
      entityId: entityId,
      category: category.isEmpty ? 'notification' : category,
      notificationId: _parseInt(normalized['notificationId']),
      route: route.isEmpty ? null : route,
      payload: normalized,
    );
  }

  static int? _parseInt(Object? value) {
    if (value is int) {
      return value;
    }
    return int.tryParse('$value');
  }

  static String _inferEntityType(Map<String, dynamic> data) {
    if (data.containsKey('taskId')) {
      return 'task';
    }
    if (data.containsKey('eventId')) {
      return 'calendar';
    }
    if (data.containsKey('goalId')) {
      return 'goal';
    }
    if (data.containsKey('listId')) {
      return 'list';
    }
    if (data.containsKey('inviteId')) {
      return 'invite';
    }
    return '';
  }
}

Map<String, dynamic> normalizeNotificationDataMap(Map<String, dynamic> data) {
  final payload = <String, dynamic>{};
  final embeddedPayload = _decodePayloadMap(data['payloadJson']);
  if (embeddedPayload != null) {
    payload.addAll(embeddedPayload);
  }
  payload.addAll(data);
  return payload;
}

String buildNotificationTargetPayloadJson({
  required int familyId,
  required String entityType,
  required int entityId,
  String? route,
  Map<String, dynamic>? payload,
}) {
  return jsonEncode(
    buildNotificationTargetPayload(
      familyId: familyId,
      entityType: entityType,
      entityId: entityId,
      route: route,
      payload: payload,
    ),
  );
}

Map<String, dynamic> buildNotificationTargetPayload({
  required int familyId,
  required String entityType,
  required int entityId,
  String? route,
  Map<String, dynamic>? payload,
}) {
  final resolvedRoute =
      route ?? defaultRouteForNotificationEntityType(entityType);
  return <String, dynamic>{
    ...?payload,
    'familyId': familyId,
    'entityType': entityType,
    'entityId': entityId,
    if (resolvedRoute != null && resolvedRoute.trim().isNotEmpty)
      'route': resolvedRoute,
  };
}

String? defaultRouteForNotificationEntityType(String entityType) {
  return switch (entityType) {
    'task' => AppRoutes.tasks,
    'calendar' => AppRoutes.calendar,
    'goal' => AppRoutes.goals,
    'list' => AppRoutes.lists,
    'invite' => AppRoutes.family,
    'notification' => AppRoutes.notificationSettings,
    _ => AppRoutes.notificationCenter,
  };
}

Map<String, dynamic>? _decodePayloadMap(Object? raw) {
  if (raw is! String || raw.trim().isEmpty) {
    return null;
  }
  try {
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : null;
  } catch (_) {
    return null;
  }
}
