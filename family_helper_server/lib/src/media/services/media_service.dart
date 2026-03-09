import 'dart:math';
import 'package:serverpod/protocol.dart';
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
    final storage = this.storage.forSession(session);
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
        final existing = await MediaObjectRow.db.findFirstRow(
          session,
          where: (t) =>
              t.uploadedByProfileId.equals(profileId) &
              t.clientOperationId.equals(clientOperationId),
          orderBy: (t) => t.id,
          orderDescending: true,
          transaction: transaction,
        );

        if (existing != null) {
          return UploadSessionDto(
            mediaId: existing.id!,
            objectKey: existing.objectKey,
            uploadUrl: await storage.presignedPutUrl(
              existing.objectKey,
            ),
            expiresAt: existing.uploadExpiresAt!,
          );
        }
      }

      final now = DateTime.now().toUtc();
      final objectKey = '$objectPrefix/${_randomCode(12)}/${_randomCode(18)}';
      final expiresAt = now.add(const Duration(minutes: 15));
      final row = await MediaObjectRow.db.insertRow(
        session,
        MediaObjectRow(
          familyId: familyId,
          uploadedByProfileId: profileId,
          objectKey: objectKey,
          bucket: storage.bucket,
          mimeType: mimeType,
          sizeBytes: sizeBytes,
          status: 'uploading',
          thumbnailKey: null,
          clientOperationId: clientOperationId,
          uploadExpiresAt: expiresAt,
          createdAt: now,
          updatedAt: null,
          deletedAt: null,
          version: 1,
        ),
        transaction: transaction,
      );
      return UploadSessionDto(
        mediaId: row.id!,
        objectKey: row.objectKey,
        uploadUrl: await storage.presignedPutUrl(row.objectKey),
        expiresAt: row.uploadExpiresAt!,
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
        final existing = await MediaObjectRow.db.findById(
          session,
          mediaId,
          transaction: transaction,
        );
        if (existing != null) {
          return _mapMedia(existing);
        }
      }

      final now = DateTime.now().toUtc();
      final current = await MediaObjectRow.db.findFirstRow(
        session,
        where: (t) => t.id.equals(mediaId) & t.deletedAt.equals(null),
        transaction: transaction,
      );
      if (current == null) {
        throw FileNotFoundException(message: 'Media not found.');
      }
      await MediaObjectRow.db.updateRow(
        session,
        current.copyWith(
          status: 'ready',
          thumbnailKey: thumbnailKey ?? current.thumbnailKey,
          updatedAt: now,
          version: current.version + 1,
        ),
        transaction: transaction,
      );

      final row = await MediaObjectRow.db.findById(
        session,
        mediaId,
        transaction: transaction,
      );

      final media = _mapMedia(row!);
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
    final storage = this.storage.forSession(session);
    final row = await MediaObjectRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(mediaId) & t.deletedAt.equals(null),
    );
    if (row == null) {
      throw FileNotFoundException(message: 'Media not found.');
    }

    final media = _mapMedia(row);
    if (media.familyId != null) {
      await rbac.ensureFamilyRole(
        session,
        familyId: media.familyId!,
        minRole: 'member',
      );
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

      final row = await MediaObjectRow.db.findById(
        session,
        mediaId,
        transaction: transaction,
      );
      if (row == null) {
        return OperationResult(success: true, message: 'Already deleted');
      }

      final familyId = row.familyId;
      if (familyId != null) {
        await rbac.ensureFamilyRole(
          session,
          familyId: familyId,
          minRole: 'member',
          transaction: transaction,
        );
      }

      await MediaObjectRow.db.updateRow(
        session,
        row.copyWith(
          deletedAt: DateTime.now().toUtc(),
          status: 'deleted',
          version: row.version + 1,
        ),
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

  MediaObjectDto _mapMedia(MediaObjectRow row) {
    return MediaObjectDto(
      id: row.id!,
      familyId: row.familyId,
      uploadedByProfileId: row.uploadedByProfileId,
      objectKey: row.objectKey,
      bucket: row.bucket,
      mimeType: row.mimeType,
      sizeBytes: row.sizeBytes,
      status: row.status,
      thumbnailKey: row.thumbnailKey,
      createdAt: row.createdAt,
      deletedAt: row.deletedAt,
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
