import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class PrivacyRepository {
  const PrivacyRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<PrivacyStatusDto> getStatus() {
    return _apiClient.client.privacy.getStatus();
  }

  Future<PrivacyExportJobDto> requestExport({
    required String clientOperationId,
  }) {
    return _apiClient.client.privacy.requestExport(
      clientOperationId: clientOperationId,
    );
  }

  Future<AccountDeletionStatusDto> requestAccountDeletion({
    required String clientOperationId,
  }) {
    return _apiClient.client.privacy.requestAccountDeletion(
      clientOperationId: clientOperationId,
    );
  }

  Future<AccountDeletionStatusDto> cancelAccountDeletion() {
    return _apiClient.client.privacy.cancelAccountDeletion();
  }
}
