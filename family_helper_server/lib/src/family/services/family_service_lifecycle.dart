part of 'family_service.dart';

Future<FamilyDto> _createFamilyImpl(
  FamilyService service,
  Session session, {
  required String clientOperationId,
  required String title,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'family.create',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    final ownerProfileId = await service.authContext.ensureProfileId(
      session,
      transaction: transaction,
    );

    if (!isFresh) {
      final binding = await service.idempotency.getBinding(
        session,
        actorAuthUserId: authUserId,
        action: 'family.create',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (binding?.resourceType == 'family') {
        return _findFamily(
          service,
          session,
          binding!.resourceId,
          transaction: transaction,
        );
      }
    }

    final memberLimit =
        int.tryParse(
          const String.fromEnvironment(
            'FAMILY_MEMBER_LIMIT',
            defaultValue: '',
          ),
        ) ??
        int.tryParse(Platform.environment['FAMILY_MEMBER_LIMIT'] ?? '2') ??
        2;

    final now = service.clock.nowUtc();
    final insertedFamily = await FamilyRow.db.insertRow(
      session,
      FamilyRow(
        title: title,
        ownerProfileId: ownerProfileId,
        memberLimit: memberLimit,
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
        version: 1,
      ),
      transaction: transaction,
    );

    final family = _mapFamily(insertedFamily);

    await service.idempotency.bindResource(
      session,
      actorAuthUserId: authUserId,
      action: 'family.create',
      clientOperationId: clientOperationId,
      resourceType: 'family',
      resourceId: family.id,
      transaction: transaction,
    );

    await FamilyMemberRow.db.insertRow(
      session,
      FamilyMemberRow(
        familyId: family.id,
        profileId: ownerProfileId,
        role: 'owner',
        status: 'active',
        createdAt: now,
        updatedAt: now,
        deletedAt: null,
        version: 1,
      ),
      transaction: transaction,
    );

    await service.changeFeed.appendChange(
      session,
      feature: 'family',
      entityType: 'family',
      entityId: family.id,
      operation: 'created',
      familyId: family.id,
      version: 1,
      payload: {'title': family.title},
      transaction: transaction,
    );

    await service.audit.append(
      session,
      familyId: family.id,
      actorProfileId: ownerProfileId,
      action: 'family.create',
      payload: {'familyId': family.id, 'title': family.title},
      transaction: transaction,
    );

    await service.realtime.publish(
      session,
      familyId: family.id,
      event: FamilyRealtimeEvent(
        familyId: family.id,
        feature: 'family',
        entityType: 'family',
        entityId: family.id,
        eventType: 'family.updated',
        changedAt: now,
      ),
    );

    return family;
  });
}

Future<List<FamilyMemberDto>> _listMembersImpl(
  FamilyService service,
  Session session, {
  required int familyId,
}) async {
  await service.rbac.ensureFamilyRole(
    session,
    familyId: familyId,
    minRole: 'member',
  );

  final members = await FamilyMemberRow.db.find(
    session,
    where: (t) => t.familyId.equals(familyId) & t.deletedAt.equals(null),
    orderBy: (t) => t.id,
  );
  final profileIds = members.map((m) => m.profileId).toSet();
  final profiles = profileIds.isEmpty
      ? <AppProfileRow>[]
      : await AppProfileRow.db.find(
          session,
          where: (t) => t.id.inSet(profileIds),
        );
  final profilesById = {for (final p in profiles) p.id!: p};

  return members
      .map((m) => _mapMember(m, profilesById[m.profileId]))
      .toList();
}

Future<FamilyDto?> _getCurrentFamilyImpl(
  FamilyService service,
  Session session,
) async {
  final profileId = await service.authContext.ensureProfileId(session);

  final activeMembership = await FamilyMemberRow.db.findFirstRow(
    session,
    where: (t) =>
        t.profileId.equals(profileId) &
        t.deletedAt.equals(null) &
        t.status.equals('active'),
    orderByList: (t) => [
      Order(column: t.updatedAt, orderDescending: true),
      Order(column: t.id, orderDescending: true),
    ],
  );

  if (activeMembership == null) {
    return null;
  }

  return _findFamily(service, session, activeMembership.familyId);
}

Future<FamilyDto> _getFamilyImpl(
  FamilyService service,
  Session session, {
  required int familyId,
}) async {
  await service.rbac.ensureFamilyRole(
    session,
    familyId: familyId,
    minRole: 'member',
  );
  return _findFamily(service, session, familyId);
}

Future<FamilyDto> _renameFamilyImpl(
  FamilyService service,
  Session session, {
  required int familyId,
  required String clientOperationId,
  required String title,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;
  final normalizedTitle = title.trim();
  if (normalizedTitle.isEmpty) {
    throw AccessDeniedException(message: 'Family title cannot be empty.');
  }

  return session.db.transaction((transaction) async {
    final actorProfileId = await service.rbac.ensureFamilyRole(
      session,
      familyId: familyId,
      minRole: 'owner',
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'family.rename',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    if (!isFresh) {
      final binding = await service.idempotency.getBinding(
        session,
        actorAuthUserId: authUserId,
        action: 'family.rename',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (binding?.resourceType == 'family') {
        return _findFamily(
          service,
          session,
          binding!.resourceId,
          transaction: transaction,
        );
      }
      return _findFamily(service, session, familyId, transaction: transaction);
    }

    final family = await FamilyRow.db.findById(
      session,
      familyId,
      transaction: transaction,
    );
    if (family == null || family.deletedAt != null) {
      throw FileNotFoundException(message: 'Family not found.');
    }

    final now = service.clock.nowUtc();
    final updated = await FamilyRow.db.updateRow(
      session,
      family.copyWith(
        title: normalizedTitle,
        updatedAt: now,
        version: family.version + 1,
      ),
      transaction: transaction,
    );

    await service.idempotency.bindResource(
      session,
      actorAuthUserId: authUserId,
      action: 'family.rename',
      clientOperationId: clientOperationId,
      resourceType: 'family',
      resourceId: familyId,
      transaction: transaction,
    );

    await service.changeFeed.appendChange(
      session,
      feature: 'family',
      entityType: 'family',
      entityId: familyId,
      operation: 'renamed',
      familyId: familyId,
      version: updated.version,
      payload: {'title': updated.title},
      transaction: transaction,
    );

    await service.audit.append(
      session,
      familyId: familyId,
      actorProfileId: actorProfileId,
      action: 'family.rename',
      payload: {'familyId': familyId, 'title': updated.title},
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

    return _mapFamily(updated);
  });
}
