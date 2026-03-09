import 'dart:io';
import 'dart:typed_data';
import 'package:minio/minio.dart';
import 'package:serverpod/serverpod.dart';

class MinioStorageService {
  static const _passwordKeyEndpoint = 'minioEndpoint';
  static const _passwordKeyBucket = 'minioBucket';
  static const _passwordKeyAccessKey = 'minioAccessKey';
  static const _passwordKeySecretKey = 'minioSecretKey';
  static const _passwordKeyPublicBaseUrl = 'minioPublicBaseUrl';
  static const _passwordKeyUseSsl = 'minioUseSsl';
  static const _passwordKeySignUrlTtl = 'minioSignUrlTtl';

  MinioStorageService({
    String? endpoint,
    String? bucket,
    String? accessKey,
    String? signSecret,
    String? publicBaseUrl,
    int? signUrlTtlSeconds,
    bool? useSsl,
  }) : _endpoint =
           endpoint ??
           (Platform.environment['MINIO_ENDPOINT'] ?? 'localhost:9000'),
       _bucket =
           bucket ?? (Platform.environment['MINIO_BUCKET'] ?? 'family-helper'),
       _accessKey =
           accessKey ??
           Platform.environment['MINIO_ACCESS_KEY'] ??
           Platform.environment['MINIO_ROOT_USER'] ??
           'replace-me',
       _signSecret =
           signSecret ??
           Platform.environment['MINIO_SECRET_KEY'] ??
           Platform.environment['MINIO_ROOT_PASSWORD'] ??
           'replace-me',
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
  final String _accessKey;
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
      accessKey: passwords[_passwordKeyAccessKey] ?? _accessKey,
      signSecret: passwords[_passwordKeySecretKey] ?? _signSecret,
      publicBaseUrl: passwords[_passwordKeyPublicBaseUrl] ?? _publicBaseUrl,
      signUrlTtlSeconds: ttlRaw != null
          ? int.tryParse(ttlRaw)
          : _signUrlTtlSeconds,
      useSsl: useSsl != null ? useSsl.toLowerCase() == 'true' : _useSsl,
    );
  }

  Future<String> presignedPutUrl(String objectKey) async {
    return _client().presignedPutObject(
      _bucket,
      objectKey,
      expires: _signUrlTtlSeconds,
    );
  }

  Future<String> presignedGetUrl(String objectKey) async {
    return _client().presignedGetObject(
      _bucket,
      objectKey,
      expires: _signUrlTtlSeconds,
    );
  }

  Future<void> deleteObject(String objectKey) {
    return _client().removeObject(_bucket, objectKey);
  }

  Future<void> uploadBytes(
    String objectKey,
    Uint8List bytes, {
    String? contentType,
  }) {
    final metadata = <String, String>{};
    if (contentType != null && contentType.trim().isNotEmpty) {
      metadata['Content-Type'] = contentType;
    }
    return _client().putObject(
      _bucket,
      objectKey,
      Stream<Uint8List>.fromIterable([bytes]),
      size: bytes.length,
      metadata: metadata,
    );
  }

  Minio _client() {
    final endpointConfig = _resolveEndpointConfig();
    return Minio(
      endPoint: endpointConfig.host,
      port: endpointConfig.port,
      accessKey: _accessKey,
      secretKey: _signSecret,
      useSSL: endpointConfig.useSsl,
      pathStyle: true,
    );
  }

  _MinioEndpointConfig _resolveEndpointConfig() {
    final publicBaseUrl = _publicBaseUrl;
    if (publicBaseUrl != null && publicBaseUrl.trim().isNotEmpty) {
      final uri = Uri.parse(publicBaseUrl.trim());
      return _MinioEndpointConfig(
        host: uri.host,
        port: uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80),
        useSsl: uri.scheme == 'https',
      );
    }

    final uri = Uri.parse('${_useSsl ? 'https' : 'http'}://$_endpoint');
    return _MinioEndpointConfig(
      host: uri.host,
      port: uri.hasPort ? uri.port : (_useSsl ? 443 : 80),
      useSsl: _useSsl,
    );
  }
}

class _MinioEndpointConfig {
  const _MinioEndpointConfig({
    required this.host,
    required this.port,
    required this.useSsl,
  });

  final String host;
  final int port;
  final bool useSsl;
}
