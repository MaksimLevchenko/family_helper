import 'package:flutter/material.dart';

import '../l10n/locale_controller.dart';
import '../../l10n/app_localizations.dart';

extension AppL10nBuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

AppLocalizations l10nForLocale(Locale locale) {
  return lookupAppLocalizations(resolveSupportedLocale(locale));
}

AppLocalizations l10nForLocaleCode(String? localeCode) {
  return lookupAppLocalizations(resolveSupportedLocaleFromCode(localeCode));
}
