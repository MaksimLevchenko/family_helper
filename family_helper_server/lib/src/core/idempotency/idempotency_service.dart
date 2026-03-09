import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class IdempotencyService {
  const IdempotencyService();

  Future<bool> tryBegin(
    Session session, {
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    Transaction? transaction,
  }) async {
    final existing = await IdempotencyKeyRow.db.findFirstRow(
      session,
      where: (t) =>
          t.actorAuthUserId.equals(actorAuthUserId) &
          t.action.equals(action) &
          t.clientOperationId.equals(clientOperationId),
      transaction: transaction,
    );
    if (existing != null) return false;

    try {
      await IdempotencyKeyRow.db.insertRow(
        session,
        IdempotencyKeyRow(
          actorAuthUserId: actorAuthUserId,
          action: action,
          clientOperationId: clientOperationId,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}


