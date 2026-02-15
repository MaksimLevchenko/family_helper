import 'dart:convert';

import 'package:serverpod/serverpod.dart';

class SecurityEventService {
  const SecurityEventService();

  Future<void> append(
    Session session, {
    required String authUserId,
    required String eventType,
    required bool success,
    Map<String, dynamic>? payload,
    Transaction? transaction,
  }) async {
    await session.db.unsafeExecute(
      '''
      INSERT INTO security_event (
        auth_user_id,
        event_type,
        success,
        payload_json,
        created_at
      ) VALUES (
        @authUserId,
        @eventType,
        @success,
        @payload,
        @createdAt
      )
      ''',
      parameters: QueryParameters.named({
        'authUserId': authUserId,
        'eventType': eventType,
        'success': success,
        'payload': jsonEncode(payload ?? const <String, dynamic>{}),
        'createdAt': DateTime.now().toUtc(),
      }),
      transaction: transaction,
    );
  }
}
