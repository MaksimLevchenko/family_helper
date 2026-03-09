import 'dart:async';

import 'package:family_helper_client/family_helper_client.dart';

import '../network/app_api_client.dart';

abstract class RealtimeSubscriptionDriver {
  Future<void> subscribeToFamily(
    int familyId, {
    required Future<void> Function(FamilyRealtimeEvent event) onEvent,
  });

  Future<void> dispose();
}

class RealtimeSubscriptionManager implements RealtimeSubscriptionDriver {
  RealtimeSubscriptionManager(this._apiClient);

  final AppApiClient _apiClient;
  StreamSubscription<FamilyRealtimeEvent>? _subscription;

  @override
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

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
