import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/sync_service.dart';

class SyncEndpoint extends Endpoint {
  SyncEndpoint({SyncService? service}) : service = service ?? SyncService();

  final SyncService service;

  Future<SyncChangesResponse> changes(
    Session session, {
    required DateTime since,
    int? familyId,
    int limit = 500,
    int lastSeenChangeId = 0,
  }) {
    return service.changes(
      session,
      since: since,
      familyId: familyId,
      limit: limit,
      lastSeenChangeId: lastSeenChangeId,
    );
  }
}
