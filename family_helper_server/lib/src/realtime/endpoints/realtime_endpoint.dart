import 'package:serverpod/serverpod.dart';

import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../generated/protocol.dart';

class RealtimeEndpoint extends Endpoint {
  RealtimeEndpoint({
    EnsureFamilyRoleService? rbac,
    RealtimePublisher? publisher,
  }) : rbac = rbac ?? const EnsureFamilyRoleService(),
       publisher = publisher ?? const RealtimePublisher();

  final EnsureFamilyRoleService rbac;
  final RealtimePublisher publisher;

  Stream<FamilyRealtimeEvent> watchFamilyEvents(
    Session session, {
    required int familyId,
  }) async* {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');
    yield* session.messages.createStream<FamilyRealtimeEvent>(
      publisher.familyChannel(familyId),
    );
  }
}
