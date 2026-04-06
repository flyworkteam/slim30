import 'package:slim30/Core/Config/app_config.dart';
import 'package:slim30/Core/Network/api_client.dart';

class OnboardingApi {
  OnboardingApi._();

  static final ApiClient _client = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    defaultHeaders: AppConfig.apiHeaders,
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
}
