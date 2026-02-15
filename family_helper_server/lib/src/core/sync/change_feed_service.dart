import 'dart:convert';

import 'package:serverpod/serverpod.dart';

class ChangeFeedService {
  const ChangeFeedService();

  Future<void> appendChange(
    Session session, {
    required String feature,
    required String entityType,
    required int entityId,
    required String operation,
    required int version,
    int? familyId,
    Map<String, dynamic>? payload,
    bool tombstone = false,
    Transaction? transaction,
  }) async {
    await session.db.unsafeExecute(
      '''
      INSERT INTO change_feed (
        family_id,
        feature,
        entity_type,
        entity_id,
        operation,
        changed_at,
        tombstone,
        version,
        payload_json
      ) VALUES (
        @familyId,
        @feature,
        @entityType,
        @entityId,
        @operation,
        @changedAt,
        @tombstone,
        @version,
        @payload
      )
      ''',
      parameters: QueryParameters.named({
        'familyId': familyId,
        'feature': feature,
        'entityType': entityType,
        'entityId': entityId,
        'operation': operation,
        'changedAt': DateTime.now().toUtc(),
        'tombstone': tombstone,
        'version': version,
        'payload': jsonEncode(payload ?? const <String, dynamic>{}),
      }),
      transaction: transaction,
    );
  }
}
