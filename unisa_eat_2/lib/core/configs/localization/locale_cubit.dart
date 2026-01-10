import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisa_eat_2/core/configs/localization/supported_locales.dart';

class LocaleCubit extends Cubit<Locale> {
  static const String _localeKey = 'locale_key';

  LocaleCubit() : super(SupportedLocales.defaultLocale) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey);
    if (localeString != null) {
      emit(SupportedLocales.fromLanguageCode(localeString));
    } else {
      emit(SupportedLocales.defaultLocale);
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    emit(locale);
  }

  Future<void> resetToSystemLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
    emit(SupportedLocales.defaultLocale);
  }
}