import 'dart:math';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import '../../core/auth/auth_context.dart';
import '../../core/clock/clock_service.dart';
import '../../core/idempotency/idempotency_service.dart';
import '../../core/rbac/ensure_family_role_service.dart';
import '../../core/storage/minio_storage_service.dart';
import '../../core/sync/change_feed_service.dart';
import '../../generated/protocol.dart';

class MediaService {
  MediaService({
    this.authContext = const AuthContext(),
    this.clock = const ClockService(),
    this.idempotency = const IdempotencyService(),
    this.rbac = const EnsureFamilyRoleService(),
    MinioStorageService? storage,
    this.changeFeed = const ChangeFeedService(),
  }) : storage = storage ?? MinioStorageService();

  final AuthContext authContext;
  final ClockService clock;
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

      if (mimeType.trim().isEmpty) {
        throw ArgumentError.value(mimeType, 'mimeType', 'MIME type is required.');
      }
      if (sizeBytes <= 0) {
        throw ArgumentError.value(sizeBytes, 'sizeBytes', 'Size must be positive.');
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

      final now = clock.nowUtc();
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

      final current = (await _requireMediaAccess(
        session,
        mediaId: mediaId,
        requireOwnerForPersonal: true,
        transaction: transaction,
      ))!;
      if (current.status == 'ready') {
        return _mapMedia(current);
      }
      if (current.status != 'uploading') {
        throw AccessDeniedException(
          message: 'Media is not in uploading state.',
        );
      }

      final now = clock.nowUtc();
      final expiresAt = current.uploadExpiresAt;
      if (expiresAt != null && expiresAt.isBefore(now)) {
        throw AccessDeniedException(message: 'Upload session has expired.');
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
    final row = (await _requireMediaAccess(
      session,
      mediaId: mediaId,
      requireOwnerForPersonal: true,
    ))!;
    if (row.status != 'ready') {
      throw AccessDeniedException(message: 'Media is not available for download.');
    }

    return storage.presignedGetUrl(row.objectKey);
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

      final row = await _requireMediaAccess(
        session,
        mediaId: mediaId,
        requireOwnerForPersonal: true,
        transaction: transaction,
        throwIfMissing: false,
      );
      if (row == null) {
        return OperationResult(success: true, message: 'Already deleted');
      }

      await MediaObjectRow.db.updateRow(
        session,
        row.copyWith(
          deletedAt: clock.nowUtc(),
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
        familyId: row.familyId,
        version: 1,
        tombstone: true,
        transaction: transaction,
      );

      return OperationResult(success: true, message: 'Media deleted');
    });
  }

  Future<MediaObjectRow?> _requireMediaAccess(
    Session session, {
    required int mediaId,
    bool requireOwnerForPersonal = false,
    bool throwIfMissing = true,
    Transaction? transaction,
  }) async {
    final row = await MediaObjectRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(mediaId) & t.deletedAt.equals(null),
      transaction: transaction,
    );
    if (row == null) {
      if (throwIfMissing) {
        throw FileNotFoundException(message: 'Media not found.');
      }
      return null;
    }

    if (row.familyId != null) {
      await rbac.ensureFamilyRole(
        session,
        familyId: row.familyId!,
        minRole: 'member',
        transaction: transaction,
      );
      return row;
    }

    final profileId = await authContext.ensureProfileId(
      session,
      transaction: transaction,
    );
    if (requireOwnerForPersonal && row.uploadedByProfileId != profileId) {
      throw AccessDeniedException(message: 'Access denied to personal media.');
    }

    return row;
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
