import 'package:test/test.dart';
import 'package:family_helper_server/src/core/storage/minio_storage_service.dart';

import '../test_tools/auth_helpers.dart';
import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Minio storage signing',
    (sessionBuilder, _) {
      test('presigned URLs use AWS-compatible signing', () async {
        final owner = authenticatedBuilder(sessionBuilder, user1Id);
        final storage = await withDbSession(owner, (session) async {
          return MinioStorageService().forSession(session);
        });

        final getUrl = await storage.presignedGetUrl(
          'avatars/user-1/avatar.jpg',
        );
        final putUrl = await storage.presignedPutUrl(
          'avatars/user-1/avatar.jpg',
        );

        expect(getUrl.contains('method='), isFalse);
        expect(putUrl.contains('method='), isFalse);

        final getUri = Uri.parse(getUrl);
        expect(getUri.path, contains('/avatars/user-1/avatar.jpg'));
        expect(
          RegExp(r'(^|[?&])x-amz-algorithm=', caseSensitive: false).hasMatch(
            getUri.query,
          ),
          isTrue,
        );
        expect(
          RegExp(r'(^|[?&])x-amz-credential=', caseSensitive: false).hasMatch(
            getUri.query,
          ),
          isTrue,
        );
        expect(
          RegExp(r'(^|[?&])x-amz-expires=', caseSensitive: false).hasMatch(
            getUri.query,
          ),
          isTrue,
        );
        expect(
          RegExp(r'(^|[?&])x-amz-signature=', caseSensitive: false).hasMatch(
            getUri.query,
          ),
          isTrue,
        );

        final putUri = Uri.parse(putUrl);
        expect(putUri.path, contains('/avatars/user-1/avatar.jpg'));
        expect(
          RegExp(r'(^|[?&])x-amz-signature=', caseSensitive: false).hasMatch(
            putUri.query,
          ),
          isTrue,
        );
        expect(putUri.query, isNot(equals(getUri.query)));
      });
    },
  );
}
