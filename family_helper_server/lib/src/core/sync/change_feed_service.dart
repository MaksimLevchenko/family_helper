import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

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
    await ChangeFeedRow.db.insertRow(
      session,
      ChangeFeedRow(
        familyId: familyId,
        feature: feature,
        entityType: entityType,
        entityId: entityId,
        operation: operation,
        changedAt: DateTime.now().toUtc(),
        tombstone: tombstone,
        version: version,
        payloadJson: jsonEncode(payload ?? const <String, dynamic>{}),
      ),
      transaction: transaction,
    );
  }
}


