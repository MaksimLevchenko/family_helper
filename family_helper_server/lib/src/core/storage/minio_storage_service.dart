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
  static const _passwordKeyForceRealInTest = 'minioForceRealInTest';

  MinioStorageService({
    String? endpoint,
    String? bucket,
    String? accessKey,
    String? signSecret,
    String? publicBaseUrl,
    int? signUrlTtlSeconds,
    bool? useSsl,
    bool? useMockStorage,
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
               'true'),
       _useMockStorage = useMockStorage ?? false;

  final String _endpoint;
  final String _bucket;
  final String _accessKey;
  final String _signSecret;
  final String? _publicBaseUrl;
  final int _signUrlTtlSeconds;
  final bool _useSsl;
  final bool _useMockStorage;

  String get bucket => _bucket;

  MinioStorageService forSession(Session session) {
    final passwords = session.passwords;
    final useSsl = passwords[_passwordKeyUseSsl];
    final ttlRaw = passwords[_passwordKeySignUrlTtl];
    final forceRealInTest =
        _isTruthy(
          Platform.environment['MINIO_FORCE_REAL_IN_TEST'],
        ) ||
        _isTruthy(passwords[_passwordKeyForceRealInTest]);
    final useMockStorage =
        session.server.serverpod.runMode == ServerpodRunMode.test &&
        !forceRealInTest;
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
      useMockStorage: useMockStorage,
    );
  }

  Future<String> presignedPutUrl(String objectKey) async {
    if (_useMockStorage) {
      return _mockPresignedUrl(objectKey, method: 'PUT');
    }
    return _client().presignedPutObject(
      _bucket,
      objectKey,
      expires: _signUrlTtlSeconds,
    );
  }

  Future<String> presignedGetUrl(String objectKey) async {
    if (_useMockStorage) {
      return _mockPresignedUrl(objectKey, method: 'GET');
    }
    return _client().presignedGetObject(
      _bucket,
      objectKey,
      expires: _signUrlTtlSeconds,
    );
  }

  Future<void> deleteObject(String objectKey) {
    if (_useMockStorage) {
      return Future<void>.value();
    }
    return _client().removeObject(_bucket, objectKey);
  }

  Future<void> uploadBytes(
    String objectKey,
    Uint8List bytes, {
    String? contentType,
  }) {
    if (_useMockStorage) {
      return Future<void>.value();
    }
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

  String _mockPresignedUrl(String objectKey, {required String method}) {
    final endpointConfig = _resolveEndpointConfig();
    final nowUtc = DateTime.now().toUtc();
    final dateStamp = _formatDate(nowUtc);
    final amzDate = '${dateStamp}T${_formatTime(nowUtc)}Z';
    final signature = _mockSignature(
      '$method|$_bucket|$objectKey|$_accessKey|$_signSecret|$amzDate',
    );

    return Uri(
      scheme: endpointConfig.useSsl ? 'https' : 'http',
      host: endpointConfig.host,
      port: endpointConfig.port,
      pathSegments: [
        _bucket,
        ...objectKey.split('/').where((segment) => segment.isNotEmpty),
      ],
      queryParameters: {
        'x-amz-algorithm': 'AWS4-HMAC-SHA256',
        'x-amz-credential': '$_accessKey/$dateStamp/us-east-1/s3/aws4_request',
        'x-amz-date': amzDate,
        'x-amz-expires': '$_signUrlTtlSeconds',
        'x-amz-signedheaders': 'host',
        'x-amz-signature': signature,
      },
    ).toString();
  }

  String _mockSignature(String input) {
    var state = 0x811C9DC5;
    for (final unit in input.codeUnits) {
      state ^= unit;
      state = (state * 0x01000193) & 0xFFFFFFFF;
    }

    final buffer = StringBuffer();
    var value = state;
    for (var i = 0; i < 8; i++) {
      value = ((value * 1103515245) + 12345) & 0xFFFFFFFF;
      buffer.write(value.toRadixString(16).padLeft(8, '0'));
    }
    return buffer.toString();
  }

  String _formatDate(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}'
        '${value.month.toString().padLeft(2, '0')}'
        '${value.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}'
        '${value.minute.toString().padLeft(2, '0')}'
        '${value.second.toString().padLeft(2, '0')}';
  }

  bool _isTruthy(String? value) {
    if (value == null) return false;
    return value.trim().toLowerCase() == 'true';
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
