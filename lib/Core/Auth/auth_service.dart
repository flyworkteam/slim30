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
import 'package:slim30/Core/Storage/auth_token_store.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final ApiClient _apiClient = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    defaultHeaders: AppConfig.apiHeaders,
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

    try {
      await _exchangeFirebaseToken(user);
    } catch (_) {
      await AuthTokenStore.clear();
      rethrow;
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

  static Future<void> _exchangeFirebaseToken(User user) async {
    final idToken = await user.getIdToken(true);
    if (idToken == null || idToken.isEmpty) {
      throw const AuthFlowException(
        'Firebase ID token could not be retrieved.',
      );
    }

    final data = await _apiClient.post(
      '/auth/exchange',
      body: {'firebase_token': idToken},
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
