import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

class AuthContext {
  const AuthContext();

  UuidValue requireAuthUserId(Session session) {
    final auth = session.authenticated;
    if (auth == null) {
      throw Exception('Unauthorized');
    }
    return auth.authUserId;
  }

  Future<int> ensureProfileId(
    Session session, {
    Transaction? transaction,
  }) async {
    final authUserId = requireAuthUserId(session).uuid;
    final now = DateTime.now().toUtc();

    final existing = await session.db.unsafeQuery(
      'SELECT id FROM app_profile WHERE auth_user_id = @authUserId LIMIT 1',
      parameters: QueryParameters.named({'authUserId': authUserId}),
      transaction: transaction,
    );
    if (existing.isNotEmpty) {
      return existing.first.toColumnMap()['id'] as int;
    }

    final inserted = await session.db.unsafeQuery(
      '''
      INSERT INTO app_profile (
        auth_user_id,
        display_name,
        timezone,
        analytics_opt_in,
        created_at,
        updated_at,
        version
      ) VALUES (
        @authUserId,
        @displayName,
        @timezone,
        false,
        @now,
        @now,
        1
      )
      ON CONFLICT (auth_user_id) DO UPDATE SET
        updated_at = EXCLUDED.updated_at
      RETURNING id
      ''',
      parameters: QueryParameters.named({
        'authUserId': authUserId,
        'displayName': 'User ${authUserId.substring(0, 8)}',
        'timezone': 'UTC',
        'now': now,
      }),
      transaction: transaction,
    );

    return inserted.first.toColumnMap()['id'] as int;
  }
}
