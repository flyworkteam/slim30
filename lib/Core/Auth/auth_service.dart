import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:slim30/Core/Config/app_config.dart';
import 'package:slim30/Core/Network/api_client.dart';
import 'package:slim30/Core/Network/api_exception.dart';
import 'package:slim30/Core/Storage/app_locale_store.dart';
import 'package:slim30/Core/Storage/auth_token_store.dart';
import 'package:slim30/Riverpod/Models/app_models.dart';

class AuthService {
  AuthService._();

  static UserProfileModel? _pendingProfile;

  static UserProfileModel? consumePendingProfile() {
    final profile = _pendingProfile;
    _pendingProfile = null;
    return profile;
  }

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final ApiClient _apiClient = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    defaultHeaders: AppConfig.apiHeaders,
    localeCodeProvider: AppLocaleStore.getLanguageCode,
  );
  static final ApiClient _authenticatedApiClient = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    defaultHeaders: AppConfig.apiHeaders,
    authTokenProvider: AuthTokenStore.getToken,
    localeCodeProvider: AppLocaleStore.getLanguageCode,
    onUnauthorized: AuthTokenStore.clear,
  );

  static Future<void> signInWithGoogleAndExchange() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthFlowException('Google sign-in cancelled.');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw const AuthFlowException('Google sign-in did not return a user.');
    }

    // Prefer the Google display name; fall back to email prefix so the DB
    // never keeps a stale "Guest" or "User" placeholder from a prior session.
    final nameHint = (googleUser.displayName?.trim().isNotEmpty == true)
        ? googleUser.displayName
        : googleUser.email.split('@').first;

    try {
      await _exchangeFirebaseToken(
        user,
        displayNameHint: nameHint,
        emailHint: googleUser.email,
        photoUrlHint: googleUser.photoUrl,
      );
    } catch (_) {
      await AuthTokenStore.clear();
      rethrow;
    }
  }

  static Future<OnboardingStatus> getOnboardingStatus() async {
    try {
      final data = await _authenticatedApiClient.get('/users/profile');
      final user = data['user'];
      if (user is! Map<String, dynamic>) {
        return OnboardingStatus.incomplete;
      }

      // Cache the profile so userProfileProvider can use it without a second API call.
      _pendingProfile = UserProfileModel.fromJson(user);

      final age = (user['age'] as num?)?.toInt();
      final gender = (user['gender'] as String?)?.trim();
      final heightCm = (user['height_cm'] as num?)?.toDouble();
      final weightKg = (user['weight_kg'] as num?)?.toDouble();
      final targetWeightKg = (user['target_weight_kg'] as num?)?.toDouble();

      final validGender =
          gender == 'female' || gender == 'male' || gender == 'unspecified';
      final validAge = age != null && age >= 12 && age <= 100;
      final validHeight =
          heightCm != null && heightCm >= 100 && heightCm <= 250;
      final validWeight = weightKg != null && weightKg >= 20 && weightKg <= 350;
      final validTargetWeight =
          targetWeightKg != null &&
          targetWeightKg >= 20 &&
          targetWeightKg <= 350;

      return validGender &&
              validAge &&
              validHeight &&
              validWeight &&
              validTargetWeight
          ? OnboardingStatus.completed
          : OnboardingStatus.incomplete;
    } on ApiException catch (error) {
      // Stale/invalid token: clear session and force fresh login flow.
      if (error.statusCode == 401) {
        await AuthTokenStore.clear();
        return OnboardingStatus.unauthorized;
      }

      // Fail closed on other API issues.
      return OnboardingStatus.incomplete;
    } catch (_) {
      // Fail closed: if profile cannot be fetched, keep user in question flow.
      return OnboardingStatus.incomplete;
    }
  }

  static Future<void> signInWithAppleAndExchange() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      throw const AuthFlowException(
        'Apple sign-in is only available on Apple devices.',
      );
    }

    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final identityToken = appleCredential.identityToken;
    if (identityToken == null || identityToken.isEmpty) {
      throw const AuthFlowException(
        'Apple sign-in did not return identity token.',
      );
    }

    final oauthCredential = OAuthProvider(
      'apple.com',
    ).credential(idToken: identityToken, rawNonce: rawNonce);

    final userCredential = await _firebaseAuth.signInWithCredential(
      oauthCredential,
    );
    final user = userCredential.user;
    if (user == null) {
      throw const AuthFlowException('Apple sign-in did not return a user.');
    }

    try {
      await _exchangeFirebaseToken(user);
    } catch (_) {
      await AuthTokenStore.clear();
      rethrow;
    }
  }

  static Future<void> signInAsGuest() async {
    try {
      final data = await _apiClient.post(
        '/auth/guest',
        body: const <String, dynamic>{},
      );
      await _storeBackendToken(data);
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        throw const AuthFlowException(
          'Misafir girisi backend tarafinda henuz aktif degil. /auth/guest endpointi eksik.',
        );
      }
      rethrow;
    } catch (_) {
      await AuthTokenStore.clear();
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      AuthTokenStore.clear(),
    ]);
  }

  static Future<void> _exchangeFirebaseToken(
    User user, {
    String? displayNameHint,
    String? emailHint,
    String? photoUrlHint,
  }) async {
    final idToken = await user.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      throw const AuthFlowException(
        'Firebase ID token could not be retrieved.',
      );
    }

    final data = await _apiClient.post(
      '/auth/exchange',
      body: {
        'firebase_token': idToken,
        'display_name': displayNameHint ?? user.displayName,
        'email': emailHint ?? user.email,
        'photo_url': photoUrlHint ?? user.photoURL,
      },
    );

    await _storeBackendToken(data);
  }

  static Future<void> _storeBackendToken(Map<String, dynamic> data) async {
    final token = data['token'];
    if (token is! String || token.trim().isEmpty) {
      throw const AuthFlowException('Backend auth token is missing.');
    }

    await AuthTokenStore.setToken(token);
  }

  static String _generateNonce([int length = 32]) {
    const chars =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}

class AuthFlowException implements Exception {
  const AuthFlowException(this.message);

  final String message;

  @override
  String toString() => message;
}

enum OnboardingStatus { completed, incomplete, unauthorized }

String mapAuthError(Object error) {
  if (error is AuthFlowException) {
    return error.message;
  }

  if (error is ApiException) {
    return error.message;
  }

  if (error is FirebaseAuthException && error.message != null) {
    return error.message!;
  }

  return 'Authentication failed. Please try again.';
}
