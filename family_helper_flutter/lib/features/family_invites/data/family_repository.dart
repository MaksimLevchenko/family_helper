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

  Future<FamilyDto> getFamily({required int familyId}) {
    return _apiClient.client.family.getFamily(familyId: familyId);
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

  Future<OperationResult> transferOwnership({
    required int familyId,
    required String clientOperationId,
    required int newOwnerProfileId,
  }) {
    return _apiClient.client.family.transferOwnership(
      familyId: familyId,
      clientOperationId: clientOperationId,
      newOwnerProfileId: newOwnerProfileId,
    );
  }

  Future<OperationResult> leaveFamily({
    required int familyId,
    required String clientOperationId,
  }) {
    return _apiClient.client.family.leaveFamily(
      familyId: familyId,
      clientOperationId: clientOperationId,
    );
  }
}
