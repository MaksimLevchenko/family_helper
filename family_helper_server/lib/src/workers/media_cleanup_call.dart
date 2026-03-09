import 'package:family_helper_server/src/workers/future_call_registry.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class MediaCleanupCall extends FutureCall<MediaCleanupPayload> {
  @override
  Future<void> invoke(Session session, MediaCleanupPayload? object) async {
    final threshold = DateTime.now().toUtc().subtract(const Duration(days: 7));
    await MediaObjectRow.db.deleteWhere(
      session,
      where: (t) => t.deletedAt.notEquals(null) & (t.deletedAt < threshold),
    );
    await FutureCallRegistry.scheduleMediaCleanup(
      session.server.serverpod,
    );
  }
}
