import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../privacy/services/privacy_service.dart';
import 'future_call_registry.dart';

class AccountDeletionCall extends FutureCall<AccountDeletionPayload> {
  AccountDeletionCall({PrivacyService? service})
    : service = service ?? PrivacyService();

  final PrivacyService service;

  @override
  Future<void> invoke(Session session, AccountDeletionPayload? object) async {
    try {
      await service.processHardDeletion(session);
    } catch (error, stackTrace) {
      session.log(
        'account_deletion worker failed; payload=${object?.toJson()}',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      await FutureCallRegistry.scheduleAccountDeletion(
        session.server.serverpod,
      );
    }
  }
}
