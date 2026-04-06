import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenStore {
  AuthTokenStore._();

  static const String _tokenKey = 'backend_jwt_token';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static String? _cachedToken;

  static Future<void> init() async {
    _cachedToken = await _storage.read(key: _tokenKey);
  }

  static Future<String?> getToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }

    _cachedToken = await _storage.read(key: _tokenKey);
    return _cachedToken;
  }

  static Future<void> setToken(String token) async {
    final normalized = token.trim();
    _cachedToken = normalized;
    await _storage.write(key: _tokenKey, value: normalized);
  }

  static Future<void> clear() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }
}
