import 'package:test/test.dart';
import 'package:family_helper_server/src/core/storage/minio_storage_service.dart';

void main() {
  test('presigned URLs use HMAC signature and do not leak secret', () async {
    const secret = 'super-secret-key';
    final storage = MinioStorageService(
      endpoint: 'minio.local:9000',
      bucket: 'family-helper',
      signSecret: secret,
      useSsl: false,
      signUrlTtlSeconds: 900,
    );

    final getUrl = await storage.presignedGetUrl('avatars/user-1/avatar.jpg');
    final putUrl = await storage.presignedPutUrl('avatars/user-1/avatar.jpg');

    expect(getUrl.contains(secret), isFalse);
    expect(putUrl.contains(secret), isFalse);

    final getUri = Uri.parse(getUrl);
    expect(getUri.queryParameters['method'], 'GET');
    expect(getUri.queryParameters['signature'], isNotEmpty);
    expect(getUri.queryParameters['expires'], isNotEmpty);

    final putUri = Uri.parse(putUrl);
    expect(putUri.queryParameters['method'], 'PUT');
    expect(putUri.queryParameters['signature'], isNotEmpty);
    expect(putUri.queryParameters['signature'], isNot(getUri.queryParameters['signature']));
  });
}
