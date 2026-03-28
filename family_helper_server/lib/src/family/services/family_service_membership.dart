part of 'family_service.dart';

Future<OperationResult> _transferOwnershipImpl(
  FamilyService service,
  Session session, {
  required int familyId,
  required String clientOperationId,
  required int newOwnerProfileId,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final oldOwnerProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'owner',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'family.transferOwnership',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    if (!isFresh) {
      return OperationResult(success: true, message: 'Already processed');
    }

    final now = service.clock.nowUtc();
    final members = await FamilyMemberRow.db.find(
      session,
      where: (t) =>
          t.familyId.equals(familyId) &
          (t.profileId.equals(oldOwnerProfileId) |
              t.profileId.equals(newOwnerProfileId)),
      transaction: transaction,
    );
    for (final member in members) {
      await FamilyMemberRow.db.updateRow(
        session,
        member.copyWith(
          role: member.profileId == oldOwnerProfileId ? 'member' : 'owner',
          updatedAt: now,
          version: member.version + 1,
        ),
        transaction: transaction,
      );
    }

    final family = await FamilyRow.db.findById(
      session,
      familyId,
      transaction: transaction,
    );
    if (family != null) {
      await FamilyRow.db.updateRow(
        session,
        family.copyWith(
          ownerProfileId: newOwnerProfileId,
          updatedAt: now,
          version: family.version + 1,
        ),
        transaction: transaction,
      );
    }

    await service.changeFeed.appendChange(
      session,
      feature: 'family',
      entityType: 'family',
      entityId: familyId,
      operation: 'ownership_transferred',
      familyId: familyId,
      version: 1,
      payload: {'newOwnerProfileId': newOwnerProfileId},
      transaction: transaction,
    );

    await service.realtime.publish(
      session,
      familyId: familyId,
      event: FamilyRealtimeEvent(
        familyId: familyId,
        feature: 'family',
        entityType: 'family',
        entityId: familyId,
        eventType: 'family.updated',
        changedAt: now,
      ),
    );

    return OperationResult(success: true, message: 'Ownership transferred');
  });
}

Future<OperationResult> _leaveFamilyImpl(
  FamilyService service,
  Session session, {
  required int familyId,
  required String clientOperationId,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final profileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'member',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'family.leave',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );
    if (!isFresh) {
      return OperationResult(success: true, message: 'Already processed');
    }

    final family = await FamilyRow.db.findById(
      session,
      familyId,
      transaction: transaction,
    );
    final ownerProfileId = family!.ownerProfileId;

    if (ownerProfileId == profileId) {
      throw AccessDeniedException(
        message: 'Owner cannot leave before transfer ownership.',
      );
    }

    final member = await FamilyMemberRow.db.findFirstRow(
      session,
      where: (t) =>
          t.familyId.equals(familyId) & t.profileId.equals(profileId),
      transaction: transaction,
    );
    if (member != null) {
      final now = service.clock.nowUtc();
      await FamilyMemberRow.db.updateRow(
        session,
        member.copyWith(
          status: 'left',
          updatedAt: now,
          deletedAt: now,
          version: member.version + 1,
        ),
        transaction: transaction,
      );
    }

    await service.changeFeed.appendChange(
      session,
      feature: 'family',
      entityType: 'member',
      entityId: profileId,
      operation: 'left',
      familyId: familyId,
      version: 1,
      tombstone: true,
      transaction: transaction,
    );

    await service.realtime.publish(
      session,
      familyId: familyId,
      event: FamilyRealtimeEvent(
        familyId: familyId,
        feature: 'family',
        entityType: 'member',
        entityId: profileId,
        eventType: 'family.updated',
        changedAt: service.clock.nowUtc(),
      ),
    );

    return OperationResult(success: true, message: 'Left family');
  });
}
