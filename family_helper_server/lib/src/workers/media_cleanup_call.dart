import 'package:family_helper_server/src/workers/future_call_registry.dart';
import 'package:serverpod/serverpod.dart';

import '../core/clock/clock_service.dart';
import '../core/storage/minio_storage_service.dart';
import '../generated/protocol.dart';

class MediaCleanupCall extends FutureCall<MediaCleanupPayload> {
  MediaCleanupCall({
    ClockService? clock,
    MinioStorageService? storage,
  }) : clock = clock ?? const ClockService(),
       storage = storage ?? MinioStorageService();

  final ClockService clock;
  final MinioStorageService storage;

  @override
  Future<void> invoke(Session session, MediaCleanupPayload? object) async {
    final threshold = clock.nowUtc().subtract(const Duration(days: 7));
    final expired = await MediaObjectRow.db.find(
      session,
      where: (t) => t.deletedAt.notEquals(null) & (t.deletedAt < threshold),
    );
    final storageClient = storage.forSession(session);
    for (final row in expired) {
      try {
        await storageClient.deleteObject(row.objectKey);
      } catch (_) {
        // Ignore missing objects and continue cleaning database state.
      }
    }
    if (expired.isNotEmpty) {
      await MediaObjectRow.db.deleteWhere(
        session,
        where: (t) => t.deletedAt.notEquals(null) & (t.deletedAt < threshold),
      );
    }
    await FutureCallRegistry.scheduleMediaCleanup(
      session.server.serverpod,
    );
  }
}
