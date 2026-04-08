import 'package:slim30/Core/Config/app_config.dart';
import 'package:slim30/Core/Network/api_client.dart';
import 'package:slim30/Core/Storage/app_locale_store.dart';
import 'package:slim30/Core/Storage/auth_token_store.dart';

class OnboardingApi {
  OnboardingApi._();

  static final ApiClient _client = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    defaultHeaders: AppConfig.apiHeaders,
    authTokenProvider: AuthTokenStore.getToken,
    localeCodeProvider: AppLocaleStore.getLanguageCode,
  );

  static Future<void> upsertAnswer(String questionKey, Object? answerValue) async {
    await _client.put(
      '/onboarding/answers',
      body: {
        'answers': [
          {
            'question_key': questionKey,
            'answer_value': answerValue,
          },
        ],
      },
    );
  }

  static Future<void> upsertMany(Map<String, Object?> answers) async {
    if (answers.isEmpty) {
      return;
    }

    await _client.put(
      '/onboarding/answers',
      body: {
        'answers': answers.entries
            .map(
              (entry) => {
                'question_key': entry.key,
                'answer_value': entry.value,
              },
            )
            .toList(growable: false),
      },
    );
  }

  static Future<void> tryUpsertAnswer(String questionKey, Object? answerValue) async {
    try {
      await upsertAnswer(questionKey, answerValue);
    } catch (_) {
      // Fail-open to keep onboarding flow responsive when network is unavailable.
    }
  }

  static Future<void> tryUpsertMany(Map<String, Object?> answers) async {
    try {
      await upsertMany(answers);
    } catch (_) {
      // Fail-open to keep onboarding flow responsive when network is unavailable.
    }
  }
}
