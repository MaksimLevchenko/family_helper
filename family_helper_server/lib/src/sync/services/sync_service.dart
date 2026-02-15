import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../core/rbac/ensure_family_role_service.dart';
import '../../generated/protocol.dart';

class SyncService {
  SyncService({this.rbac = const EnsureFamilyRoleService()});

  final EnsureFamilyRoleService rbac;

  Future<SyncChangesResponse> changes(
    Session session, {
    required DateTime since,
    int? familyId,
    int limit = 500,
  }) async {
    if (familyId != null) {
      await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');
    }

    final rows = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        feature,
        entity_type,
        entity_id,
        operation,
        changed_at,
        tombstone,
        version,
        payload_json
      FROM change_feed
      WHERE changed_at > @since
        AND (@familyId IS NULL OR family_id = @familyId)
      ORDER BY changed_at ASC, id ASC
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({
        'since': since.toUtc(),
        'familyId': familyId,
        'limit': limit,
      }),
    );

    final items = rows.map((row) => _map(row.toColumnMap())).toList();
    final hasMore = items.length >= limit;
    final nextSince = items.isEmpty
        ? DateTime.now().toUtc()
        : items.last.changedAt;

    return SyncChangesResponse(
      since: since.toUtc(),
      nextSince: nextSince,
      hasMore: hasMore,
      changes: items,
    );
  }

  SyncChangeDto _map(Map<String, dynamic> row) {
    final payloadJsonRaw = row['payload_json'];
    String payloadJson;
    if (payloadJsonRaw is String) {
      payloadJson = payloadJsonRaw;
    } else {
      payloadJson = jsonEncode(payloadJsonRaw);
    }

    return SyncChangeDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int?,
      feature: row['feature'] as String,
      entityType: row['entity_type'] as String,
      entityId: row['entity_id'] as int,
      operation: row['operation'] as String,
      changedAt: row['changed_at'] as DateTime,
      tombstone: row['tombstone'] as bool,
      version: row['version'] as int,
      payloadJson: payloadJson,
    );
  }
}
