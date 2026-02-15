import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

abstract class ProfileRepositoryContract {
  Future<ProfileDto> me();

  Future<ProfileDto> update({
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool? analyticsOptIn,
  });
}

class ProfileRepository implements ProfileRepositoryContract {
  const ProfileRepository(this._apiClient);

  final AppApiClient _apiClient;

  @override
  Future<ProfileDto> me() {
    return _apiClient.client.profile.me();
  }

  @override
  Future<ProfileDto> update({
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool? analyticsOptIn,
  }) {
    return _apiClient.client.profile.update(
      clientOperationId: clientOperationId,
      displayName: displayName,
      timezone: timezone,
      avatarMediaId: avatarMediaId,
      analyticsOptIn: analyticsOptIn,
    );
  }
}
