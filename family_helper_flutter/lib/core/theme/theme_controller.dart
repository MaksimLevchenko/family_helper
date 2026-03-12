import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../logging/app_error_logger.dart';

const _themeModeStorageKey = 'theme_mode';

abstract class ThemeModeStore {
  Future<ThemeMode?> read();

  Future<void> write(ThemeMode mode);
}

class SecureThemeModeStore implements ThemeModeStore {
  SecureThemeModeStore({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  final FlutterSecureStorage _storage;

  @override
  Future<ThemeMode?> read() async {
    final value = await _storage.read(key: _themeModeStorageKey);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => null,
    };
  }

  @override
  Future<void> write(ThemeMode mode) {
    return _storage.write(key: _themeModeStorageKey, value: mode.name);
  }
}

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({
    ThemeModeStore? store,
  }) : _store = store ?? SecureThemeModeStore(),
       super(ThemeMode.system);

  final ThemeModeStore _store;
  bool _bootstrapped = false;

  Future<void> bootstrap() async {
    if (_bootstrapped) {
      return;
    }
    _bootstrapped = true;

    try {
      final storedMode = await _store.read();
      if (storedMode != null && storedMode != state) {
        emit(storedMode);
      }
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'theme.bootstrap',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    try {
      await _store.write(mode);
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'theme.setThemeMode',
        error: error,
        stackTrace: stackTrace,
        context: {'themeMode': mode.name},
      );
    }
  }
}
