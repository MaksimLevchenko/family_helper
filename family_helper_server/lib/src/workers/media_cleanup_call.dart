import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class MediaCleanupCall extends FutureCall<MediaCleanupPayload> {
  @override
  Future<void> invoke(Session session, MediaCleanupPayload? object) async {
    await session.db.unsafeExecute(
      '''
      DELETE FROM media_object
      WHERE deleted_at IS NOT NULL
        AND deleted_at < @threshold
      ''',
      parameters: QueryParameters.named({
        'threshold': DateTime.now().toUtc().subtract(const Duration(days: 7)),
      }),
    );
    await session.server.serverpod.futureCallWithDelay(
      'mediaCleanup',
      null,
      const Duration(minutes: 15),
    );
  }
}
