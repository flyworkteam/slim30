import 'package:flutter/foundation.dart';

@immutable
class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.language,
    required this.avatarUrl,
  });

  final int id;
  final String name;
  final String? email;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final double? targetWeightKg;
  final String language;
  final String? avatarUrl;

  factory UserProfileModel.empty() {
    return const UserProfileModel(
      id: 0,
      name: 'User',
      email: null,
      age: null,
      heightCm: null,
      weightKg: null,
      targetWeightKg: null,
      language: 'en',
      avatarUrl: null,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? (json['name'] as String)
          : 'User',
      email: json['email'] as String?,
      age: (json['age'] as num?)?.toInt(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      targetWeightKg: (json['target_weight_kg'] as num?)?.toDouble(),
      language: (json['language'] as String?) ?? 'en',
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}

@immutable
class NotificationSettingsModel {
  const NotificationSettingsModel({
    required this.dailyReminderEnabled,
    required this.workoutReminderEnabled,
    required this.progressSummaryEnabled,
    required this.reminderHour,
  });

  final bool dailyReminderEnabled;
  final bool workoutReminderEnabled;
  final bool progressSummaryEnabled;
  final int reminderHour;

  factory NotificationSettingsModel.defaults() {
    return const NotificationSettingsModel(
      dailyReminderEnabled: true,
      workoutReminderEnabled: true,
      progressSummaryEnabled: true,
      reminderHour: 9,
    );
  }

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      dailyReminderEnabled: json['dailyReminderEnabled'] == true,
      workoutReminderEnabled: json['workoutReminderEnabled'] == true,
      progressSummaryEnabled: json['progressSummaryEnabled'] == true,
      reminderHour: (json['reminderHour'] as num?)?.toInt() ?? 9,
    );
  }

  NotificationSettingsModel copyWith({
    bool? dailyReminderEnabled,
    bool? workoutReminderEnabled,
    bool? progressSummaryEnabled,
    int? reminderHour,
  }) {
    return NotificationSettingsModel(
      dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
      workoutReminderEnabled: workoutReminderEnabled ?? this.workoutReminderEnabled,
      progressSummaryEnabled: progressSummaryEnabled ?? this.progressSummaryEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyReminderEnabled': dailyReminderEnabled,
      'workoutReminderEnabled': workoutReminderEnabled,
      'progressSummaryEnabled': progressSummaryEnabled,
      'reminderHour': reminderHour,
    };
  }
}

@immutable
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.iconName,
    required this.iconBgHex,
    required this.isRead,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final String iconName;
  final String iconBgHex;
  final bool isRead;
  final DateTime createdAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse('${json['createdAt']}') ?? DateTime.now();
    return NotificationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
      iconName: ((json['iconName'] as String?) ?? 'notification').trim(),
      iconBgHex: ((json['iconBgHex'] as String?) ?? '#F5F5F5').trim(),
      isRead: json['isRead'] == true,
      createdAt: createdAt,
    );
  }
}

@immutable
class PremiumStatusModel {
  const PremiumStatusModel({
    required this.isPremium,
    required this.trialUsed,
  });

  final bool isPremium;
  final bool trialUsed;

  factory PremiumStatusModel.fromJson(Map<String, dynamic> json) {
    return PremiumStatusModel(
      isPremium: json['isPremium'] == true,
      trialUsed: json['trialUsed'] == true,
    );
  }
}

@immutable
class HomeDashboardModel {
  const HomeDashboardModel({
    required this.profile,
    required this.completedDays,
    required this.totalDays,
    required this.completionRate,
    required this.isPremium,
    required this.unreadNotifications,
  });

  final UserProfileModel profile;
  final int completedDays;
  final int totalDays;
  final double completionRate;
  final bool isPremium;
  final int unreadNotifications;
}

@immutable
class OnboardingAnswerModel {
  const OnboardingAnswerModel({
    required this.questionKey,
    required this.answerValue,
  });

  final String questionKey;
  final Object? answerValue;

  Map<String, dynamic> toJson() {
    return {
      'question_key': questionKey,
      'answer_value': answerValue,
    };
  }
}
