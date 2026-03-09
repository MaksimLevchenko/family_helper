import 'dart:io';
import 'dart:math';
import 'package:serverpod/serverpod.dart';
import '../../core/audit/audit_service.dart';
import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/realtime/realtime_publisher.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';


class FamilyService {
  FamilyService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    this.changeFeed = const ChangeFeedService(),
    this.realtime = const RealtimePublisher(),
    this.audit = const AuditService(),
  });

  final AuthContext authContext;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final ChangeFeedService changeFeed;
  final RealtimePublisher realtime;
  final AuditService audit;

  Future<FamilyDto> createFamily(
    Session session, {
    required String clientOperationId,
    required String title,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'family.create',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final ownerProfileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      if (!isFresh) {
        final existing = await FamilyRow.db.findFirstRow(
          session,
          where: (t) =>
              t.ownerProfileId.equals(ownerProfileId) & t.deletedAt.equals(null),
          orderBy: (t) => t.id,
          orderDescending: true,
          transaction: transaction,
        );
        if (existing != null) {
          return _mapFamily(existing);
        }
      }

      final memberLimit = int.tryParse(
            const String.fromEnvironment('FAMILY_MEMBER_LIMIT', defaultValue: ''),
          ) ??
          int.tryParse(Platform.environment['FAMILY_MEMBER_LIMIT'] ?? '2') ??
          2;

      final now = DateTime.now().toUtc();
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

      await changeFeed.appendChange(
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

      await audit.append(
        session,
        familyId: family.id,
        actorProfileId: ownerProfileId,
        action: 'family.create',
        payload: {'familyId': family.id, 'title': family.title},
        transaction: transaction,
      );

      await realtime.publish(
        session,
        familyId: family.id,
        event: FamilyRealtimeEvent(
          familyId: family.id,
          feature: 'family',
          entityType: 'family',
          entityId: family.id,
          eventType: 'family.updated',
          changedAt: DateTime.now().toUtc(),
        ),
      );

      return family;
    });
  }

  Future<List<FamilyMemberDto>> listMembers(
    Session session, {
    required int familyId,
  }) async {
    await rbac.ensureFamilyRole(session, familyId: familyId, minRole: 'member');

    final members = await FamilyMemberRow.db.find(
      session,
      where: (t) => t.familyId.equals(familyId) & t.deletedAt.equals(null),
      orderBy: (t) => t.id,
    );
    final profileIds = members.map((m) => m.profileId).toSet().cast<int?>().toSet();
    final profiles = profileIds.isEmpty
        ? <AppProfileRow>[]
        : await AppProfileRow.db.find(
            session,
            where: (t) => t.id.inSet(profileIds),
          );
    final profilesById = {for (final p in profiles) p.id!: p};

    return members.map((m) => _mapMember(m, profilesById[m.profileId])).toList();
  }

  Future<FamilyInviteDto> createInvite(
    Session session, {
    required int familyId,
    required String clientOperationId,
    required String inviteType,
    String? email,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final actorProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'owner',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'family.createInvite',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        final existing = await FamilyInviteRow.db.findFirstRow(
          session,
          where: (t) =>
              t.familyId.equals(familyId) &
              t.acceptedAt.equals(null) &
              (t.expiresAt > DateTime.now().toUtc()),
          orderBy: (t) => t.id,
          orderDescending: true,
          transaction: transaction,
        );
        if (existing != null) {
          return _mapInvite(existing);
        }
      }

      final now = DateTime.now().toUtc();
      final inviteCode = _randomCode(8);
      final token = _randomCode(32);

      final inserted = await FamilyInviteRow.db.insertRow(
        session,
        FamilyInviteRow(
          familyId: familyId,
          inviteType: inviteType,
          email: email,
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

      await changeFeed.appendChange(
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

      await audit.append(
        session,
        familyId: familyId,
        actorProfileId: actorProfileId,
        action: 'family.invite.create',
        payload: {'inviteId': invite.id, 'inviteType': inviteType},
        transaction: transaction,
      );

      await realtime.publish(
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

      return invite;
    });
  }

  Future<FamilyMemberDto> acceptInvite(
    Session session, {
    required String clientOperationId,
    required String tokenOrCode,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'family.invite.accept',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final invite = await FamilyInviteRow.db.findFirstRow(
        session,
        where: (t) =>
            (t.token.equals(tokenOrCode) | t.inviteCode.equals(tokenOrCode)) &
            (t.expiresAt > DateTime.now().toUtc()),
        orderBy: (t) => t.id,
        orderDescending: true,
        transaction: transaction,
      );

      if (invite == null) {
        throw Exception('Invite not found or expired');
      }
      final inviteDto = _mapInvite(invite);

      if (isFresh) {
        final now = DateTime.now().toUtc();
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

        await FamilyInviteRow.db.updateRow(
          session,
          invite.copyWith(acceptedAt: now),
          transaction: transaction,
        );

        await changeFeed.appendChange(
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

        await audit.append(
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
            t.familyId.equals(inviteDto.familyId) &
            t.profileId.equals(profileId),
        transaction: transaction,
      );
      final profile = await AppProfileRow.db.findById(
        session,
        profileId,
        transaction: transaction,
      );

      await realtime.publish(
        session,
        familyId: inviteDto.familyId,
        event: FamilyRealtimeEvent(
          familyId: inviteDto.familyId,
          feature: 'family',
          entityType: 'member',
          entityId: profileId,
          eventType: 'family.updated',
          changedAt: DateTime.now().toUtc(),
        ),
      );

      return _mapMember(member!, profile);
    });
  }

  Future<OperationResult> transferOwnership(
    Session session, {
    required int familyId,
    required String clientOperationId,
    required int newOwnerProfileId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final oldOwnerProfileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'owner',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'family.transferOwnership',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        return OperationResult(success: true, message: 'Already processed');
      }

      final now = DateTime.now().toUtc();
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

      await changeFeed.appendChange(
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

      await realtime.publish(
        session,
        familyId: familyId,
        event: FamilyRealtimeEvent(
          familyId: familyId,
          feature: 'family',
          entityType: 'family',
          entityId: familyId,
          eventType: 'family.updated',
          changedAt: DateTime.now().toUtc(),
        ),
      );

      return OperationResult(success: true, message: 'Ownership transferred');
    });
  }

  Future<OperationResult> leaveFamily(
    Session session, {
    required int familyId,
    required String clientOperationId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await rbac.ensureFamilyRole(
        session,
        familyId: familyId,
        minRole: 'member',
        transaction: transaction,
      );

      final isFresh = await idempotency.tryBegin(
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
        throw Exception('Owner cannot leave before transfer ownership');
      }

      final member = await FamilyMemberRow.db.findFirstRow(
        session,
        where: (t) =>
            t.familyId.equals(familyId) & t.profileId.equals(profileId),
        transaction: transaction,
      );
      if (member != null) {
        final now = DateTime.now().toUtc();
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

      await changeFeed.appendChange(
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

      await realtime.publish(
        session,
        familyId: familyId,
        event: FamilyRealtimeEvent(
          familyId: familyId,
          feature: 'family',
          entityType: 'member',
          entityId: profileId,
          eventType: 'family.updated',
          changedAt: DateTime.now().toUtc(),
        ),
      );

      return OperationResult(success: true, message: 'Left family');
    });
  }

  FamilyDto _mapFamily(FamilyRow row) {
    return FamilyDto(
      id: row.id!,
      title: row.title,
      ownerProfileId: row.ownerProfileId,
      memberLimit: row.memberLimit,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  FamilyMemberDto _mapMember(FamilyMemberRow row, AppProfileRow? profile) {
    return FamilyMemberDto(
      id: row.id!,
      familyId: row.familyId,
      profileId: row.profileId,
      displayName: profile?.displayName ?? 'User #${row.profileId}',
      role: row.role,
      status: row.status,
      createdAt: row.createdAt,
    );
  }

  FamilyInviteDto _mapInvite(FamilyInviteRow row) {
    return FamilyInviteDto(
      id: row.id!,
      familyId: row.familyId,
      inviteType: row.inviteType,
      email: row.email,
      inviteCode: row.inviteCode,
      token: row.token,
      expiresAt: row.expiresAt,
      acceptedAt: row.acceptedAt,
      createdAt: row.createdAt,
    );
  }

  String _randomCode(int length) {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789abcdefghijkmnopqrstuvwxyz';
    final random = Random.secure();
    return List<String>.generate(
      length,
      (_) => alphabet[random.nextInt(alphabet.length)],
    ).join();
  }
}


