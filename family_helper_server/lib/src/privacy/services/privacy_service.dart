import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/storage/minio_storage_service.dart';
import '../../generated/protocol.dart';

class PrivacyService {
  PrivacyService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    MinioStorageService? storage,
  }) : storage = storage ?? MinioStorageService();

  final AuthContext authContext;
  final IdempotencyService idempotency;
  final MinioStorageService storage;

  Future<PrivacyExportJobDto> requestExport(
    Session session, {
    required String clientOperationId,
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
        action: 'privacy.requestExport',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        final existing = await session.db.unsafeQuery(
          '''
          SELECT
            id,
            profile_id,
            status,
            signed_url,
            expires_at,
            created_at,
            completed_at
          FROM privacy_export_job
          WHERE profile_id = @profileId
          ORDER BY id DESC
          LIMIT 1
          ''',
          parameters: QueryParameters.named({'profileId': profileId}),
          transaction: transaction,
        );
        if (existing.isNotEmpty) {
          return _mapExport(existing.first.toColumnMap());
        }
      }

      final rows = await session.db.unsafeQuery(
        '''
        INSERT INTO privacy_export_job (
          profile_id,
          status,
          object_key,
          signed_url,
          expires_at,
          created_at,
          completed_at
        ) VALUES (
          @profileId,
          'pending',
          @objectKey,
          NULL,
          NULL,
          @createdAt,
          NULL
        )
        RETURNING
          id,
          profile_id,
          status,
          signed_url,
          expires_at,
          created_at,
          completed_at
        ''',
        parameters: QueryParameters.named({
          'profileId': profileId,
          'objectKey': 'exports/profile_$profileId/export_${DateTime.now().millisecondsSinceEpoch}.json',
          'createdAt': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      return _mapExport(rows.first.toColumnMap());
    });
  }

  Future<AccountDeletionStatusDto> requestAccountDeletion(
    Session session, {
    required String clientOperationId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'privacy.requestDeletion',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final graceDays =
          int.tryParse(Platform.environment['DELETION_GRACE_DAYS'] ?? '30') ?? 30;
      final scheduled = DateTime.now().toUtc().add(Duration(days: graceDays));

      final rows = await session.db.unsafeQuery(
        '''
        INSERT INTO account_deletion_request (
          profile_id,
          status,
          scheduled_hard_delete_at,
          created_at,
          cancelled_at
        ) VALUES (
          @profileId,
          'scheduled',
          @scheduled,
          @createdAt,
          NULL
        )
        ON CONFLICT (profile_id)
        DO UPDATE SET
          status = 'scheduled',
          scheduled_hard_delete_at = EXCLUDED.scheduled_hard_delete_at,
          cancelled_at = NULL
        RETURNING
          id,
          profile_id,
          status,
          scheduled_hard_delete_at,
          created_at,
          cancelled_at
        ''',
        parameters: QueryParameters.named({
          'profileId': profileId,
          'scheduled': scheduled,
          'createdAt': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      return _mapDeletion(rows.first.toColumnMap());
    });
  }

  Future<AccountDeletionStatusDto> cancelAccountDeletion(Session session) async {
    return session.db.transaction((transaction) async {
      final profileId = await authContext.ensureProfileId(
        session,
        transaction: transaction,
      );

      final now = DateTime.now().toUtc();
      final rows = await session.db.unsafeQuery(
        '''
        UPDATE account_deletion_request
        SET
          status = 'cancelled',
          cancelled_at = @cancelledAt
        WHERE profile_id = @profileId
        RETURNING
          id,
          profile_id,
          status,
          scheduled_hard_delete_at,
          created_at,
          cancelled_at
        ''',
        parameters: QueryParameters.named({
          'profileId': profileId,
          'cancelledAt': now,
        }),
        transaction: transaction,
      );

      if (rows.isEmpty) {
        throw Exception('No deletion request found');
      }

      return _mapDeletion(rows.first.toColumnMap());
    });
  }

  Future<int> processExportJobs(Session session) async {
    final pending = await session.db.unsafeQuery(
      '''
      SELECT id, profile_id, object_key
      FROM privacy_export_job
      WHERE status = 'pending'
      ORDER BY id ASC
      LIMIT 100
      ''',
    );

    int processed = 0;
    for (final row in pending) {
      final map = row.toColumnMap();
      final id = map['id'] as int;
      final objectKey = map['object_key'] as String;
      final signedUrl = await storage.presignedGetUrl(objectKey);
      final expiresAt = DateTime.now().toUtc().add(const Duration(hours: 24));

      await session.db.unsafeExecute(
        '''
        UPDATE privacy_export_job
        SET
          status = 'ready',
          signed_url = @signedUrl,
          expires_at = @expiresAt,
          completed_at = @completedAt
        WHERE id = @id
        ''',
        parameters: QueryParameters.named({
          'id': id,
          'signedUrl': signedUrl,
          'expiresAt': expiresAt,
          'completedAt': DateTime.now().toUtc(),
        }),
      );

      processed += 1;
    }

    return processed;
  }

  Future<int> processHardDeletion(Session session) async {
    final due = await session.db.unsafeQuery(
      '''
      SELECT profile_id
      FROM account_deletion_request
      WHERE status = 'scheduled'
        AND scheduled_hard_delete_at <= @now
      ''',
      parameters: QueryParameters.named({'now': DateTime.now().toUtc()}),
    );

    int deleted = 0;
    for (final row in due) {
      final profileId = row.toColumnMap()['profile_id'] as int;
      await session.db.transaction((transaction) async {
        await session.db.unsafeExecute(
          'UPDATE app_profile SET deleted_at = @deletedAt, version = version + 1 WHERE id = @id',
          parameters: QueryParameters.named({
            'id': profileId,
            'deletedAt': DateTime.now().toUtc(),
          }),
          transaction: transaction,
        );
        await session.db.unsafeExecute(
          '''
          UPDATE account_deletion_request
          SET status = 'hard_deleted'
          WHERE profile_id = @profileId
          ''',
          parameters: QueryParameters.named({'profileId': profileId}),
          transaction: transaction,
        );
      });
      deleted += 1;
    }

    return deleted;
  }

  PrivacyExportJobDto _mapExport(Map<String, dynamic> row) {
    return PrivacyExportJobDto(
      id: row['id'] as int,
      profileId: row['profile_id'] as int,
      status: row['status'] as String,
      signedUrl: row['signed_url'] as String?,
      expiresAt: row['expires_at'] as DateTime?,
      createdAt: row['created_at'] as DateTime,
      completedAt: row['completed_at'] as DateTime?,
    );
  }

  AccountDeletionStatusDto _mapDeletion(Map<String, dynamic> row) {
    return AccountDeletionStatusDto(
      id: row['id'] as int,
      profileId: row['profile_id'] as int,
      status: row['status'] as String,
      scheduledHardDeleteAt: row['scheduled_hard_delete_at'] as DateTime,
      createdAt: row['created_at'] as DateTime,
      cancelledAt: row['cancelled_at'] as DateTime?,
    );
  }
}
