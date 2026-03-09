import 'package:family_helper_client/family_helper_client.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:family_helper_flutter/core/realtime/realtime_provider.dart';
import 'package:family_helper_flutter/core/realtime/realtime_subscription_manager.dart';
import 'package:family_helper_flutter/features/family_invites/providers/family_provider.dart';

class _FakeRealtimeDriver implements RealtimeSubscriptionDriver {
  Future<void> Function(FamilyRealtimeEvent event)? _onEvent;

  @override
  Future<void> dispose() async {
    _onEvent = null;
  }

  Future<void> emitEvent(FamilyRealtimeEvent event) async {
    await _onEvent?.call(event);
  }

  @override
  Future<void> subscribeToFamily(
    int familyId, {
    required Future<void> Function(FamilyRealtimeEvent event) onEvent,
  }) async {
    _onEvent = onEvent;
  }
}

class _TestFamilySelectionCubit extends FamilySelectionCubit {
  void emitFamily(int? familyId) {
    emit(familyId);
  }
}

void main() {
  test(
    'RealtimeCubit coalesces burst events into a single sync/invalidation',
    () async {
      final driver = _FakeRealtimeDriver();
      final familySelectionCubit = _TestFamilySelectionCubit();
      final syncCalls = <int>[];
      final invalidations = <Set<String>>[];

      final cubit = RealtimeCubit(
        manager: driver,
        familySelectionCubit: familySelectionCubit,
        syncFamily: (familyId) async {
          syncCalls.add(familyId);
        },
        onInvalidation: (features) async {
          invalidations.add(features);
        },
        debounce: const Duration(milliseconds: 5),
      );

      await cubit.start();
      familySelectionCubit.emitFamily(42);
      await Future<void>.delayed(const Duration(milliseconds: 1));

      final now = DateTime.utc(2026, 3, 9);
      await driver.emitEvent(
        FamilyRealtimeEvent(
          familyId: 42,
          feature: 'tasks',
          entityType: 'task',
          entityId: 1,
          eventType: 'updated',
          changedAt: now,
        ),
      );
      await driver.emitEvent(
        FamilyRealtimeEvent(
          familyId: 42,
          feature: 'tasks',
          entityType: 'task',
          entityId: 2,
          eventType: 'updated',
          changedAt: now,
        ),
      );
      await driver.emitEvent(
        FamilyRealtimeEvent(
          familyId: 42,
          feature: 'calendar',
          entityType: 'event',
          entityId: 3,
          eventType: 'updated',
          changedAt: now,
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(syncCalls, [42]);
      expect(invalidations, hasLength(1));
      expect(invalidations.single, {'tasks', 'calendar'});

      await cubit.close();
      await familySelectionCubit.close();
    },
  );
}
