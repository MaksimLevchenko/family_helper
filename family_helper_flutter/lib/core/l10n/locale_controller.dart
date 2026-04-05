import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../logging/app_error_logger.dart';

const _localeModeStorageKey = 'locale_mode';
const _localeCodeStorageKey = 'locale_code';

enum AppLocaleMode { system, manual }

class LocalePreference {
  const LocalePreference({
    required this.mode,
    required this.manualLocaleCode,
  });

  final AppLocaleMode mode;
  final String manualLocaleCode;
}

abstract class LocaleStore {
  Future<LocalePreference?> read();

  Future<void> write(LocalePreference preference);
}

class SecureLocaleStore implements LocaleStore {
  SecureLocaleStore({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  final FlutterSecureStorage _storage;

  @override
  Future<LocalePreference?> read() async {
    final modeValue = await _storage.read(key: _localeModeStorageKey);
    final localeCode = await _storage.read(key: _localeCodeStorageKey);
    if (modeValue == null && localeCode == null) {
      return null;
    }

    return LocalePreference(
      mode: switch (modeValue) {
        'manual' => AppLocaleMode.manual,
        _ => AppLocaleMode.system,
      },
      manualLocaleCode: normalizeSupportedLocaleCode(localeCode),
    );
  }

  @override
  Future<void> write(LocalePreference preference) async {
    await _storage.write(
      key: _localeModeStorageKey,
      value: preference.mode == AppLocaleMode.manual ? 'manual' : 'system',
    );
    await _storage.write(
      key: _localeCodeStorageKey,
      value: normalizeSupportedLocaleCode(preference.manualLocaleCode),
    );
  }
}

class AppLocaleState {
  const AppLocaleState({
    required this.mode,
    required this.manualLocale,
    required this.systemLocale,
  });

  final AppLocaleMode mode;
  final Locale manualLocale;
  final Locale systemLocale;

  Locale get effectiveLocale =>
      mode == AppLocaleMode.manual ? manualLocale : systemLocale;

  String get effectiveLocaleCode => effectiveLocale.languageCode;

  AppLocaleState copyWith({
    AppLocaleMode? mode,
    Locale? manualLocale,
    Locale? systemLocale,
  }) {
    return AppLocaleState(
      mode: mode ?? this.mode,
      manualLocale: manualLocale ?? this.manualLocale,
      systemLocale: systemLocale ?? this.systemLocale,
    );
  }

  factory AppLocaleState.initial() {
    const fallbackLocale = Locale('en');
    return const AppLocaleState(
      mode: AppLocaleMode.system,
      manualLocale: fallbackLocale,
      systemLocale: fallbackLocale,
    );
  }
}

class LocaleCubit extends Cubit<AppLocaleState> {
  LocaleCubit({
    LocaleStore? store,
  }) : _store = store ?? SecureLocaleStore(),
       super(AppLocaleState.initial());

  final LocaleStore _store;
  bool _bootstrapped = false;

  Future<void> bootstrap() async {
    if (_bootstrapped) {
      return;
    }
    _bootstrapped = true;

    try {
      final stored = await _store.read();
      if (stored == null) {
        return;
      }

      emit(
        state.copyWith(
          mode: stored.mode,
          manualLocale: resolveSupportedLocaleFromCode(stored.manualLocaleCode),
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'locale.bootstrap',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setSystemMode() async {
    final nextState = state.copyWith(mode: AppLocaleMode.system);
    emit(nextState);
    await _persist(nextState);
  }

  Future<void> setManualLocale(Locale locale) async {
    final nextState = state.copyWith(
      mode: AppLocaleMode.manual,
      manualLocale: resolveSupportedLocale(locale),
    );
    emit(nextState);
    await _persist(nextState);
  }

  Future<void> updateSystemLocales(List<Locale> locales) async {
    final locale = locales.isEmpty
        ? const Locale('en')
        : resolveSupportedLocale(locales.first);
    if (locale == state.systemLocale) {
      return;
    }
    emit(state.copyWith(systemLocale: locale));
  }

  Future<void> _persist(AppLocaleState nextState) async {
    try {
      await _store.write(
        LocalePreference(
          mode: nextState.mode,
          manualLocaleCode: nextState.manualLocale.languageCode,
        ),
      );
    } catch (error, stackTrace) {
      AppErrorLogger.logHandled(
        scope: 'locale.persist',
        error: error,
        stackTrace: stackTrace,
        context: {
          'mode': nextState.mode.name,
          'manualLocale': nextState.manualLocale.languageCode,
        },
      );
    }
  }
}

Locale resolveSupportedLocale(Locale locale) {
  return resolveSupportedLocaleFromCode(locale.languageCode);
}

Locale resolveSupportedLocaleFromCode(String? code) {
  return Locale(normalizeSupportedLocaleCode(code));
}

String normalizeSupportedLocaleCode(String? code) {
  final normalized = (code ?? '').toLowerCase();
  if (normalized.startsWith('ru')) {
    return 'ru';
  }
  return 'en';
}
