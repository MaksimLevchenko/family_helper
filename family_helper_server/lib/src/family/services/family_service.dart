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
        final existing = await session.db.unsafeQuery(
          '''
          SELECT id, title, owner_profile_id, member_limit, created_at, updated_at
          FROM family
          WHERE owner_profile_id = @profileId
            AND deleted_at IS NULL
          ORDER BY id DESC
          LIMIT 1
          ''',
          parameters: QueryParameters.named({'profileId': ownerProfileId}),
          transaction: transaction,
        );
        if (existing.isNotEmpty) {
          return _mapFamily(existing.first.toColumnMap());
        }
      }

      final memberLimit = int.tryParse(
            const String.fromEnvironment('FAMILY_MEMBER_LIMIT', defaultValue: ''),
          ) ??
          int.tryParse(Platform.environment['FAMILY_MEMBER_LIMIT'] ?? '2') ??
          2;

      final insertedFamily = await session.db.unsafeQuery(
        '''
        INSERT INTO family (
          title,
          owner_profile_id,
          member_limit,
          created_at,
          updated_at,
          version
        ) VALUES (
          @title,
          @owner,
          @memberLimit,
          @now,
          @now,
          1
        )
        RETURNING id, title, owner_profile_id, member_limit, created_at, updated_at
        ''',
        parameters: QueryParameters.named({
          'title': title,
          'owner': ownerProfileId,
          'memberLimit': memberLimit,
          'now': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      final family = _mapFamily(insertedFamily.first.toColumnMap());

      await session.db.unsafeExecute(
        '''
        INSERT INTO family_member (
          family_id,
          profile_id,
          role,
          status,
          created_at,
          updated_at,
          version
        ) VALUES (
          @familyId,
          @profileId,
          'owner',
          'active',
          @now,
          @now,
          1
        )
        ''',
        parameters: QueryParameters.named({
          'familyId': family.id,
          'profileId': ownerProfileId,
          'now': DateTime.now().toUtc(),
        }),
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

    final result = await session.db.unsafeQuery(
      '''
      SELECT
        fm.id,
        fm.family_id,
        fm.profile_id,
        ap.display_name,
        fm.role,
        fm.status,
        fm.created_at
      FROM family_member fm
      JOIN app_profile ap ON ap.id = fm.profile_id
      WHERE fm.family_id = @familyId
        AND fm.deleted_at IS NULL
      ORDER BY fm.id ASC
      ''',
      parameters: QueryParameters.named({'familyId': familyId}),
    );

    return result.map((row) => _mapMember(row.toColumnMap())).toList();
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
        final existing = await session.db.unsafeQuery(
          '''
          SELECT
            id,
            family_id,
            invite_type,
            email,
            invite_code,
            token,
            expires_at,
            accepted_at,
            created_at
          FROM family_invite
          WHERE family_id = @familyId
            AND accepted_at IS NULL
            AND expires_at > @now
          ORDER BY id DESC
          LIMIT 1
          ''',
          parameters: QueryParameters.named({
            'familyId': familyId,
            'now': DateTime.now().toUtc(),
          }),
          transaction: transaction,
        );
        if (existing.isNotEmpty) {
          return _mapInvite(existing.first.toColumnMap());
        }
      }

      final now = DateTime.now().toUtc();
      final inviteCode = _randomCode(8);
      final token = _randomCode(32);

      final inserted = await session.db.unsafeQuery(
        '''
        INSERT INTO family_invite (
          family_id,
          invite_type,
          email,
          invite_code,
          token,
          expires_at,
          accepted_at,
          created_at,
          updated_at,
          version
        ) VALUES (
          @familyId,
          @inviteType,
          @email,
          @inviteCode,
          @token,
          @expiresAt,
          NULL,
          @now,
          @now,
          1
        )
        RETURNING
          id,
          family_id,
          invite_type,
          email,
          invite_code,
          token,
          expires_at,
          accepted_at,
          created_at
        ''',
        parameters: QueryParameters.named({
          'familyId': familyId,
          'inviteType': inviteType,
          'email': email,
          'inviteCode': inviteCode,
          'token': token,
          'expiresAt': now.add(const Duration(days: 7)),
          'now': now,
        }),
        transaction: transaction,
      );

      final invite = _mapInvite(inserted.first.toColumnMap());

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

      final inviteResult = await session.db.unsafeQuery(
        '''
        SELECT
          id,
          family_id,
          invite_type,
          email,
          invite_code,
          token,
          expires_at,
          accepted_at,
          created_at
        FROM family_invite
        WHERE (token = @value OR invite_code = @value)
          AND expires_at > @now
        ORDER BY id DESC
        LIMIT 1
        ''',
        parameters: QueryParameters.named({
          'value': tokenOrCode,
          'now': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      if (inviteResult.isEmpty) {
        throw Exception('Invite not found or expired');
      }

      final invite = _mapInvite(inviteResult.first.toColumnMap());

      if (isFresh) {
        await session.db.unsafeExecute(
          '''
          INSERT INTO family_member (
            family_id,
            profile_id,
            role,
            status,
            created_at,
            updated_at,
            version
          ) VALUES (
            @familyId,
            @profileId,
            'member',
            'active',
            @now,
            @now,
            1
          )
          ON CONFLICT (family_id, profile_id)
          DO UPDATE SET
            status = 'active',
            updated_at = EXCLUDED.updated_at,
            version = family_member.version + 1
          ''',
          parameters: QueryParameters.named({
            'familyId': invite.familyId,
            'profileId': profileId,
            'now': DateTime.now().toUtc(),
          }),
          transaction: transaction,
        );

        await session.db.unsafeExecute(
          'UPDATE family_invite SET accepted_at = @acceptedAt WHERE id = @id',
          parameters: QueryParameters.named({
            'id': invite.id,
            'acceptedAt': DateTime.now().toUtc(),
          }),
          transaction: transaction,
        );

        await changeFeed.appendChange(
          session,
          feature: 'family',
          entityType: 'member',
          entityId: profileId,
          operation: 'upserted',
          familyId: invite.familyId,
          version: 1,
          payload: {'profileId': profileId},
          transaction: transaction,
        );

        await audit.append(
          session,
          familyId: invite.familyId,
          actorProfileId: profileId,
          action: 'family.invite.accept',
          payload: {'inviteId': invite.id},
          transaction: transaction,
        );
      }

      final memberResult = await session.db.unsafeQuery(
        '''
        SELECT
          fm.id,
          fm.family_id,
          fm.profile_id,
          ap.display_name,
          fm.role,
          fm.status,
          fm.created_at
        FROM family_member fm
        JOIN app_profile ap ON ap.id = fm.profile_id
        WHERE fm.family_id = @familyId
          AND fm.profile_id = @profileId
        LIMIT 1
        ''',
        parameters: QueryParameters.named({
          'familyId': invite.familyId,
          'profileId': profileId,
        }),
        transaction: transaction,
      );

      await realtime.publish(
        session,
        familyId: invite.familyId,
        event: FamilyRealtimeEvent(
          familyId: invite.familyId,
          feature: 'family',
          entityType: 'member',
          entityId: profileId,
          eventType: 'family.updated',
          changedAt: DateTime.now().toUtc(),
        ),
      );

      return _mapMember(memberResult.first.toColumnMap());
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

      await session.db.unsafeExecute(
        '''
        UPDATE family_member
        SET role = CASE
          WHEN profile_id = @oldOwner THEN 'member'
          WHEN profile_id = @newOwner THEN 'owner'
          ELSE role
        END,
        updated_at = @now,
        version = version + 1
        WHERE family_id = @familyId
          AND profile_id IN (@oldOwner, @newOwner)
        ''',
        parameters: QueryParameters.named({
          'familyId': familyId,
          'oldOwner': oldOwnerProfileId,
          'newOwner': newOwnerProfileId,
          'now': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      await session.db.unsafeExecute(
        '''
        UPDATE family
        SET owner_profile_id = @newOwner,
            updated_at = @now,
            version = version + 1
        WHERE id = @familyId
        ''',
        parameters: QueryParameters.named({
          'familyId': familyId,
          'newOwner': newOwnerProfileId,
          'now': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

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

      final ownerCheck = await session.db.unsafeQuery(
        'SELECT owner_profile_id FROM family WHERE id = @id LIMIT 1',
        parameters: QueryParameters.named({'id': familyId}),
        transaction: transaction,
      );
      final ownerProfileId = ownerCheck.first.toColumnMap()['owner_profile_id'] as int;

      if (ownerProfileId == profileId) {
        throw Exception('Owner cannot leave before transfer ownership');
      }

      await session.db.unsafeExecute(
        '''
        UPDATE family_member
        SET status = 'left',
            updated_at = @now,
            deleted_at = @now,
            version = version + 1
        WHERE family_id = @familyId
          AND profile_id = @profileId
        ''',
        parameters: QueryParameters.named({
          'familyId': familyId,
          'profileId': profileId,
          'now': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

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

  FamilyDto _mapFamily(Map<String, dynamic> row) {
    return FamilyDto(
      id: row['id'] as int,
      title: row['title'] as String,
      ownerProfileId: row['owner_profile_id'] as int,
      memberLimit: row['member_limit'] as int,
      createdAt: row['created_at'] as DateTime,
      updatedAt: row['updated_at'] as DateTime,
    );
  }

  FamilyMemberDto _mapMember(Map<String, dynamic> row) {
    return FamilyMemberDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int,
      profileId: row['profile_id'] as int,
      displayName: row['display_name'] as String,
      role: row['role'] as String,
      status: row['status'] as String,
      createdAt: row['created_at'] as DateTime,
    );
  }

  FamilyInviteDto _mapInvite(Map<String, dynamic> row) {
    return FamilyInviteDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int,
      inviteType: row['invite_type'] as String,
      email: row['email'] as String?,
      inviteCode: row['invite_code'] as String,
      token: row['token'] as String,
      expiresAt: row['expires_at'] as DateTime,
      acceptedAt: row['accepted_at'] as DateTime?,
      createdAt: row['created_at'] as DateTime,
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
