import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';

class FcmService {
  const FcmService();

  Future<void> send(
    String token, {
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    final projectId = Platform.environment['FIREBASE_PROJECT_ID'];
    final serviceAccountJson = Platform.environment['FCM_SERVICE_ACCOUNT_JSON'];

    if (projectId == null || serviceAccountJson == null) {
      return;
    }

    final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
    final client = await clientViaServiceAccount(
      credentials,
      const ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    try {
      final response = await client.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {'title': title, 'body': body},
            'data': data,
          }
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('FCM send failed (${response.statusCode}): ${response.body}');
      }
    } finally {
      client.close();
    }
  }
}
