import 'package:family_helper_client/family_helper_client.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class AppApiClient {
  AppApiClient._(this.client);

  final Client client;

  static Future<AppApiClient> create() async {
    final serverUrl = await getServerUrl();
    final client = Client(serverUrl)
      ..connectivityMonitor = FlutterConnectivityMonitor()
      ..authSessionManager = FlutterAuthSessionManager();

    await client.auth.initialize();
    return AppApiClient._(client);
  }

  Future<T> execute<T>(Future<T> Function(Client client) run) async {
    try {
      return await run(client);
    } catch (_) {
      rethrow;
    }
  }
}
