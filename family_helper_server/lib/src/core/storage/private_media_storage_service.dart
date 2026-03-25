import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

class SignedDownloadPayload {
  const SignedDownloadPayload({
    required this.storageId,
    required this.path,
    required this.mimeType,
    required this.expiresAt,
  });

  final String storageId;
  final String path;
  final String mimeType;
  final DateTime expiresAt;
}

enum SignedDownloadValidationError {
  invalid,
  expired,
}

class SignedDownloadValidationResult {
  const SignedDownloadValidationResult._({
    this.payload,
    this.error,
  });

  const SignedDownloadValidationResult.valid(SignedDownloadPayload payload)
    : this._(payload: payload);

  const SignedDownloadValidationResult.invalid(
    SignedDownloadValidationError error,
  ) : this._(error: error);

  final SignedDownloadPayload? payload;
  final SignedDownloadValidationError? error;

  bool get isValid => payload != null;
}

class PrivateMediaStorageService {
  static const storageId = 'private';
  static const privateMediaRoutePath = '/private-media';

  static const _passwordKeyUrlSignSecret = 'mediaUrlSignSecret';
  static const _passwordKeyLegacyServiceSecret = 'serviceSecret';

  PrivateMediaStorageService({
    String? urlSignSecret,
    int? signUrlTtlSeconds,
  }) : _urlSignSecret = urlSignSecret,
       _signUrlTtlSeconds = signUrlTtlSeconds ?? _defaultTtlSeconds;

  static const _defaultTtlSeconds = 900;

  final String? _urlSignSecret;
  final int _signUrlTtlSeconds;

  PrivateMediaStorageService forSession(Session session) {
    final passwords = session.passwords;
    final signSecret =
        passwords[_passwordKeyUrlSignSecret] ??
        Platform.environment['MEDIA_URL_SIGN_SECRET'] ??
        passwords[_passwordKeyLegacyServiceSecret] ??
        _urlSignSecret ??
        'replace-me';
    final ttlSeconds =
        int.tryParse(Platform.environment['SIGN_URL_TTL'] ?? '') ??
        _signUrlTtlSeconds;

    return PrivateMediaStorageService(
      urlSignSecret: signSecret,
      signUrlTtlSeconds: ttlSeconds,
    );
  }

  Future<String> createDirectUploadUrl(
    Session session, {
    required String path,
  }) async {
    await _deletePendingUploadDescription(session, path: path);

    final uploadDescription = await session.storage
        .createDirectFileUploadDescription(
          storageId: storageId,
          path: path,
        );
    if (uploadDescription == null) {
      throw StateError('Upload URL could not be created.');
    }

    final uploadUrl = _extractUploadUrl(uploadDescription);
    final uploadUri = Uri.parse(uploadUrl);
    return _rewriteApiUri(session, uploadUri).toString();
  }

  Future<bool> verifyUpload(
    Session session, {
    required String path,
  }) {
    return session.storage.verifyDirectFileUpload(
      storageId: storageId,
      path: path,
    );
  }

  Future<void> deleteObject(
    Session session, {
    required String path,
  }) {
    return session.storage.deleteFile(storageId: storageId, path: path);
  }

  Future<void> storeBytes(
    Session session, {
    required String path,
    required Uint8List bytes,
  }) {
    return session.storage.storeFile(
      storageId: storageId,
      path: path,
      byteData: ByteData.sublistView(bytes),
    );
  }

  Future<ByteData?> retrieveBytes(
    Session session, {
    required String path,
  }) {
    return session.storage.retrieveFile(storageId: storageId, path: path);
  }

  String createSignedDownloadUrl(
    Session session, {
    required String path,
    required String mimeType,
    DateTime? expiresAt,
  }) {
    final expiration =
        expiresAt?.toUtc() ??
        DateTime.now().toUtc().add(Duration(seconds: _signUrlTtlSeconds));
    final expiresAtMillis = expiration.millisecondsSinceEpoch.toString();

    final queryParameters = <String, String>{
      'storageId': storageId,
      'path': path,
      'mimeType': mimeType,
      'expiresAt': expiresAtMillis,
    };
    queryParameters['signature'] = _signQueryParameters(queryParameters);

    return _downloadBaseUri(
          session,
        )
        .replace(path: privateMediaRoutePath, queryParameters: queryParameters)
        .toString();
  }

