import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../privacy/services/privacy_service.dart';

class PrivacyExportCall extends FutureCall<PrivacyExportPayload> {
  PrivacyExportCall({PrivacyService? service}) : service = service ?? PrivacyService();

  final PrivacyService service;

  @override
  Future<void> invoke(Session session, PrivacyExportPayload? object) async {
    await service.processExportJobs(session);
    await session.server.serverpod.futureCallWithDelay(
      'privacyExport',
      null,
      const Duration(minutes: 5),
    );
  }
}
