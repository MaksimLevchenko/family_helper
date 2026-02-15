import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Media completeUpload idempotency', (sessionBuilder, endpoints) {
    test('completeUpload with same operation id is idempotent', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);

      final family = await endpoints.family.createFamily(
        owner,
        clientOperationId: 'family-create-media-001',
        title: 'Media Family',
      );

      final upload = await endpoints.media.createUploadSession(
        owner,
        clientOperationId: 'media-upload-session-001',
        familyId: family.id,
        mimeType: 'image/jpeg',
        sizeBytes: 12345,
        objectPrefix: 'avatars',
      );

      final first = await endpoints.media.completeUpload(
        owner,
        clientOperationId: 'media-complete-001',
        mediaId: upload.mediaId,
      );
      final second = await endpoints.media.completeUpload(
        owner,
        clientOperationId: 'media-complete-001',
        mediaId: upload.mediaId,
      );

      expect(first.id, second.id);
      expect(second.status, 'ready');

      final changeCount = await withDbSession(owner, (session) async {
        final rows = await session.db.unsafeQuery(
          '''
          SELECT COUNT(*) AS total
          FROM change_feed
          WHERE feature = 'media'
            AND entity_type = 'media_object'
            AND entity_id = @mediaId
            AND operation = 'uploaded'
          ''',
          parameters: QueryParameters.named({'mediaId': upload.mediaId}),
        );
        return rows.first.toColumnMap()['total'] as int;
      });

      expect(changeCount, 1);
    });
  });
}
