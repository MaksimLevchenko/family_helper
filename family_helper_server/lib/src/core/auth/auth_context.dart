import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../generated/protocol.dart';

class AuthContext {
  const AuthContext();

  UuidValue requireAuthUserId(Session session) {
    final auth = session.authenticated;
    if (auth == null) {
      throw AccessDeniedException(message: 'Unauthorized.');
    }
    return auth.authUserId;
  }

  Future<int> ensureProfileId(
    Session session, {
    Transaction? transaction,
  }) async {
    final authUserId = requireAuthUserId(session).uuid;
    final now = DateTime.now().toUtc();

    final existing = await AppProfileRow.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );
    if (existing?.id != null) {
      return existing!.id!;
    }

    try {
      final inserted = await AppProfileRow.db.insertRow(
        session,
        AppProfileRow(
          authUserId: authUserId,
          displayName: 'User ${authUserId.substring(0, 8)}',
          timezone: 'UTC',
          avatarMediaId: null,
          analyticsOptIn: false,
          createdAt: now,
          updatedAt: now,
          deletedAt: null,
          version: 1,
        ),
        transaction: transaction,
      );
      return inserted.id!;
    } catch (_) {
      final concurrent = await AppProfileRow.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUserId),
        transaction: transaction,
      );
      if (concurrent?.id != null) return concurrent!.id!;
      rethrow;
    }
  }
}
