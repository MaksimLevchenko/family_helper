import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../privacy/services/privacy_service.dart';
import 'future_call_registry.dart';

class AccountDeletionCall extends FutureCall<AccountDeletionPayload> {
  AccountDeletionCall({PrivacyService? service}) : service = service ?? PrivacyService();

  final PrivacyService service;

  @override
  Future<void> invoke(Session session, AccountDeletionPayload? object) async {
    await service.processHardDeletion(session);
    await FutureCallRegistry.scheduleAccountDeletion(
      session.server.serverpod,
    );
  }
}
