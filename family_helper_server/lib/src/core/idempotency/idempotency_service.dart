import 'package:serverpod/serverpod.dart';

import '../clock/clock_service.dart';
import '../../generated/protocol.dart';

class IdempotencyResourceBinding {
  const IdempotencyResourceBinding({
    required this.resourceType,
    required this.resourceId,
  });

  final String resourceType;
  final int resourceId;
}

class IdempotencyService {
  const IdempotencyService({this.clock = const ClockService()});

  final ClockService clock;

  Future<bool> tryBegin(
    Session session, {
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    Transaction? transaction,
  }) async {
    try {
      await insertIdempotencyKey(
        session,
        row: IdempotencyKeyRow(
          actorAuthUserId: actorAuthUserId,
          action: action,
          clientOperationId: clientOperationId,
          resourceType: null,
          resourceId: null,
          createdAt: clock.nowUtc(),
        ),
        transaction: transaction,
      );
      return true;
    } on DatabaseQueryException catch (error) {
      if (error.code == '23505') {
        return false;
      }
      rethrow;
    }
  }

  Future<void> insertIdempotencyKey(
    Session session, {
    required IdempotencyKeyRow row,
    Transaction? transaction,
  }) {
    return IdempotencyKeyRow.db.insertRow(
      session,
      row,
      transaction: transaction,
    );
  }

  Future<IdempotencyResourceBinding?> getBinding(
    Session session, {
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    Transaction? transaction,
  }) async {
    final row = await _findRow(
      session,
      actorAuthUserId: actorAuthUserId,
      action: action,
      clientOperationId: clientOperationId,
      transaction: transaction,
    );
    if (row?.resourceType == null || row?.resourceId == null) {
      return null;
    }

    return IdempotencyResourceBinding(
      resourceType: row!.resourceType!,
      resourceId: row.resourceId!,
    );
  }

  Future<void> bindResource(
    Session session, {
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    required String resourceType,
    required int resourceId,
    Transaction? transaction,
  }) async {
    final row = await _findRow(
      session,
      actorAuthUserId: actorAuthUserId,
      action: action,
      clientOperationId: clientOperationId,
      transaction: transaction,
    );
    if (row == null) {
      return;
    }

    if (row.resourceType == resourceType && row.resourceId == resourceId) {
      return;
    }

    await IdempotencyKeyRow.db.updateRow(
      session,
      row.copyWith(
        resourceType: resourceType,
        resourceId: resourceId,
      ),
      transaction: transaction,
    );
  }

  Future<IdempotencyKeyRow?> _findRow(
    Session session, {
    required String actorAuthUserId,
    required String action,
    required String clientOperationId,
    Transaction? transaction,
  }) {
    return IdempotencyKeyRow.db.findFirstRow(
      session,
      where: (t) =>
          t.actorAuthUserId.equals(actorAuthUserId) &
          t.action.equals(action) &
          t.clientOperationId.equals(clientOperationId),
      transaction: transaction,
    );
  }
}
