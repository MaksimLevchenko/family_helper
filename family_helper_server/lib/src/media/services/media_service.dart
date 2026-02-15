import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../../core/auth/auth_context.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/storage/minio_storage_service.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class MediaService {
  MediaService({
    this.authContext = const AuthContext(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    MinioStorageService? storage,
    this.changeFeed = const ChangeFeedService(),
  }) : storage = storage ?? MinioStorageService();

  final AuthContext authContext;
  final IdempotencyService idempotency;
  final EnsureFamilyRoleService rbac;
  final MinioStorageService storage;
  final ChangeFeedService changeFeed;

  Future<UploadSessionDto> createUploadSession(
    Session session, {
    required String clientOperationId,
    int? familyId,
    required String mimeType,
    required int sizeBytes,
    String objectPrefix = 'media',
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      int profileId;
      if (familyId != null) {
        profileId = await rbac.ensureFamilyRole(
          session,
          familyId: familyId,
          minRole: 'member',
          transaction: transaction,
        );
      } else {
        profileId = await authContext.ensureProfileId(
          session,
          transaction: transaction,
        );
      }

      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'media.createUploadSession',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        final existing = await session.db.unsafeQuery(
          '''
          SELECT
            id,
            object_key,
            upload_expires_at
          FROM media_object
          WHERE uploaded_by_profile_id = @profileId
            AND client_operation_id = @clientOperationId
          ORDER BY id DESC
          LIMIT 1
          ''',
          parameters: QueryParameters.named({
            'profileId': profileId,
            'clientOperationId': clientOperationId,
          }),
          transaction: transaction,
        );

        if (existing.isNotEmpty) {
          final row = existing.first.toColumnMap();
          return UploadSessionDto(
            mediaId: row['id'] as int,
            objectKey: row['object_key'] as String,
            uploadUrl: await storage.presignedPutUrl(row['object_key'] as String),
            expiresAt: row['upload_expires_at'] as DateTime,
          );
        }
      }

      final now = DateTime.now().toUtc();
      final objectKey = '$objectPrefix/${_randomCode(12)}/${_randomCode(18)}';
      final expiresAt = now.add(const Duration(minutes: 15));
      final insertRows = await session.db.unsafeQuery(
        '''
        INSERT INTO media_object (
          family_id,
          uploaded_by_profile_id,
          object_key,
          bucket,
          mime_type,
          size_bytes,
          status,
          thumbnail_key,
          client_operation_id,
          upload_expires_at,
          created_at,
          deleted_at,
          version
        ) VALUES (
          @familyId,
          @profileId,
          @objectKey,
          @bucket,
          @mimeType,
          @sizeBytes,
          'uploading',
          NULL,
          @clientOperationId,
          @uploadExpiresAt,
          @createdAt,
          NULL,
          1
        )
        RETURNING id, object_key, upload_expires_at
        ''',
        parameters: QueryParameters.named({
          'familyId': familyId,
          'profileId': profileId,
          'objectKey': objectKey,
          'bucket': storage.bucket,
          'mimeType': mimeType,
          'sizeBytes': sizeBytes,
          'clientOperationId': clientOperationId,
          'uploadExpiresAt': expiresAt,
          'createdAt': now,
        }),
        transaction: transaction,
      );

      final row = insertRows.first.toColumnMap();
      return UploadSessionDto(
        mediaId: row['id'] as int,
        objectKey: row['object_key'] as String,
        uploadUrl: await storage.presignedPutUrl(row['object_key'] as String),
        expiresAt: row['upload_expires_at'] as DateTime,
      );
    });
  }

  Future<MediaObjectDto> completeUpload(
    Session session, {
    required String clientOperationId,
    required int mediaId,
    String? thumbnailKey,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      final isFresh = await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'media.completeUpload',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      if (!isFresh) {
        final existingRows = await session.db.unsafeQuery(
          '''
          SELECT
            id,
            family_id,
            uploaded_by_profile_id,
            object_key,
            bucket,
            mime_type,
            size_bytes,
            status,
            thumbnail_key,
            created_at,
            deleted_at
          FROM media_object
          WHERE id = @id
          LIMIT 1
          ''',
          parameters: QueryParameters.named({'id': mediaId}),
          transaction: transaction,
        );
        if (existingRows.isNotEmpty) {
          return _mapMedia(existingRows.first.toColumnMap());
        }
      }

      final now = DateTime.now().toUtc();
      await session.db.unsafeExecute(
        '''
        UPDATE media_object
        SET
          status = 'ready',
          thumbnail_key = COALESCE(@thumbnailKey, thumbnail_key),
          updated_at = @updatedAt,
          version = version + 1
        WHERE id = @id
          AND deleted_at IS NULL
        ''',
        parameters: QueryParameters.named({
          'id': mediaId,
          'thumbnailKey': thumbnailKey,
          'updatedAt': now,
        }),
        transaction: transaction,
      );

      final rows = await session.db.unsafeQuery(
        '''
        SELECT
          id,
          family_id,
          uploaded_by_profile_id,
          object_key,
          bucket,
          mime_type,
          size_bytes,
          status,
          thumbnail_key,
          created_at,
          deleted_at
        FROM media_object
        WHERE id = @id
        LIMIT 1
        ''',
        parameters: QueryParameters.named({'id': mediaId}),
        transaction: transaction,
      );

      final media = _mapMedia(rows.first.toColumnMap());
      await changeFeed.appendChange(
        session,
        feature: 'media',
        entityType: 'media_object',
        entityId: media.id,
        operation: 'uploaded',
        familyId: media.familyId,
        version: 1,
        payload: {'status': media.status},
        transaction: transaction,
      );

      return media;
    });
  }

  Future<String> signedGetUrl(
    Session session, {
    required int mediaId,
  }) async {
    final rows = await session.db.unsafeQuery(
      '''
      SELECT
        id,
        family_id,
        uploaded_by_profile_id,
        object_key,
        bucket,
        mime_type,
        size_bytes,
        status,
        thumbnail_key,
        created_at,
        deleted_at
      FROM media_object
      WHERE id = @id
        AND deleted_at IS NULL
      LIMIT 1
      ''',
      parameters: QueryParameters.named({'id': mediaId}),
    );
    if (rows.isEmpty) {
      throw Exception('Media not found');
    }

    final media = _mapMedia(rows.first.toColumnMap());
    if (media.familyId != null) {
      await rbac.ensureFamilyRole(session, familyId: media.familyId!, minRole: 'member');
    }

    return storage.presignedGetUrl(media.objectKey);
  }

  Future<OperationResult> softDelete(
    Session session, {
    required String clientOperationId,
    required int mediaId,
  }) async {
    final authUserId = authContext.requireAuthUserId(session).uuid;

    return session.db.transaction((transaction) async {
      await idempotency.tryBegin(
        session,
        actorAuthUserId: authUserId,
        action: 'media.softDelete',
        clientOperationId: clientOperationId,
        transaction: transaction,
      );

      final rows = await session.db.unsafeQuery(
        'SELECT family_id FROM media_object WHERE id = @id LIMIT 1',
        parameters: QueryParameters.named({'id': mediaId}),
        transaction: transaction,
      );
      if (rows.isEmpty) {
        return OperationResult(success: true, message: 'Already deleted');
      }

      final familyId = rows.first.toColumnMap()['family_id'] as int?;
      if (familyId != null) {
        await rbac.ensureFamilyRole(
          session,
          familyId: familyId,
          minRole: 'member',
          transaction: transaction,
        );
      }

      await session.db.unsafeExecute(
        '''
        UPDATE media_object
        SET deleted_at = @deletedAt,
            status = 'deleted',
            version = version + 1
        WHERE id = @id
        ''',
        parameters: QueryParameters.named({
          'id': mediaId,
          'deletedAt': DateTime.now().toUtc(),
        }),
        transaction: transaction,
      );

      await changeFeed.appendChange(
        session,
        feature: 'media',
        entityType: 'media_object',
        entityId: mediaId,
        operation: 'deleted',
        familyId: familyId,
        version: 1,
        tombstone: true,
        transaction: transaction,
      );

      return OperationResult(success: true, message: 'Media deleted');
    });
  }

  MediaObjectDto _mapMedia(Map<String, dynamic> row) {
    return MediaObjectDto(
      id: row['id'] as int,
      familyId: row['family_id'] as int?,
      uploadedByProfileId: row['uploaded_by_profile_id'] as int,
      objectKey: row['object_key'] as String,
      bucket: row['bucket'] as String,
      mimeType: row['mime_type'] as String,
      sizeBytes: row['size_bytes'] as int,
      status: row['status'] as String,
      thumbnailKey: row['thumbnail_key'] as String?,
      createdAt: row['created_at'] as DateTime,
      deletedAt: row['deleted_at'] as DateTime?,
    );
  }

  String _randomCode(int length) {
    const alphabet = 'abcdef0123456789';
    final random = Random.secure();
    return List<String>.generate(
      length,
      (_) => alphabet[random.nextInt(alphabet.length)],
    ).join();
  }
}
