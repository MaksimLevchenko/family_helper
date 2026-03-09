import 'package:family_helper_server/src/core/idempotency/idempotency_service.dart';
import 'package:family_helper_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

base class _FakeDatabaseQueryException extends DatabaseQueryException {
  _FakeDatabaseQueryException({
    required this.message,
    required this.code,
  });

  @override
  final String message;
  @override
  final String? code;

  @override
  String? get detail => null;

  @override
  String? get hint => null;

  @override
  String? get tableName => null;

  @override
  String? get columnName => null;

  @override
  String? get constraintName => null;

  @override
  int? get position => null;
}

class _StubIdempotencyService extends IdempotencyService {
  const _StubIdempotencyService({this.error});

  final Object? error;

  @override
  Future<void> insertIdempotencyKey(
    Session session, {
    required IdempotencyKeyRow row,
    Transaction? transaction,
  }) async {
    if (error != null) {
      throw error!;
    }
  }
}

void main() {
  withServerpod('Idempotency service errors', (sessionBuilder, _) {
    test('tryBegin returns false on unique violation (23505)', () async {
      final service = _StubIdempotencyService(
        error: _FakeDatabaseQueryException(
          message: 'duplicate key value violates unique constraint',
          code: '23505',
        ),
      );

      final isFresh = await withDbSession(sessionBuilder, (session) {
        return service.tryBegin(
          session,
          actorAuthUserId: user1Id,
          action: 'idempotency.test.duplicate',
          clientOperationId: 'duplicate-001',
        );
      });

      expect(isFresh, isFalse);
    });

    test('tryBegin rethrows non-23505 database errors', () async {
      final service = _StubIdempotencyService(
        error: _FakeDatabaseQueryException(
          message: 'invalid input syntax',
          code: '22P02',
        ),
      );

      await withDbSession(sessionBuilder, (session) async {
        await expectLater(
          service.tryBegin(
            session,
            actorAuthUserId: user1Id,
            action: 'idempotency.test.non23505',
            clientOperationId: 'non23505-001',
          ),
          throwsA(isA<DatabaseQueryException>()),
        );
      });
    });
  });
}
