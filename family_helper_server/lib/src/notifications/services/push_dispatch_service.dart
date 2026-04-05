import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../core/clock/clock_service.dart';
import '../../generated/protocol.dart';

class PushDispatchService {
  PushDispatchService({
    PushGateway? gateway,
    ClockService? clock,
  }) : _gateway = gateway ?? FcmPushGateway(),
       _clock = clock ?? const ClockService();

  final PushGateway _gateway;
  final ClockService _clock;

  Future<AppNotificationRow> dispatchForNotification(
    Session session, {
    required AppNotificationRow notification,
    Transaction? transaction,
  }) async {
    final tokens = await PushTokenRow.db.find(
      session,
      where: (t) =>
          t.profileId.equals(notification.profileId) &
          t.deletedAt.equals(null) &
          t.disabledAt.equals(null),
      transaction: transaction,
    );

    if (tokens.isEmpty) {
      return _updateNotificationStatus(
        session,
        notification: notification,
        pushStatus: 'skipped',
        pushedAt: null,
        transaction: transaction,
      );
    }

    final payload = _buildPayload(notification);
    var hasSuccess = false;
    var sawFailure = false;

    for (final token in tokens) {
      final result = await _gateway.send(
        session,
        token: token.token,
        title: notification.title,
        body: notification.body,
        data: payload,
      );

      if (result.success) {
        hasSuccess = true;
        continue;
      }

      sawFailure = true;
      final now = _clock.nowUtc();
      await PushTokenRow.db.updateRow(
        session,
        token.copyWith(
          lastErrorAt: now,
          disabledAt: result.invalidToken ? now : token.disabledAt,
          updatedAt: now,
          version: token.version + 1,
        ),
        transaction: transaction,
      );
    }

    final pushStatus = hasSuccess
        ? 'sent'
        : (sawFailure ? 'failed' : 'skipped');
    return _updateNotificationStatus(
      session,
      notification: notification,
      pushStatus: pushStatus,
      pushedAt: hasSuccess ? _clock.nowUtc() : null,
      transaction: transaction,
    );
  }

  Future<AppNotificationRow> _updateNotificationStatus(
    Session session, {
    required AppNotificationRow notification,
    required String pushStatus,
    required DateTime? pushedAt,
    Transaction? transaction,
  }) {
    return AppNotificationRow.db.updateRow(
      session,
      notification.copyWith(
        pushStatus: pushStatus,
        pushedAt: pushedAt,
        version: notification.version + 1,
      ),
      transaction: transaction,
    );
  }

  Map<String, String> _buildPayload(AppNotificationRow notification) {
    final payload = <String, String>{
      'notificationId': '${notification.id!}',
      'familyId': '${notification.familyId}',
      'category': notification.category,
      'entityType': notification.entityType,
      'entityId': '${notification.entityId}',
      'payloadJson': notification.payloadJson,
    };
    if (notification.route != null && notification.route!.trim().isNotEmpty) {
      payload['route'] = notification.route!;
    }
    return payload;
  }
}

abstract class PushGateway {
  Future<PushSendResult> send(
    Session session, {
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  });
}

class FcmPushGateway implements PushGateway {
  FcmPushGateway({ClockService? clock})
    : _clock = clock ?? const ClockService();

  static const _scope = 'https://www.googleapis.com/auth/firebase.messaging';

  final ClockService _clock;

