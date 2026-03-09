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
    int lastSeenChangeId = 0,
  }) async {
    if (familyId != null) {
      await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');
    }

    final sinceUtc = since.toUtc();
    final rows = await ChangeFeedRow.db.find(
      session,
      where: (t) {
        final byCursor =
            (t.changedAt > sinceUtc) |
            (t.changedAt.equals(sinceUtc) & (t.id > lastSeenChangeId));
        if (familyId == null) return byCursor;
        return byCursor & t.familyId.equals(familyId);
      },
      orderByList: (t) => [
        Order(column: t.changedAt),
        Order(column: t.id),
      ],
      limit: limit,
    );

    final items = rows.map(_map).toList();
    final hasMore = items.length >= limit;
    final nextSince = items.isEmpty ? sinceUtc : items.last.changedAt;
    final nextLastSeenChangeId = items.isEmpty ? lastSeenChangeId : items.last.id;

    return SyncChangesResponse(
      since: sinceUtc,
      nextSince: nextSince,
      nextLastSeenChangeId: nextLastSeenChangeId,
      hasMore: hasMore,
      changes: items,
    );
  }

  SyncChangeDto _map(ChangeFeedRow row) {
    return SyncChangeDto(
      id: row.id!,
      familyId: row.familyId,
      feature: row.feature,
      entityType: row.entityType,
      entityId: row.entityId,
      operation: row.operation,
      changedAt: row.changedAt,
      tombstone: row.tombstone,
      version: row.version,
      payloadJson: row.payloadJson,
    );
  }
}


