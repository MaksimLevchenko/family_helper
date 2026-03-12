import 'package:family_helper_flutter/core/theme/app_theme.dart';
import 'package:family_helper_flutter/core/theme/theme_controller.dart';
import 'package:family_helper_flutter/features/home_overview/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryThemeModeStore implements ThemeModeStore {
  _MemoryThemeModeStore([this.value]);

  ThemeMode? value;

  @override
  Future<ThemeMode?> read() async => value;

  @override
  Future<void> write(ThemeMode mode) async {
    value = mode;
  }
}

void main() {
  test('ThemeCubit restores saved theme mode and persists updates', () async {
    final store = _MemoryThemeModeStore(ThemeMode.dark);
    final cubit = ThemeCubit(store: store);

    await cubit.bootstrap();
    expect(cubit.state, ThemeMode.dark);

    await cubit.setThemeMode(ThemeMode.light);
    expect(cubit.state, ThemeMode.light);
    expect(store.value, ThemeMode.light);

    await cubit.close();
  });

  testWidgets(
    'SettingsScreen shows appearance selector with system, light, and dark modes',
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      final cubit = ThemeCubit(store: _MemoryThemeModeStore());

      await tester.pumpWidget(
        BlocProvider<ThemeCubit>.value(
          value: cubit,
          child: MaterialApp(
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.system,
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Current mode: System'), findsOneWidget);
      expect(find.text('System'), findsWidgets);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('Media & Avatars'), findsNothing);

      await cubit.close();
    },
  );
}
