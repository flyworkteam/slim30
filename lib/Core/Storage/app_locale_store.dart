import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleStore {
  AppLocaleStore._();

  static const String prefKey = 'app_locale';
  static String? _cachedLanguageCode;

  static Future<String> getLanguageCode() async {
    if (_cachedLanguageCode != null && _cachedLanguageCode!.isNotEmpty) {
      return _cachedLanguageCode!;
    }

    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(prefKey)?.trim();
    _cachedLanguageCode = (code != null && code.isNotEmpty) ? code : 'en';
    return _cachedLanguageCode!;
  }

  static Future<void> setLanguageCode(String languageCode) async {
    final normalized = languageCode.trim().toLowerCase();
    _cachedLanguageCode = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefKey, normalized);
  }
}
