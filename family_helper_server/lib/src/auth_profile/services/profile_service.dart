import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../generated/protocol.dart';

class ProfileService {
  ProfileService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
  });

  final AuthContext authContext;
  final IdempotencyService idempotency;

  Future<ProfileDto> getMyProfile(Session session) async {
    final profileId = await authContext.ensureProfileId(session);
    final result = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        auth_user_id,
        display_name,
        timezone,
        avatar_media_id,
        analytics_opt_in,
        created_at,
        updated_at
      FROM app_profile
      WHERE id = @id
      LIMIT 1
      ''',
      parameters: QueryParameters.named({'id': profileId}),
    );

    return _mapProfile(result.first.toColumnMap());
  }

  Future<ProfileDto> updateMyProfile(
    Session session, {
    required String clientOperationId,
    String? displayName,
    String? timezone,
    int? avatarMediaId,
    bool? analyticsOptIn,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'profile.update',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      if (!isFresh) {
        final current = await _findById(
          session,
          profileId,
          transaction: transaction,
        );
        return current;
      }

      await session.db.unsafeExecute(
        '''
        UPDATE app_profile
        SET
          display_name = COALESCE(@displayName, display_name),
          timezone = COALESCE(@timezone, timezone),
          avatar_media_id = COALESCE(@avatarMediaId, avatar_media_id),
          analytics_opt_in = COALESCE(@analyticsOptIn, analytics_opt_in),
          updated_at = @updatedAt,
          version = version + 1
        WHERE id = @id
        ''',
        parameters: QueryParameters.named({
          'id': profileId,
          'displayName': displayName,
          'timezone': timezone,
          'avatarMediaId': avatarMediaId,
          'analyticsOptIn': analyticsOptIn,
          'updatedAt': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      return _findById(session, profileId, transaction: transaction);
    });
  }

  Future<ProfileDto> _findById(
    Session session,
    int profileId, {
    Transaction? transaction,
  }) async {
    final result = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        auth_user_id,
        display_name,
        timezone,
        avatar_media_id,
        analytics_opt_in,
        created_at,
        updated_at
      FROM app_profile
      WHERE id = @id
      LIMIT 1
      ''',
      parameters: QueryParameters.named({'id': profileId}),
      transaction: transaction,
    );

    return _mapProfile(result.first.toColumnMap());
  }

  ProfileDto _mapProfile(Map<String, dynamic> row) {
    return ProfileDto(
      id: row['id'] as int,
      authUserId: row['auth_user_id'] as String,
      displayName: row['display_name'] as String,
      timezone: row['timezone'] as String,
      avatarMediaId: row['avatar_media_id'] as int?,
      analyticsOptIn: row['analytics_opt_in'] as bool,
      createdAt: row['created_at'] as DateTime,
      updatedAt: row['updated_at'] as DateTime,
    );
  }
}
