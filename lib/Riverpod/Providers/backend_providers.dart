import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slim30/Core/Network/api_client.dart';
import 'package:slim30/Core/Network/api_exception.dart';
import 'package:slim30/Core/Storage/auth_token_store.dart';
import 'package:slim30/Riverpod/Models/app_models.dart';
import 'package:slim30/Riverpod/Models/progress_summary_model.dart';
import 'package:slim30/Riverpod/Providers/workout/workout_program_provider.dart';

final userProfileProvider = FutureProvider<UserProfileModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.get('/users/profile');
  final user = data['user'];
  if (user is! Map<String, dynamic>) {
    return UserProfileModel.empty();
  }

  return UserProfileModel.fromJson(user);
});

final premiumStatusProvider = FutureProvider<PremiumStatusModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.get('/premium/status');
  final status = data['status'];
  if (status is! Map<String, dynamic>) {
    return const PremiumStatusModel(isPremium: false, trialUsed: false);
  }

  return PremiumStatusModel.fromJson(status);
});

final notificationSettingsProvider = FutureProvider<NotificationSettingsModel>((
  ref,
) async {
  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.get('/notifications/settings');
  final settings = data['settings'];
  if (settings is! Map<String, dynamic>) {
    return NotificationSettingsModel.defaults();
  }

  return NotificationSettingsModel.fromJson(settings);
});

final notificationsProvider = FutureProvider<List<NotificationModel>>((
  ref,
) async {
  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.get('/notifications?limit=100');
  final notifications = data['notifications'];
  if (notifications is! List) {
    return const <NotificationModel>[];
  }

  return notifications
      .whereType<Map<String, dynamic>>()
      .map(NotificationModel.fromJson)
      .toList(growable: false);
});

final homeDashboardProvider = FutureProvider<HomeDashboardModel>((ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  final summary = await ref.watch(progressSummaryProvider.future);
  final premium = await ref.watch(premiumStatusProvider.future);
  final notifications = await ref.watch(notificationsProvider.future);

  final unreadCount = notifications.where((item) => !item.isRead).length;

  return HomeDashboardModel(
    profile: profile,
    completedDays: summary.completedDays,
    totalDays: summary.totalDays,
    completionRate: summary.completionRate,
    isPremium: premium.isPremium,
    unreadNotifications: unreadCount,
  );
});

final onboardingAnswersProvider = FutureProvider<Map<String, Object?>>((
  ref,
) async {
  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.get('/onboarding/answers');
  final answers = data['answers'];
  if (answers is! List) {
    return const <String, Object?>{};
  }

  final mapped = <String, Object?>{};
  for (final raw in answers) {
    if (raw is! Map<String, dynamic>) {
      continue;
    }

    final key = raw['question_key'];
    if (key is String && key.isNotEmpty) {
      mapped[key] = raw['answer_value'];
    }
  }

  return mapped;
});

Future<void> updateProfile(WidgetRef ref, Map<String, dynamic> payload) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.put('/users/profile', body: payload);
  ref.invalidate(userProfileProvider);
  ref.invalidate(homeDashboardProvider);
}

Future<String?> uploadProfileAvatar(
  WidgetRef ref, {
  required Uint8List bytes,
  required String filename,
  required String contentType,
}) async {
  final token = await AuthTokenStore.getToken();
  if (token == null || token.trim().isEmpty) {
    throw ApiException('Oturum bulunamadi. Lutfen tekrar giris yapin.');
  }

  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.postMultipart(
    '/uploads/avatar',
    files: [
      ApiMultipartFile(
        field: 'avatar',
        bytes: bytes,
        filename: filename,
        contentType: contentType,
      ),
    ],
  );
  ref.invalidate(userProfileProvider);
  ref.invalidate(homeDashboardProvider);
  return data['avatar_url'] as String?;
}

Future<void> updateNotificationSettings(
  WidgetRef ref,
  NotificationSettingsModel settings,
) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.put('/notifications/settings', body: settings.toJson());
  ref.invalidate(notificationSettingsProvider);
}

Future<void> markNotificationRead(WidgetRef ref, int id) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.put(
    '/notifications/$id/read',
    body: const <String, dynamic>{},
  );
  ref.invalidate(notificationsProvider);
  ref.invalidate(homeDashboardProvider);
}

Future<void> markAllNotificationsRead(WidgetRef ref) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.put(
    '/notifications/read-all',
    body: const <String, dynamic>{},
  );
  ref.invalidate(notificationsProvider);
  ref.invalidate(homeDashboardProvider);
}

Future<void> deleteNotificationById(WidgetRef ref, int id) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('/notifications/$id');
  ref.invalidate(notificationsProvider);
  ref.invalidate(homeDashboardProvider);
}

Future<void> deleteAllNotifications(WidgetRef ref) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.delete('/notifications');
  ref.invalidate(notificationsProvider);
  ref.invalidate(homeDashboardProvider);
}

Future<void> upsertOnboardingAnswers(
  WidgetRef ref,
  List<OnboardingAnswerModel> answers,
) async {
  if (answers.isEmpty) {
    return;
  }

  final apiClient = ref.read(apiClientProvider);
  await apiClient.put(
    '/onboarding/answers',
    body: {
      'answers': answers.map((item) => item.toJson()).toList(growable: false),
    },
  );
  ref.invalidate(onboardingAnswersProvider);
}

Future<void> startPremiumTrial(WidgetRef ref) async {
  final apiClient = ref.read(apiClientProvider);
  await apiClient.post('/premium/trial/start', body: const <String, dynamic>{});
  ref.invalidate(premiumStatusProvider);
  ref.invalidate(homeDashboardProvider);
}

final progressOverviewProvider = Provider<ProgressSummaryModel?>((ref) {
  return ref.watch(progressSummaryProvider).valueOrNull;
});
