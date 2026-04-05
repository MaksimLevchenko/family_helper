part of 'family_service.dart';

Future<FamilyInviteDto> _createInviteImpl(
  FamilyService service,
  Session session, {
  required int familyId,
  required String clientOperationId,
  required String inviteType,
  String? email,
}) async {
  final authUser = service.authContext.requireAuthUserId(session);
  final authUserId = authUser.uuid;
  final result = await session.db
      .transaction<({FamilyInviteDto invite, String familyTitle})>((
        transaction,
      ) async {
        final actorProfileId = await service.rbac.ensureFamilyRole(
          session,
          familyId: familyId,
          minRole: 'owner',
          transaction: transaction,
        );

        final isFresh = await service.idempotency.tryBegin(
          session,
          actorAuthUserId: authUserId,
          action: 'family.createInvite',
          clientOperationId: clientOperationId,
          transaction: transaction,
        );

        if (!isFresh) {
          final binding = await service.idempotency.getBinding(
            session,
            actorAuthUserId: authUserId,
            action: 'family.createInvite',
            clientOperationId: clientOperationId,
            transaction: transaction,
          );
          if (binding?.resourceType == 'family_invite') {
            final invite = await _findInvite(
              service,
              session,
              binding!.resourceId,
              transaction: transaction,
            );
            final family = await FamilyRow.db.findById(
              session,
              familyId,
              transaction: transaction,
            );
            if (family == null || family.deletedAt != null) {
              throw FileNotFoundException(message: 'Family not found.');
            }
            return (invite: invite, familyTitle: family.title);
          }
        }

        final now = service.clock.nowUtc();
        final normalizedInviteType = inviteType.trim().toLowerCase();
        final normalizedEmail = _normalizeInviteEmail(
          inviteType: normalizedInviteType,
          email: email,
        );
        final family = await FamilyRow.db.findById(
          session,
          familyId,
          transaction: transaction,
        );
        if (family == null || family.deletedAt != null) {
          throw FileNotFoundException(message: 'Family not found.');
        }
        final inviteCode = _randomCode(8);
        final token = _randomCode(32);

        final inserted = await FamilyInviteRow.db.insertRow(
          session,
          FamilyInviteRow(
            familyId: familyId,
            inviteType: normalizedInviteType,
            email: normalizedEmail,
            inviteCode: inviteCode,
            token: token,
            expiresAt: now.add(const Duration(days: 7)),
            acceptedAt: null,
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
          transaction: transaction,
        );

        final invite = _mapInvite(inserted);

        await service.idempotency.bindResource(
          session,
          actorAuthUserId: authUserId,
          action: 'family.createInvite',
          clientOperationId: clientOperationId,
          resourceType: 'family_invite',
          resourceId: invite.id,
          transaction: transaction,
        );

        await service.changeFeed.appendChange(
          session,
          feature: 'family',
          entityType: 'invite',
          entityId: invite.id,
          operation: 'created',
          familyId: familyId,
          version: 1,
          payload: {'inviteType': inviteType},
          transaction: transaction,
        );

        await service.audit.append(
          session,
          familyId: familyId,
          actorProfileId: actorProfileId,
          action: 'family.invite.create',
          payload: {'inviteId': invite.id, 'inviteType': inviteType},
          transaction: transaction,
        );

        await service.realtime.publish(
          session,
          familyId: familyId,
          event: FamilyRealtimeEvent(
            familyId: familyId,
            feature: 'family',
            entityType: 'invite',
            entityId: invite.id,
            eventType: 'family.updated',
            changedAt: now,
          ),
        );

        final inviteEmailAccount = normalizedInviteType == 'email'
            ? await EmailAccount.db.findFirstRow(
                session,
                where: (t) => t.authUserId.equals(authUser),
                transaction: transaction,
              )
            : null;
        final normalizedInviteEmailAccount = inviteEmailAccount?.email
            .trim()
            .toLowerCase();
        final excludeProfileIds =
            normalizedInviteType == 'email' &&
                normalizedEmail != null &&
                normalizedEmail != normalizedInviteEmailAccount
            ? {actorProfileId}
            : const <int>{};

        await service.appNotifications.createLocalizedForFamilyMembers(
          session,
          familyId: familyId,
          excludeProfileIds: excludeProfileIds,
          category: 'family_invite_created',
          buildMessage: (localeCode, _) =>
              buildFamilyInviteCreatedNotificationMessage(
                localeCode: localeCode,
                email: normalizedEmail,
              ),
          entityType: 'invite',
          entityId: invite.id,
          route: '/home/settings/family',
          payload: {
            'category': 'family_invite_created',
            'familyId': familyId,
            'inviteId': invite.id,
            'inviteType': invite.inviteType,
          },
          transaction: transaction,
        );

        return (invite: invite, familyTitle: family.title);
      });

  final invite = result.invite;
  if (invite.inviteType == 'email' && invite.email != null) {
    await FamilyInviteEmailDispatcher.instance.sendInvite(
      session,
      recipientEmail: invite.email!,
      familyTitle: result.familyTitle,
      inviteCode: invite.inviteCode,
      expiresAt: invite.expiresAt,
    );
  }

  return invite;
}

Future<FamilyMemberDto> _acceptInviteImpl(
  FamilyService service,
  Session session, {
  required String clientOperationId,
  required String tokenOrCode,
}) async {
  final authUserId = service.authContext.requireAuthUserId(session).uuid;

  return session.db.transaction((transaction) async {
    final profileId = await service.authContext.ensureProfileId(
      session,
      transaction: transaction,
    );

    final isFresh = await service.idempotency.tryBegin(
      session,
      actorAuthUserId: authUserId,
      action: 'family.invite.accept',
      clientOperationId: clientOperationId,
      transaction: transaction,
    );

    if (!isFresh) {
      final binding = await service.idempotency.getBinding(
        session,
        actorAuthUserId: authUserId,
        action: 'family.invite.accept',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );
      if (binding?.resourceType == 'family_member') {
        return _findMember(
          service,
          session,
          binding!.resourceId,
          transaction: transaction,
        );
      }
    }

    final invite = await FamilyInviteRow.db.findFirstRow(
      session,
      where: (t) =>
          (t.token.equals(tokenOrCode) | t.inviteCode.equals(tokenOrCode)) &
          (t.expiresAt > service.clock.nowUtc()) &
          t.acceptedAt.equals(null),
      orderBy: (t) => t.id,
      orderDescending: true,
      transaction: transaction,
    );

    if (invite == null) {
      throw FileNotFoundException(message: 'Invite not found or expired.');
    }
    final inviteDto = _mapInvite(invite);
    await _ensureInviteRecipientMatches(
      service,
      session,
      invite: invite,
      transaction: transaction,
    );

    if (isFresh) {
      final now = service.clock.nowUtc();
      final existingMember = await FamilyMemberRow.db.findFirstRow(
        session,
        where: (t) =>
            t.familyId.equals(inviteDto.familyId) &
            t.profileId.equals(profileId),
        transaction: transaction,
      );
      if (existingMember == null) {
        await FamilyMemberRow.db.insertRow(
          session,
          FamilyMemberRow(
            familyId: inviteDto.familyId,
            profileId: profileId,
            role: 'member',
            status: 'active',
            createdAt: now,
            updatedAt: now,
            deletedAt: null,
            version: 1,
          ),
          transaction: transaction,
        );
      } else {
        await FamilyMemberRow.db.updateRow(
          session,
          existingMember.copyWith(
            status: 'active',
            updatedAt: now,
            version: existingMember.version + 1,
          ),
          transaction: transaction,
        );
      }
      final currentMember = await FamilyMemberRow.db.findFirstRow(
        session,
        where: (t) =>
            t.familyId.equals(inviteDto.familyId) &
            t.profileId.equals(profileId),
        transaction: transaction,
      );
      if (currentMember != null) {
        await service.idempotency.bindResource(
          session,
          actorAuthUserId: authUserId,
          action: 'family.invite.accept',
          clientOperationId: clientOperationId,
          resourceType: 'family_member',
          resourceId: currentMember.id!,
          transaction: transaction,
        );
      }

      await FamilyInviteRow.db.updateRow(
        session,
        invite.copyWith(acceptedAt: now),
        transaction: transaction,
      );

      await service.changeFeed.appendChange(
        session,
        feature: 'family',
        entityType: 'member',
        entityId: profileId,
        operation: 'upserted',
        familyId: inviteDto.familyId,
        version: 1,
        payload: {'profileId': profileId},
        transaction: transaction,
      );

      await service.audit.append(
        session,
        familyId: inviteDto.familyId,
        actorProfileId: profileId,
        action: 'family.invite.accept',
        payload: {'inviteId': inviteDto.id},
        transaction: transaction,
      );
    }

    final member = await FamilyMemberRow.db.findFirstRow(
      session,
      where: (t) =>
          t.familyId.equals(inviteDto.familyId) & t.profileId.equals(profileId),
      transaction: transaction,
    );
    final profile = await AppProfileRow.db.findById(
      session,
      profileId,
      transaction: transaction,
    );

    await service.realtime.publish(
      session,
      familyId: inviteDto.familyId,
      event: FamilyRealtimeEvent(
        familyId: inviteDto.familyId,
        feature: 'family',
        entityType: 'member',
        entityId: profileId,
        eventType: 'family.updated',
        changedAt: service.clock.nowUtc(),
      ),
    );

    await service.appNotifications.createLocalizedForFamilyMembers(
      session,
      familyId: inviteDto.familyId,
      excludeProfileIds: {profileId},
      category: 'family_invite_accepted',
      buildMessage: (localeCode, _) =>
          buildFamilyInviteAcceptedNotificationMessage(
            localeCode: localeCode,
            displayName: profile?.displayName ?? 'Someone',
          ),
      entityType: 'invite',
      entityId: inviteDto.id,
      route: '/home/settings/family',
      payload: {
        'category': 'family_invite_accepted',
        'familyId': inviteDto.familyId,
        'inviteId': inviteDto.id,
        'joinedProfileId': profileId,
      },
      transaction: transaction,
    );

    return _mapMember(member!, profile);
  });
}