  @override
  Future<PushSendResult> send(
    Session session, {
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    final config = _loadConfig(session);
    if (config == null) {
      session.log(
        'FCM is not configured. Set firebaseServiceAccountJson or firebaseServiceAccountJsonPath in passwords.yaml to enable push delivery.',
        level: LogLevel.warning,
      );
      return const PushSendResult.skipped();
    }

    final credentials = ServiceAccountCredentials.fromJson(
      config.credentialsJson,
    );
    final client = await clientViaServiceAccount(
      credentials,
      const [_scope],
      baseClient: http.Client(),
    );

    try {
      final uri = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/${config.projectId}/messages:send',
      );
      final response = await client.post(
        uri,
        headers: const {'content-type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': data,
            'android': {
              'priority': 'high',
              'notification': {
                'channel_id': 'family_helper_inbox',
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              },
            },
            'apns': {
              'headers': {
                'apns-priority': '10',
              },
              'payload': {
                'aps': {
                  'sound': 'default',
                },
              },
            },
            'webpush': {
              'notification': {
                'title': title,
                'body': body,
              },
              'fcm_options': {
                'link': data['route'] ?? '/home/notifications/settings',
              },
            },
          },
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const PushSendResult.sent();
      }

      final error = _parseError(response.body);
      session.log(
        'FCM push failed for token=${_redactToken(token)} code=${response.statusCode} error=${error.errorCode ?? 'unknown'}',
        level: LogLevel.warning,
      );
      if (error.invalidToken) {
        return PushSendResult.invalidToken(
          errorCode: error.errorCode,
          errorMessage: error.errorMessage,
        );
      }
      return PushSendResult.failure(
        errorCode: error.errorCode,
        errorMessage: error.errorMessage,
      );
    } catch (error, stackTrace) {
      session.log(
        'FCM push request threw for token=${_redactToken(token)} at ${_clock.nowUtc().toIso8601String()}',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
      return PushSendResult.failure(errorMessage: '$error');
    } finally {
      client.close();
    }
  }

  _FcmServiceAccountConfig? _loadConfig(Session session) {
    final raw = _loadRawServiceAccountJson(session);
    if (raw.trim().isEmpty) {
      return null;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw StateError(
        'firebaseServiceAccountJson must contain a JSON object.',
      );
    }

    return _FcmServiceAccountConfig(
      projectId: decoded['project_id'] as String,
      credentialsJson: decoded,
    );
  }

  String _loadRawServiceAccountJson(Session session) {
    final passwords = session.passwords;
    final inlineJson =
        passwords['firebaseServiceAccountJson'] ??
        passwords['firebase_service_account_json'] ??
        '';
    if (inlineJson.trim().isNotEmpty) {
      return inlineJson;
    }

    final filePath =
        passwords['firebaseServiceAccountJsonPath'] ??
        passwords['firebase_service_account_json_path'] ??
        '';
    if (filePath.trim().isEmpty) {
      return '';
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      throw StateError(
        'firebaseServiceAccountJsonPath points to a missing file: $filePath',
      );
    }
    return file.readAsStringSync();
  }

  _FcmError _parseError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        return const _FcmError();
      }
      final error = decoded['error'];
      if (error is! Map<String, dynamic>) {
        return const _FcmError();
      }
      final details = error['details'];
      String? errorCode;
      if (details is List) {
        for (final detail in details) {
          if (detail is Map<String, dynamic> && detail['errorCode'] is String) {
            errorCode = detail['errorCode'] as String;
            break;
          }
        }
      }
      final invalidToken =
          errorCode == 'UNREGISTERED' || errorCode == 'INVALID_ARGUMENT';
      return _FcmError(
        errorCode: errorCode,
        errorMessage: error['message'] as String?,
        invalidToken: invalidToken,
      );
    } catch (_) {
      return const _FcmError();
    }
  }

  String _redactToken(String token) {
    if (token.length <= 12) {
      return token;
    }
    return '${token.substring(0, 6)}...${token.substring(token.length - 6)}';
  }
}

class PushSendResult {
  const PushSendResult._({
    required this.status,
    this.invalidToken = false,
    this.errorCode,
    this.errorMessage,
  });

  const PushSendResult.sent()
    : this._(
        status: 'sent',
      );

  const PushSendResult.skipped()
    : this._(
        status: 'skipped',
      );

  const PushSendResult.failure({
    String? errorCode,
    String? errorMessage,
  }) : this._(
         status: 'failed',
         errorCode: errorCode,
         errorMessage: errorMessage,
       );

  const PushSendResult.invalidToken({
    String? errorCode,
    String? errorMessage,
  }) : this._(
         status: 'failed',
         invalidToken: true,
         errorCode: errorCode,
         errorMessage: errorMessage,
       );

  final String status;
  final bool invalidToken;
  final String? errorCode;
  final String? errorMessage;

  bool get success => status == 'sent';
}

class _FcmServiceAccountConfig {
  const _FcmServiceAccountConfig({
    required this.projectId,
    required this.credentialsJson,
  });

  final String projectId;
  final Map<String, dynamic> credentialsJson;
}

class _FcmError {
  const _FcmError({
    this.errorCode,
    this.errorMessage,
    this.invalidToken = false,
  });

  final String? errorCode;
  final String? errorMessage;
  final bool invalidToken;
}
