import 'package:test/test.dart';

import 'package:family_helper_server/src/generated/protocol.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Personal media access control', (sessionBuilder, endpoints) {
    test('non-owner cannot complete, read, or delete personal media', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);
      final outsider = authenticatedBuilder(sessionBuilder, user2Id);

      final upload = await endpoints.media.createUploadSession(
        owner,
        clientOperationId: 'personal-media-upload-001',
        mimeType: 'image/jpeg',
        sizeBytes: 1024,
        objectPrefix: 'avatars',
      );

      await expectLater(
        () => endpoints.media.completeUpload(
          outsider,
          clientOperationId: 'personal-media-complete-002',
          mediaId: upload.mediaId,
        ),
        throwsA(isA<Exception>()),
      );

      await endpoints.media.completeUpload(
        owner,
        clientOperationId: 'personal-media-complete-001',
        mediaId: upload.mediaId,
      );

      await expectLater(
        () => endpoints.media.signedGetUrl(outsider, mediaId: upload.mediaId),
        throwsA(isA<Exception>()),
      );

      await expectLater(
        () => endpoints.media.softDelete(
          outsider,
          clientOperationId: 'personal-media-delete-001',
          mediaId: upload.mediaId,
        ),
        throwsA(isA<Exception>()),
      );

      final stored = await withDbSession(owner, (session) async {
        return MediaObjectRow.db.findById(session, upload.mediaId);
      });

      expect(stored, isNotNull);
      expect(stored!.status, 'ready');
      expect(stored.deletedAt, isNull);
    });
  });
}
