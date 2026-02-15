import 'package:family_helper_client/family_helper_client.dart';

import '../../../core/network/app_api_client.dart';

class FamilyRepository {
  const FamilyRepository(this._apiClient);

  final AppApiClient _apiClient;

  Future<FamilyDto> createFamily({
    required String clientOperationId,
    required String title,
  }) {
    return _apiClient.client.family.createFamily(
      clientOperationId: clientOperationId,
      title: title,
    );
  }

  Future<List<FamilyMemberDto>> listMembers({required int familyId}) {
    return _apiClient.client.family.listMembers(familyId: familyId);
  }

  Future<FamilyInviteDto> createInvite({
    required int familyId,
    required String clientOperationId,
    required String inviteType,
    String? email,
  }) {
    return _apiClient.client.family.createInvite(
      familyId: familyId,
      clientOperationId: clientOperationId,
      inviteType: inviteType,
      email: email,
    );
  }

  Future<FamilyMemberDto> acceptInvite({
    required String clientOperationId,
    required String tokenOrCode,
  }) {
    return _apiClient.client.family.acceptInvite(
      clientOperationId: clientOperationId,
      tokenOrCode: tokenOrCode,
    );
  }
}
