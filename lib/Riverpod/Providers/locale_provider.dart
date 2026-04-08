import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slim30/Core/Storage/app_locale_store.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final code = await AppLocaleStore.getLanguageCode();
    if (code.isNotEmpty) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await AppLocaleStore.setLanguageCode(languageCode);
  }
}
