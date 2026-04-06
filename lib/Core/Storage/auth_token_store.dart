import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenStore {
  AuthTokenStore._();

  static const String _tokenKey = 'backend_jwt_token';
  static String? _cachedToken;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
  }

  static Future<String?> getToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }

  static Future<void> setToken(String token) async {
    final normalized = token.trim();
    _cachedToken = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, normalized);
  }

  static Future<void> clear() async {
    _cachedToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
