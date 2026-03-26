import 'package:family_helper_flutter/core/network/server_availability_cubit.dart';
import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/features/auth_profile/presentation/sign_in_screen.dart';
import 'package:family_helper_flutter/ui_kit/server_status_app_bar.dart';
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
  testWidgets('shows banner in a regular app bar when server is unavailable', (
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
          home: Builder(
            builder: (context) {
              return Scaffold(
                appBar: serverStatusAppBar(
                  context,
                  title: const Text('Overview'),
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Overview'), findsOneWidget);
    expect(
      find.text(
        'Server unavailable. Some actions may not work until connection is restored.',
      ),
      findsOneWidget,
    );
    await cubit.close();
  });

  testWidgets('shows banner on sign in screen without a visible toolbar', (
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
          home: const SignInScreen(),
        ),
      ),
    );

    expect(find.text('Family Helper'), findsOneWidget);
    expect(
      find.text(
        'Server unavailable. Some actions may not work until connection is restored.',
      ),
      findsOneWidget,
    );
    await cubit.close();
  });

  testWidgets('hides banner when server is available', (tester) async {
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
          home: Builder(
            builder: (context) {
              return Scaffold(
                appBar: serverStatusAppBar(context, title: const Text('Lists')),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Lists'), findsOneWidget);
    expect(
      find.text(
        'Server unavailable. Some actions may not work until connection is restored.',
      ),
      findsNothing,
    );
    await cubit.close();
  });
}
