import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

class RealtimePublisher {
  const RealtimePublisher();

  String familyChannel(int familyId) => 'family:$familyId';

  Future<void> publish(
    Session session, {
    required int familyId,
    required FamilyRealtimeEvent event,
  }) async {
    await session.messages.postMessage(
      familyChannel(familyId),
      event,
      global: false,
    );
  }
}
