import 'package:family_helper_flutter/core/network/server_availability_cubit.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/ui_kit/cached_data_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestServerAvailabilityCubit extends ServerAvailabilityCubit {
  _TestServerAvailabilityCubit(ServerAvailabilityState initialState)
    : super(null, pingServer: () async => true) {
    emit(initialState);
  }
}

void main() {
  testWidgets('shows last updated label only for offline cached data', (
    tester,
  ) async {
    final cubit = _TestServerAvailabilityCubit(
      const ServerAvailabilityState(
        status: ServerAvailabilityStatus.unavailable,
      ),
    );

    await tester.pumpWidget(
      BlocProvider<ServerAvailabilityCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: CachedDataStatus(
              isUsingCachedData: true,
              lastSuccessfulSyncAt: DateTime.utc(2026, 3, 26, 14, 45),
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('Last updated:'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('hides the label when server is available', (tester) async {
    final cubit = _TestServerAvailabilityCubit(
      const ServerAvailabilityState(
        status: ServerAvailabilityStatus.available,
      ),
    );

    await tester.pumpWidget(
      BlocProvider<ServerAvailabilityCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: CachedDataStatus(
              isUsingCachedData: true,
              lastSuccessfulSyncAt: DateTime.utc(2026, 3, 26, 14, 45),
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('Last updated:'), findsNothing);
    await cubit.close();
  });
}
