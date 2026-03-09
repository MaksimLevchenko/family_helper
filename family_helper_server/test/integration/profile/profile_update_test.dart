import 'package:test/test.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Profile update', (sessionBuilder, endpoints) {
    test('clearAvatarMedia explicitly removes avatar reference', () async {
      final owner = authenticatedBuilder(sessionBuilder, user1Id);

      final upload = await endpoints.media.createUploadSession(
        owner,
        clientOperationId: 'profile-avatar-upload-001',
        mimeType: 'image/png',
        sizeBytes: 2048,
        objectPrefix: 'avatars',
      );

      await endpoints.media.completeUpload(
        owner,
        clientOperationId: 'profile-avatar-complete-001',
        mediaId: upload.mediaId,
      );

      final withAvatar = await endpoints.profile.update(
        owner,
        clientOperationId: 'profile-avatar-set-001',
        avatarMediaId: upload.mediaId,
        clearAvatarMedia: false,
      );
      expect(withAvatar.avatarMediaId, upload.mediaId);

      final cleared = await endpoints.profile.update(
        owner,
        clientOperationId: 'profile-avatar-clear-001',
        clearAvatarMedia: true,
      );
      expect(cleared.avatarMediaId, isNull);
    });
  });
}
