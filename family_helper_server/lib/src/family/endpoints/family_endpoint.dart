import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../services/family_service.dart';

class FamilyEndpoint extends Endpoint {
  FamilyEndpoint({FamilyService? service})
    : service = service ?? FamilyService();

  final FamilyService service;

  Future<FamilyDto> createFamily(
    Session session, {
    required String clientOperationId,
    required String title,
  }) {
    return service.createFamily(
      session,
      clientOperationId: clientOperationId,
      title: title,
    );
  }

  Future<List<FamilyMemberDto>> listMembers(
    Session session, {
    required int familyId,
  }) {
    return service.listMembers(session, familyId: familyId);
  }

  Future<FamilyDto> getFamily(
    Session session, {
    required int familyId,
  }) {
    return service.getFamily(session, familyId: familyId);
  }

  Future<FamilyInviteDto> createInvite(
    Session session, {
    required int familyId,
    required String clientOperationId,
    required String inviteType,
    String? email,
  }) {
    return service.createInvite(
      session,
      familyId: familyId,
      clientOperationId: clientOperationId,
      inviteType: inviteType,
      email: email,
    );
  }

  Future<FamilyMemberDto> acceptInvite(
    Session session, {
    required String clientOperationId,
    required String tokenOrCode,
  }) {
    return service.acceptInvite(
      session,
      clientOperationId: clientOperationId,
      tokenOrCode: tokenOrCode,
    );
  }

  Future<OperationResult> transferOwnership(
    Session session, {
    required int familyId,
    required String clientOperationId,
    required int newOwnerProfileId,
  }) {
    return service.transferOwnership(
      session,
      familyId: familyId,
      clientOperationId: clientOperationId,
      newOwnerProfileId: newOwnerProfileId,
    );
  }

  Future<OperationResult> leaveFamily(
    Session session, {
    required int familyId,
    required String clientOperationId,
  }) {
    return service.leaveFamily(
      session,
      familyId: familyId,
      clientOperationId: clientOperationId,
    );
  }
}
