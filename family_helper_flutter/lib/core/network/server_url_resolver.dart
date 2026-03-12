import 'package:flutter/foundation.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerUrlResolver {
  const ServerUrlResolver._();

  static const _androidEmulatorHost = '10.0.2.2';
  static const _loopbackHosts = {'localhost', '127.0.0.1'};

  static Future<String> resolve() async {
    final serverUrl = await getServerUrl();
    return normalize(
      serverUrl,
      platform: defaultTargetPlatform,
    );
  }

  @visibleForTesting
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

    return uri.replace(host: _androidEmulatorHost).toString();
  }
}
