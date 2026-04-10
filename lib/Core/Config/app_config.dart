import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'Slim30';
  static const String revenueCatPremiumEntitlementId = 'Slim30 Pro';
  static const String revenueCatLegacyEntitlementId = 'Slim30 Premium';
  static const String revenueCatIosApiKey = 'appl_shwHjXNgunbewOKRSjPEjcqyMlk';
  static const String revenueCatAndroidApiKey =
      'goog_uicBfCCbCfKeBTqjLkSrbmiAvTr';
  static const String oneSignalAppId = '4d095e09-849c-4d1d-a06a-144f551dd805';

  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const String _devUserId = String.fromEnvironment(
    'DEV_USER_ID',
    defaultValue: '1',
  );

  static String get apiBaseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      if (kReleaseMode && _configuredBaseUrl.startsWith('http://')) {
        throw StateError('API_BASE_URL must use HTTPS in release builds.');
      }
      return _configuredBaseUrl;
    }

    if (kReleaseMode) {
      throw StateError('API_BASE_URL is required in release builds.');
    }

    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }

    return 'http://localhost:3000/api';
  }

  static Map<String, String> get apiHeaders {
    final headers = <String, String>{'Content-Type': 'application/json'};

    // Dev header auth must never be shipped in release builds.
    if (!kReleaseMode) {
      headers['x-user-id'] = _devUserId;
    }

    return headers;
  }
}
