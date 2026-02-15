import 'package:serverpod/serverpod.dart';

class IdempotencyService {
  const IdempotencyService();

  Future<bool> tryBegin(
    Session session, {
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    Transaction? transaction,
  }) async {
    final affected = await session.db.unsafeExecute(
      '''
      INSERT INTO idempotency_key (
        actor_auth_user_id,
        action,
        client_operation_id,
        created_at
      ) VALUES (
        @actor,
        @action,
        @operation,
        @createdAt
      )
      ON CONFLICT (actor_auth_user_id, action, client_operation_id)
      DO NOTHING
      ''',
      parameters: QueryParameters.named({
        'actor': actorAuthUserId,
        'action': action,
        'operation': clientOperationId,
        'createdAt': DateTime.now().toUtc(),
      }),
      transaction: transaction,
    );

    return affected > 0;
  }
}
