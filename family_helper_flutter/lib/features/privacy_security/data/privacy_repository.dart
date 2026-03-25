import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

abstract class PrivacyRepositoryContract {
  Future<PrivacyStatusDto> getStatus();

  Future<PrivacyExportJobDto> requestExport({
    required String clientOperationId,
  });

  Future<AccountDeletionStatusDto> requestAccountDeletion({
    required String clientOperationId,
  });

  Future<AccountDeletionStatusDto> cancelAccountDeletion();
}

class PrivacyRepository implements PrivacyRepositoryContract {
  const PrivacyRepository(this._apiClient);

  final AppApiClient _apiClient;

  @override
  Future<PrivacyStatusDto> getStatus() {
    return _apiClient.client.privacy.getStatus();
  }

  @override
  Future<PrivacyExportJobDto> requestExport({
    required String clientOperationId,
  }) {
    return _apiClient.client.privacy.requestExport(
      clientOperationId: clientOperationId,
    );
  }

  @override
  Future<AccountDeletionStatusDto> requestAccountDeletion({
    required String clientOperationId,
  }) {
    return _apiClient.client.privacy.requestAccountDeletion(
      clientOperationId: clientOperationId,
    );
  }

  @override
  Future<AccountDeletionStatusDto> cancelAccountDeletion() {
    return _apiClient.client.privacy.cancelAccountDeletion();
  }
}
