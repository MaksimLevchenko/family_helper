import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter/foundation.dart';

import '../../../core/network/app_api_client.dart';
import '../../../core/network/server_url_resolver.dart';

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
  Future<PrivacyStatusDto> getStatus() async {
    final status = await _apiClient.client.privacy.getStatus();
    final exportJob = status.lastExportJob;
    if (exportJob?.signedUrl == null) {
      return status;
    }

    return status.copyWith(
      lastExportJob: exportJob!.copyWith(
        signedUrl: ServerUrlResolver.normalizeAgainstBase(
          exportJob.signedUrl!,
          baseUrl: _apiClient.client.host,
          platform: defaultTargetPlatform,
        ),
      ),
    );
  }

  @override
  Future<PrivacyExportJobDto> requestExport({
    required String clientOperationId,
  }) async {
    final job = await _apiClient.client.privacy.requestExport(
      clientOperationId: clientOperationId,
    );
    if (job.signedUrl == null) {
      return job;
    }

    return job.copyWith(
      signedUrl: ServerUrlResolver.normalizeAgainstBase(
        job.signedUrl!,
        baseUrl: _apiClient.client.host,
        platform: defaultTargetPlatform,
      ),
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
