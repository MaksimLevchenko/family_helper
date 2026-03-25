import 'package:test/test.dart';

import 'package:family_helper_server/src/core/storage/private_media_storage_service.dart';
import 'package:family_helper_server/src/generated/protocol.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/http_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Database-backed media storage',
    (sessionBuilder, endpoints) {
      test(
        'upload uses direct POST endpoint and signed download serves bytes',
        () async {
          final owner = authenticatedBuilder(sessionBuilder, user1Id);
          final bytes = List<int>.generate(64, (index) => index);

          final upload = await endpoints.media.createUploadSession(
            owner,
            clientOperationId: 'db-storage-upload-001',
            mimeType: 'image/png',
            sizeBytes: bytes.length,
            objectPrefix: 'avatars',
          );

          final uploadUri = Uri.parse(upload.uploadUrl);
          expect(uploadUri.path, '/serverpod_cloud_storage');
          expect(uploadUri.queryParameters['method'], 'upload');
          expect(uploadUri.queryParameters['storage'], 'private');

          final uploadResult = await postBinary(upload.uploadUrl, bytes);
          expect(uploadResult.statusCode, 200);
          expect(uploadResult.bodyText, 'true');

          final media = await endpoints.media.completeUpload(
            owner,
            clientOperationId: 'db-storage-complete-001',
            mediaId: upload.mediaId,
          );
          expect(media.status, 'ready');

          final signedUrl = await endpoints.media.signedGetUrl(
            owner,
            mediaId: media.id,
          );
          final signedUri = Uri.parse(signedUrl);
          expect(
            signedUri.path,
            PrivateMediaStorageService.privateMediaRoutePath,
          );
          expect(signedUri.queryParameters['signature'], isNotEmpty);

          final storageState = await withDbSession(owner, (session) async {
            final storage = PrivateMediaStorageService().forSession(session);
            final validation = storage.validateSignedDownloadUri(signedUri);
            final escapedPath = media.objectKey.replaceAll("'", "''");
            final row = await session.db.unsafeQuery(
              'SELECT verified, octet_length("byteData") '
              'FROM serverpod_cloud_storage '
              "WHERE \"storageId\"='${PrivateMediaStorageService.storageId}' "
              "AND path='$escapedPath'",
            );
            return (validation: validation, row: row);
          });
          expect(storageState.validation.isValid, isTrue);
          expect(storageState.row, hasLength(1));
          expect(storageState.row.first[1], bytes.length);
        },
      );

      test('signed download rejects invalid and expired signatures', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final bytes = List<int>.filled(32, 3);

        final mediaId = await _createReadyMedia(
          owner,
          endpoints,
          bytes: bytes,
          clientOperationId: 'db-storage-signed-url',
        );
        final signedUrl = await endpoints.media.signedGetUrl(
          owner,
          mediaId: mediaId,
        );

        final invalidUri = Uri.parse(signedUrl).replace(
          queryParameters: {
            ...Uri.parse(signedUrl).queryParameters,
            'signature': 'invalid',
          },
        );
        final invalidResult = await withDbSession(owner, (session) async {
          final storage = PrivateMediaStorageService().forSession(session);
          return storage.validateSignedDownloadUri(invalidUri);
        });
        expect(invalidResult.error, SignedDownloadValidationError.invalid);

        final expiredUrl = await withDbSession(owner, (session) async {
          final row = await MediaObjectRow.db.findById(session, mediaId);
          final storage = PrivateMediaStorageService().forSession(session);
          return storage.createSignedDownloadUrl(
            session,
            path: row!.objectKey,
            mimeType: row.mimeType,
            expiresAt: DateTime.now().toUtc().subtract(
              const Duration(minutes: 1),
            ),
          );
        });

        final expiredFetch = await withDbSession(owner, (session) async {
          final storage = PrivateMediaStorageService().forSession(session);
          return storage.validateSignedDownloadUri(Uri.parse(expiredUrl));
        });
        expect(expiredFetch.error, SignedDownloadValidationError.expired);
      });

      test('soft deleted media no longer returns a fresh signed URL', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final mediaId = await _createReadyMedia(
          owner,
          endpoints,
          bytes: List<int>.filled(16, 6),
          clientOperationId: 'db-storage-soft-delete',
        );

        final result = await endpoints.media.softDelete(
          owner,
          clientOperationId: 'db-storage-soft-delete-001',
          mediaId: mediaId,
        );
        expect(result.success, isTrue);

        await expectLater(
          () => endpoints.media.signedGetUrl(owner, mediaId: mediaId),
          throwsA(isA<Exception>()),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}

Future<int> _createReadyMedia(
  TestSessionBuilder owner,
  TestEndpoints endpoints, {
  required List<int> bytes,
  required String clientOperationId,
}) async {
  final upload = await endpoints.media.createUploadSession(
    owner,
    clientOperationId: '$clientOperationId-upload',
    mimeType: 'image/png',
    sizeBytes: bytes.length,
    objectPrefix: 'avatars',
  );

  final uploadResult = await postBinary(upload.uploadUrl, bytes);
  expect(uploadResult.statusCode, 200);
  expect(uploadResult.bodyText, 'true');

  final media = await endpoints.media.completeUpload(
    owner,
    clientOperationId: '$clientOperationId-complete',
    mediaId: upload.mediaId,
  );
  return media.id;
}
