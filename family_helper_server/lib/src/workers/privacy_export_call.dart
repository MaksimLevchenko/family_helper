import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../privacy/services/privacy_service.dart';
import 'future_call_registry.dart';

class PrivacyExportCall extends FutureCall<PrivacyExportPayload> {
  PrivacyExportCall({PrivacyService? service}) : service = service ?? PrivacyService();

  final PrivacyService service;

  @override
  Future<void> invoke(Session session, PrivacyExportPayload? object) async {
    await service.processExportJobs(session);
    await FutureCallRegistry.schedulePrivacyExport(
      session.server.serverpod,
    );
  }
}
