import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';

import '../network/app_api_client.dart';

class RealtimeSubscriptionManager {
  RealtimeSubscriptionManager(this._apiClient);

  final AppApiClient _apiClient;
  StreamSubscription<FamilyRealtimeEvent>? _subscription;

  Future<void> subscribeToFamily(
    int familyId, {
    required Future<void> Function(FamilyRealtimeEvent event) onEvent,
  }) async {
    await _subscription?.cancel();
    _subscription = _apiClient.client.realtime
        .watchFamilyEvents(familyId: familyId)
        .listen((event) async {
          await onEvent(event);
        });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