  SignedDownloadValidationResult validateSignedDownloadUri(Uri uri) {
    final params = uri.queryParameters;
    final requestedStorageId = params['storageId'];
    final path = params['path'];
    final mimeType = params['mimeType'];
    final expiresAtRaw = params['expiresAt'];
    final signature = params['signature'];

    if (requestedStorageId == null ||
        path == null ||
        mimeType == null ||
        expiresAtRaw == null ||
        signature == null ||
        requestedStorageId != storageId) {
      return const SignedDownloadValidationResult.invalid(
        SignedDownloadValidationError.invalid,
      );
    }

    final expiresAtMillis = int.tryParse(expiresAtRaw);
    if (expiresAtMillis == null) {
      return const SignedDownloadValidationResult.invalid(
        SignedDownloadValidationError.invalid,
      );
    }

    final unsignedParams = <String, String>{
      'storageId': requestedStorageId,
      'path': path,
      'mimeType': mimeType,
      'expiresAt': expiresAtRaw,
    };
    final expectedSignature = _signQueryParameters(unsignedParams);
    if (!_constantTimeEquals(signature, expectedSignature)) {
      return const SignedDownloadValidationResult.invalid(
        SignedDownloadValidationError.invalid,
      );
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      expiresAtMillis,
      isUtc: true,
    );
    if (expiresAt.isBefore(DateTime.now().toUtc())) {
      return const SignedDownloadValidationResult.invalid(
        SignedDownloadValidationError.expired,
      );
    }

    return SignedDownloadValidationResult.valid(
      SignedDownloadPayload(
        storageId: requestedStorageId,
        path: path,
        mimeType: mimeType,
        expiresAt: expiresAt,
      ),
    );
  }

  Future<void> _deletePendingUploadDescription(
    Session session, {
    required String path,
  }) {
    return session.db.unsafeQuery(
      'DELETE FROM serverpod_cloud_storage_direct_upload '
      'WHERE "storageId"=${EscapedExpression(storageId)} '
      'AND path=${EscapedExpression(path)}',
    );
  }

  String _extractUploadUrl(String uploadDescription) {
    final decoded = jsonDecode(uploadDescription);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Upload description is malformed.');
    }

    final uploadUrl = decoded['url'];
    if (uploadUrl is! String || uploadUrl.trim().isEmpty) {
      throw const FormatException('Upload description is missing URL.');
    }
    return uploadUrl;
  }

  Uri _rewriteApiUri(Session session, Uri originalUri) {
    final config = session.server.serverpod.config.apiServer;
    final requestUri = session.request?.url;
    final useRequestOrigin = _shouldUseRequestOrigin(
      configuredHost: config.publicHost,
      requestUri: requestUri,
    );

    final host = useRequestOrigin ? requestUri!.host : originalUri.host;
    final scheme = useRequestOrigin ? requestUri!.scheme : originalUri.scheme;
    final port = config.publicPort == 0
        ? session.server.port
        : (useRequestOrigin ? requestUri!.port : originalUri.port);

    return originalUri.replace(
      scheme: scheme,
      host: host,
      port: port,
    );
  }

  Uri _downloadBaseUri(Session session) {
    final config = session.server.serverpod.config.webServer!;
    final requestUri = session.request?.url;
    final useRequestOrigin = _shouldUseRequestOrigin(
      configuredHost: config.publicHost,
      requestUri: requestUri,
    );

    final host = useRequestOrigin ? requestUri!.host : config.publicHost;
    final scheme = useRequestOrigin ? requestUri!.scheme : config.publicScheme;
    final port = config.publicPort == 0
        ? (session.server.serverpod.webServer.port ?? session.server.port)
        : config.publicPort;

    return Uri(
      scheme: scheme,
      host: host,
      port: port,
    );
  }

  bool _shouldUseRequestOrigin({
    required String configuredHost,
    required Uri? requestUri,
  }) {
    if (requestUri == null) return false;
    final normalizedHost = configuredHost.trim().toLowerCase();
    return normalizedHost == 'localhost' ||
        normalizedHost == '127.0.0.1' ||
        normalizedHost == '::1';
  }

  String _signQueryParameters(Map<String, String> parameters) {
    final secret = _urlSignSecret ?? 'replace-me';
    final canonicalPayload = [
      parameters['storageId'] ?? '',
      parameters['path'] ?? '',
      parameters['mimeType'] ?? '',
      parameters['expiresAt'] ?? '',
    ].join('\n');

    final digest = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(canonicalPayload));
    return digest.bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  bool _constantTimeEquals(String left, String right) {
    if (left.length != right.length) return false;

    var result = 0;
    for (var index = 0; index < left.length; index++) {
      result |= left.codeUnitAt(index) ^ right.codeUnitAt(index);
    }
    return result == 0;
  }
}
