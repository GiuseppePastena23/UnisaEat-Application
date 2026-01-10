import 'dart:ui';

class SupportedLocales {
  static const Locale italian = Locale('it');
  static const Locale english = Locale('en');
  static const Locale spanish = Locale('es');

  static const List<Locale> all = [
    italian,
    english,
    spanish,
  ];

  static const Locale defaultLocale = italian;

  static String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'it':
        return 'Italiano';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return locale.languageCode;
    }
  }

  static Locale fromLanguageCode(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'it':
        return italian;
      case 'en':
        return english;
      case 'es':
        return spanish;
      default:
        return defaultLocale;
    }
  }
}