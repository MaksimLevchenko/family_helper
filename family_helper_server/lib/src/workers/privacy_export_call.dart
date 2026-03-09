import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../privacy/services/privacy_service.dart';
import 'future_call_registry.dart';

class PrivacyExportCall extends FutureCall<PrivacyExportPayload> {
  PrivacyExportCall({PrivacyService? service})
    : service = service ?? PrivacyService();

  final PrivacyService service;

  @override
  Future<void> invoke(Session session, PrivacyExportPayload? object) async {
    try {
      await service.processExportJobs(session);
    } catch (error, stackTrace) {
      session.log(
        'privacy_export worker failed; payload=${object?.toJson()}',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      await FutureCallRegistry.schedulePrivacyExport(
        session.server.serverpod,
      );
    }
  }
}
