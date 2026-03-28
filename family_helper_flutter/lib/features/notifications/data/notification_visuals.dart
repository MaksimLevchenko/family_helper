import 'dart:convert';

class NotificationVisuals {
  const NotificationVisuals._();

  static const appName = 'Family Helper';
  static const brandColorValue = 0xFF13605A;
  static const brandColorHex = '#13605A';

  static final String webIconDataUrl = Uri.dataFromString(
    _iconSvg,
    mimeType: 'image/svg+xml',
    encoding: utf8,
  ).toString();

  static final String webBadgeDataUrl = Uri.dataFromString(
    _badgeSvg,
    mimeType: 'image/svg+xml',
    encoding: utf8,
  ).toString();

  static NotificationPresentation resolve({
    required int id,
    String? payload,
    bool isReminder = false,
  }) {
    final data = decodePayload(payload);
    final entityType = _stringValue(data['entityType']);
    final category = _stringValue(data['category']);
    final entityId = _stringValue(data['entityId']);
    final kind = entityType.isNotEmpty
        ? entityType
        : (category.isNotEmpty ? category : 'general');

    return NotificationPresentation(
      data: data,
      tag: 'family-helper-$kind-${entityId.isEmpty ? id : entityId}',
      groupKey: 'family_helper_$kind',
      subtitle: _subtitleFor(
        entityType: entityType,
        category: category,
        isReminder: isReminder,
      ),
      requireInteraction:
          isReminder ||
          category.contains('reminder') ||
          category.contains('due_soon'),
      imageUrl: _stringValue(data['imageUrl']),
      route: _stringValue(data['route']),
    );
  }

  static Map<String, dynamic> decodePayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) {
      return const <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) {
        return const <String, dynamic>{};
      }

      final normalized = decoded.map(
        (key, value) => MapEntry('$key', value),
      );
      final rawNestedPayload = normalized['payloadJson'];
      if (rawNestedPayload is String && rawNestedPayload.trim().isNotEmpty) {
        final nestedDecoded = jsonDecode(rawNestedPayload);
        if (nestedDecoded is Map) {
          return {
            ...nestedDecoded.map((key, value) => MapEntry('$key', value)),
            ...normalized,
          };
        }
      }
      return normalized;
    } catch (_) {
      return const <String, dynamic>{};
    }
  }

  static String _subtitleFor({
    required String entityType,
    required String category,
    required bool isReminder,
  }) {
    if (isReminder || category.contains('reminder')) {
      return switch (entityType) {
        'task' => 'Task reminder',
        'calendar' => 'Calendar reminder',
        'goal' => 'Goal reminder',
        'list' => 'List reminder',
        _ => 'Reminder',
      };
    }

    return switch (entityType) {
      'task' => 'Task update',
      'calendar' => 'Calendar update',
      'goal' => 'Goal update',
      'list' => 'List update',
      _ => category.isEmpty ? 'Family update' : 'Family notification',
    };
  }

  static String _stringValue(Object? value) {
    return value is String ? value.trim() : '';
  }

  static const String _iconSvg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 192 192">'
      '<defs>'
      '<linearGradient id="g" x1="24" y1="16" x2="168" y2="176" gradientUnits="userSpaceOnUse">'
      '<stop stop-color="#24A698"/>'
      '<stop offset="1" stop-color="#13605A"/>'
      '</linearGradient>'
      '</defs>'
      '<rect width="192" height="192" rx="48" fill="url(#g)"/>'
      '<circle cx="146" cy="46" r="18" fill="#8BE1D0" fill-opacity=".32"/>'
      '<circle cx="48" cy="150" r="22" fill="#FFFFFF" fill-opacity=".12"/>'
      '<path fill="#FFFFFF" d="M96 154c-5.2 0-10.1-1.9-13.8-5.3L42.8 114C19.5 92.8 10 78.1 10 58c0-23.2 18.8-42 42-42 15.1 0 29.5 7.6 38 19.6C98.5 23.6 112.9 16 128 16c23.2 0 42 18.8 42 42 0 20.1-9.5 34.8-32.8 56l-39.4 34.7c-3.7 3.4-8.6 5.3-13.8 5.3Z"/>'
      '</svg>';

  static const String _badgeSvg =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96 96">'
      '<rect width="96" height="96" rx="24" fill="#13605A"/>'
      '<path fill="#FFFFFF" d="M48 76c-3.3 0-6.5-1.2-8.8-3.4L24.3 59.3C14.2 49.9 10 43.4 10 34.2 10 22.5 19.5 13 31.2 13c7 0 13.7 3.5 16.8 9.1C51.1 16.5 57.8 13 64.8 13 76.5 13 86 22.5 86 34.2c0 9.2-4.2 15.7-14.3 25.1L56.8 72.6C54.5 74.8 51.3 76 48 76Z"/>'
      '</svg>';
}

class NotificationPresentation {
  const NotificationPresentation({
    required this.data,
    required this.tag,
    required this.groupKey,
    required this.subtitle,
    required this.requireInteraction,
    required this.imageUrl,
    required this.route,
  });

  final Map<String, dynamic> data;
  final String tag;
  final String groupKey;
  final String subtitle;
  final bool requireInteraction;
  final String imageUrl;
  final String route;
}
