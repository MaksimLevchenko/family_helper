import 'dart:convert';

import 'package:serverpod/serverpod.dart';

class AuditService {
  const AuditService();

  Future<void> append(
    Session session, {
    required int? familyId,
    required int actorProfileId,
    required String action,
    required Map<String, dynamic> payload,
    Transaction? transaction,
  }) async {
    await session.db.unsafeExecute(
      '''
      INSERT INTO audit_log (
        family_id,
        actor_profile_id,
        action,
        payload_json,
        created_at
      ) VALUES (
        @familyId,
        @actor,
        @action,
        @payload,
        @createdAt
      )
      ''',
      parameters: QueryParameters.named({
        'familyId': familyId,
        'actor': actorProfileId,
        'action': action,
        'payload': jsonEncode(payload),
        'createdAt': DateTime.now().toUtc(),
      }),
      transaction: transaction,
    );
  }
}
