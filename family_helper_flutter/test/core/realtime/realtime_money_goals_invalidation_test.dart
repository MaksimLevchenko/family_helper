import 'package:family_helper_client/family_helper_client.dart';
import 'package:family_helper_flutter/core/realtime/realtime_provider.dart';
import 'package:family_helper_flutter/core/realtime/realtime_subscription_manager.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestFamilySelectionCubit extends FamilySelectionCubit {
  _TestFamilySelectionCubit(int? initialFamilyId) : super() {
    emit(initialFamilyId);
  }

  @override
  Future<void> bootstrap() async {}

  @override
  Future<void> setFamilyId(int familyId) async {
    emit(familyId);
  }

  @override
  Future<void> clear() async {
    emit(null);
  }
}

class _FakeRealtimeDriver implements RealtimeSubscriptionDriver {
  Future<void> Function(FamilyRealtimeEvent event)? _onEvent;
  int? subscribedFamilyId;

  @override
  Future<void> subscribeToFamily(
    int familyId, {
    required Future<void> Function(FamilyRealtimeEvent event) onEvent,
  }) async {
    subscribedFamilyId = familyId;
    _onEvent = onEvent;
  }

  Future<void> emit(FamilyRealtimeEvent event) async {
    await _onEvent?.call(event);
  }

  @override
  Future<void> dispose() async {
    _onEvent = null;
  }
}

void main() {
  test(
    'money_goals realtime event triggers sync and invalidation callback',
    () async {
      final familySelectionCubit = _TestFamilySelectionCubit(42);
      final driver = _FakeRealtimeDriver();
      final invalidations = <Set<String>>[];
      final syncs = <int>[];

      final cubit = RealtimeCubit(
        manager: driver,
        familySelectionCubit: familySelectionCubit,
        syncFamily: (familyId) async {
          syncs.add(familyId);
        },
        onInvalidation: (features) async {
          invalidations.add(features);
        },
        debounce: Duration.zero,
      );

      await cubit.start();

      await driver.emit(
        FamilyRealtimeEvent(
          familyId: 42,
          feature: 'money_goals',
          entityType: 'money_goal',
          entityId: 1,
          eventType: 'money_goals.updated',
          changedAt: DateTime.utc(2026, 3, 10, 10, 0),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(syncs, [42]);
      expect(invalidations, hasLength(1));
      expect(invalidations.single, contains('money_goals'));

      await cubit.close();
      await familySelectionCubit.close();
    },
  );
}
