import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

class MinioStorageService {
  static const _passwordKeyEndpoint = 'minioEndpoint';
  static const _passwordKeyBucket = 'minioBucket';
  static const _passwordKeySecretKey = 'minioSecretKey';
  static const _passwordKeyPublicBaseUrl = 'minioPublicBaseUrl';
  static const _passwordKeyUseSsl = 'minioUseSsl';
  static const _passwordKeySignUrlTtl = 'minioSignUrlTtl';

  MinioStorageService({
    String? endpoint,
    String? bucket,
    String? signSecret,
    String? publicBaseUrl,
    int? signUrlTtlSeconds,
    bool? useSsl,
  }) : _endpoint =
           endpoint ??
           (Platform.environment['MINIO_ENDPOINT'] ?? 'localhost:9000'),
       _bucket =
           bucket ?? (Platform.environment['MINIO_BUCKET'] ?? 'family-helper'),
       _signSecret =
           signSecret ??
           (Platform.environment['MINIO_SECRET_KEY'] ?? 'dev-secret'),
       _publicBaseUrl =
           publicBaseUrl ?? Platform.environment['MINIO_PUBLIC_BASE_URL'],
       _signUrlTtlSeconds =
           signUrlTtlSeconds ??
           (int.tryParse(Platform.environment['SIGN_URL_TTL'] ?? '900') ?? 900),
       _useSsl =
           useSsl ??
           ((Platform.environment['MINIO_USE_SSL'] ?? 'false').toLowerCase() ==
               'true');

  final String _endpoint;
  final String _bucket;
  final String _signSecret;
  final String? _publicBaseUrl;
  final int _signUrlTtlSeconds;
  final bool _useSsl;

  String get bucket => _bucket;

  MinioStorageService forSession(Session session) {
    final passwords = session.passwords;
    final useSsl = passwords[_passwordKeyUseSsl];
    final ttlRaw = passwords[_passwordKeySignUrlTtl];
    return MinioStorageService(
      endpoint: passwords[_passwordKeyEndpoint] ?? _endpoint,
      bucket: passwords[_passwordKeyBucket] ?? _bucket,
      signSecret: passwords[_passwordKeySecretKey] ?? _signSecret,
      publicBaseUrl: passwords[_passwordKeyPublicBaseUrl] ?? _publicBaseUrl,
      signUrlTtlSeconds: ttlRaw != null
          ? int.tryParse(ttlRaw)
          : _signUrlTtlSeconds,
      useSsl: useSsl != null ? useSsl.toLowerCase() == 'true' : _useSsl,
    );
  }

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

    final canonical = '$method\n$_bucket\n$objectKey\n$expiresEpoch';
    final signature = _hmac(canonical, _signSecret);
    final escapedKey = Uri.encodeComponent(objectKey).replaceAll('%2F', '/');

    return '${_baseUrl()}/$_bucket/$escapedKey'
        '?expires=$expiresEpoch'
        '&method=$method'
        '&signature=$signature';
  }

  String _baseUrl() {
    if (_publicBaseUrl != null && _publicBaseUrl.trim().isNotEmpty) {
      return _publicBaseUrl.replaceAll(RegExp(r'/+$'), '');
    }
    final scheme = _useSsl ? 'https' : 'http';
    return '$scheme://$_endpoint';
  }

  static String _hmac(String canonical, String secret) {
    final bytes = utf8.encode(canonical);
    final key = utf8.encode(secret);
    final digest = Hmac(sha256, key).convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }
}
