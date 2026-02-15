import 'dart:convert';
import 'dart:io';

class MinioStorageService {
  MinioStorageService()
    : _endpoint = Platform.environment['S3_ENDPOINT'] ?? 'localhost:9000',
      _bucket = Platform.environment['S3_BUCKET'] ?? 'family-helper',
      _signSecret = Platform.environment['S3_SECRET_KEY'] ?? 'dev-secret',
      _signUrlTtlSeconds =
          int.tryParse(Platform.environment['SIGN_URL_TTL'] ?? '900') ?? 900,
      _useSsl =
          (Platform.environment['S3_USE_SSL'] ?? 'false').toLowerCase() ==
          'true';

  final String _endpoint;
  final String _bucket;
  final String _signSecret;
  final int _signUrlTtlSeconds;
  final bool _useSsl;

  String get bucket => _bucket;

  Future<String> presignedPutUrl(String objectKey) async {
    return _signedUrl(method: 'PUT', objectKey: objectKey);
  }

  Future<String> presignedGetUrl(String objectKey) async {
    return _signedUrl(method: 'GET', objectKey: objectKey);
  }

  String _signedUrl({required String method, required String objectKey}) {
    final expiresAt = DateTime.now().toUtc().add(
      Duration(seconds: _signUrlTtlSeconds),
    );
    final expiresEpoch = expiresAt.millisecondsSinceEpoch ~/ 1000;

    final payload = '$method|$_bucket|$objectKey|$expiresEpoch|$_signSecret';
    final signature = base64Url.encode(utf8.encode(payload));

    final scheme = _useSsl ? 'https' : 'http';
    return '$scheme://$_endpoint/$_bucket/$objectKey?expires=$expiresEpoch&signature=$signature';
  }
}
