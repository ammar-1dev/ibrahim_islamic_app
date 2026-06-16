import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app_locale';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar'));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey) ?? 'ar';
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

bool isRTL(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return true;
    default:
      return false;
  }
}
