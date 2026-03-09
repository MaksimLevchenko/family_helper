import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/privacy_service.dart';

class PrivacyEndpoint extends Endpoint {
  PrivacyEndpoint({PrivacyService? service}) : service = service ?? PrivacyService();

  final PrivacyService service;

  Future<PrivacyExportJobDto> requestExport(
    Session session, {
    required String clientOperationId,
  }) {
    return service.requestExport(
      session,
      clientOperationId: clientOperationId,
    );
  }

  Future<AccountDeletionStatusDto> requestAccountDeletion(
    Session session, {
    required String clientOperationId,
  }) {
    return service.requestAccountDeletion(
      session,
      clientOperationId: clientOperationId,
    );
  }

  Future<AccountDeletionStatusDto> cancelAccountDeletion(Session session) {
    return service.cancelAccountDeletion(session);
  }

  Future<int> processExportJobs(Session session) {
    throw AccessDeniedException(
      message: 'This method is internal and is not available to clients.',
    );
  }

  Future<int> processHardDeletion(Session session) {
    throw AccessDeniedException(
      message: 'This method is internal and is not available to clients.',
    );
  }
}
