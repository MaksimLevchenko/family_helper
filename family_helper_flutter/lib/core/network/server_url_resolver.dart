import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerUrlResolver {
  const ServerUrlResolver._();

  static const _androidEmulatorHost = '10.0.2.2';
  static const _loopbackHosts = {'localhost', '127.0.0.1', '::1'};
  static const _probeTimeout = Duration(milliseconds: 800);
  static final Dio _probeClient = Dio(
    BaseOptions(
      connectTimeout: _probeTimeout,
      receiveTimeout: _probeTimeout,
      sendTimeout: _probeTimeout,
      validateStatus: (_) => true,
      followRedirects: false,
    ),
  );
  static String? _resolvedAndroidLoopbackHost;

  static Future<String> resolve() async {
    final serverUrl = await getServerUrl();
    return resolveValue(
      serverUrl,
      platform: defaultTargetPlatform,
    );
  }

  @visibleForTesting
  static Future<String> resolveValue(
    String serverUrl, {
    required TargetPlatform platform,
    bool isDebug = kDebugMode,
    bool isWeb = kIsWeb,
    Future<bool> Function(Uri uri)? probeReachable,
  }) async {
    if (!isDebug || isWeb || platform != TargetPlatform.android) {
      return serverUrl;
    }

    final uri = Uri.tryParse(serverUrl);
    if (uri == null || !_loopbackHosts.contains(uri.host.toLowerCase())) {
      return serverUrl;
    }

    final preferredHost = await _resolveAndroidLoopbackHost(
      uri,
      probeReachable: probeReachable,
    );
    return uri.replace(host: preferredHost).toString();
  }

  static String normalize(
    String serverUrl, {
    required TargetPlatform platform,
    bool isDebug = kDebugMode,
    bool isWeb = kIsWeb,
  }) {
    if (!isDebug || isWeb || platform != TargetPlatform.android) {
      return serverUrl;
    }

    final uri = Uri.tryParse(serverUrl);
    if (uri == null || !_loopbackHosts.contains(uri.host.toLowerCase())) {
      return serverUrl;
    }

    final preferredHost = _resolvedAndroidLoopbackHost ?? _androidEmulatorHost;
    return uri.replace(host: preferredHost).toString();
  }

  static String normalizeAgainstBase(
    String serverUrl, {
    required String baseUrl,
    required TargetPlatform platform,
    bool isDebug = kDebugMode,
    bool isWeb = kIsWeb,
  }) {
    final normalizedUrl = normalize(
      serverUrl,
      platform: platform,
      isDebug: isDebug,
      isWeb: isWeb,
    );
    if (!isDebug) {
      return normalizedUrl;
    }

    final targetUri = Uri.tryParse(normalizedUrl);
    final baseUri = Uri.tryParse(baseUrl);
    if (targetUri == null || baseUri == null) {
      return normalizedUrl;
    }

    if (!_loopbackHosts.contains(targetUri.host.toLowerCase())) {
      return normalizedUrl;
    }

    if (baseUri.host.isEmpty ||
        _loopbackHosts.contains(baseUri.host.toLowerCase())) {
      return normalizedUrl;
    }

    return targetUri.replace(host: baseUri.host).toString();
  }

  @visibleForTesting
  static void resetCachedAndroidLoopbackHost() {
    _resolvedAndroidLoopbackHost = null;
  }

  static Future<String> _resolveAndroidLoopbackHost(
    Uri uri, {
    Future<bool> Function(Uri uri)? probeReachable,
  }) async {
    final cachedHost = _resolvedAndroidLoopbackHost;
    if (cachedHost != null) {
      return cachedHost;
    }

    final isReachable = await (probeReachable ?? _probeReachable)(uri);
    final resolvedHost = isReachable ? uri.host : _androidEmulatorHost;
    _resolvedAndroidLoopbackHost = resolvedHost;
    return resolvedHost;
  }

  static Future<bool> _probeReachable(Uri uri) async {
    try {
      final response = await _probeClient.getUri(_probeUri(uri));
      return response.statusCode != null;
    } catch (_) {
      return false;
    }
  }

  static Uri _probeUri(Uri uri) {
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: '/',
    );
  }
}
