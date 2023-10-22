import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension TranslationExtension on BuildContext {
  AppLocalizations get translations => AppLocalizations.of(this);
}

extension LocaleExtension on Locale {
  String get languageName {
    switch (languageCode) {
      case 'en':
        return 'English';

      case 'de':
        return 'Deutsch';
    }
    return languageCode;
  }
}
