import 'package:family_helper_flutter/core/network/server_availability_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('successful ping sets server status to available', () async {
    final checkedAt = DateTime.utc(2026, 3, 26, 12);
    final cubit = ServerAvailabilityCubit(
      null,
      pingServer: () async => true,
      now: () => checkedAt,
    );

    await cubit.refresh();

    expect(cubit.state.status, ServerAvailabilityStatus.available);
    expect(cubit.state.lastCheckedAt, checkedAt);
    await cubit.close();
  });

  test('failed ping sets server status to unavailable', () async {
    final checkedAt = DateTime.utc(2026, 3, 26, 12, 5);
    final cubit = ServerAvailabilityCubit(
      null,
      pingServer: () async => throw Exception('network down'),
      now: () => checkedAt,
    );

    await cubit.refresh();

    expect(cubit.state.status, ServerAvailabilityStatus.unavailable);
    expect(cubit.state.lastCheckedAt, checkedAt);
    await cubit.close();
  });

  test('server status recovers after a later successful ping', () async {
    var attempt = 0;
    final timestamps = [
      DateTime.utc(2026, 3, 26, 12, 10),
      DateTime.utc(2026, 3, 26, 12, 11),
    ];
    final cubit = ServerAvailabilityCubit(
      null,
      pingServer: () async {
        attempt += 1;
        if (attempt == 1) {
          throw Exception('timeout');
        }
        return true;
      },
      now: () => timestamps[attempt - 1],
    );

    await cubit.refresh();
    expect(cubit.state.status, ServerAvailabilityStatus.unavailable);

    await cubit.refresh();

    expect(cubit.state.status, ServerAvailabilityStatus.available);
    expect(cubit.state.lastCheckedAt, timestamps.last);
    await cubit.close();
  });

  test('manual refresh updates state without resetting the cubit', () async {
    var isServerAvailable = true;
    final cubit = ServerAvailabilityCubit(
      null,
      pingServer: () async {
        if (!isServerAvailable) {
          throw Exception('server unavailable');
        }
        return true;
      },
    );

    await cubit.refresh();
    expect(cubit.state.status, ServerAvailabilityStatus.available);

    isServerAvailable = false;
    await cubit.refresh();
    expect(cubit.state.status, ServerAvailabilityStatus.unavailable);

    isServerAvailable = true;
    await cubit.refresh();
    expect(cubit.state.status, ServerAvailabilityStatus.available);
    await cubit.close();
  });
}
