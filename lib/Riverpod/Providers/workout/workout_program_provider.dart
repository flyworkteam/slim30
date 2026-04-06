import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slim30/Core/Config/app_config.dart';
import 'package:slim30/Core/Network/api_client.dart';
import 'package:slim30/Riverpod/Models/progress_day_model.dart';
import 'package:slim30/Riverpod/Models/progress_summary_model.dart';
import 'package:slim30/Riverpod/Models/workout_day_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    defaultHeaders: AppConfig.apiHeaders,
  );
});

final workoutProgramProvider = FutureProvider<List<WorkoutDayModel>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.get('/workouts/program');
  final program = data['program'];
  if (program is! Map<String, dynamic>) {
    return const <WorkoutDayModel>[];
  }

  final rawDays = program['days'];
  if (rawDays is! List) {
    return const <WorkoutDayModel>[];
  }

  return rawDays
      .whereType<Map<String, dynamic>>()
      .map(WorkoutDayModel.fromJson)
      .where((item) => item.day >= 1 && item.day <= 30)
      .toList(growable: false);
});

final completedProgressDaysProvider = FutureProvider<Set<int>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.get('/progress/days');
  final rawDays = data['days'];
  if (rawDays is! List) {
    return <int>{};
  }

  return rawDays
      .whereType<Map<String, dynamic>>()
      .map(ProgressDayModel.fromJson)
      .where((item) => item.day >= 1 && item.day <= 30 && item.completed)
      .map((item) => item.day)
      .toSet();
});

final progressSummaryProvider = FutureProvider<ProgressSummaryModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final data = await apiClient.get('/progress/summary');
  final summary = data['summary'];
  if (summary is! Map<String, dynamic>) {
    return const ProgressSummaryModel(
      totalDays: 30,
      completedDays: 0,
      remainingDays: 30,
      completionRate: 0,
    );
  }

  return ProgressSummaryModel.fromJson(summary);
});

@immutable
class WorkoutProgramUiItem {
  const WorkoutProgramUiItem({
    required this.dayNumber,
    required this.title,
    required this.isCompleted,
    required this.isLocked,
    required this.imagePath,
  });

  final int dayNumber;
  final String title;
  final bool isCompleted;
  final bool isLocked;
  final String imagePath;
}

final workoutProgramUiProvider = FutureProvider<List<WorkoutProgramUiItem>>((ref) async {
  final programDays = await ref.watch(workoutProgramProvider.future);
  final completedDays = await ref.watch(completedProgressDaysProvider.future);

  final hasAnyCompletion = completedDays.isNotEmpty;
  final maxCompletedDay = hasAnyCompletion
      ? completedDays.reduce((current, next) => current > next ? current : next)
      : 0;

  return programDays
      .map((day) {
        final isCompleted = completedDays.contains(day.day);
        final isLocked = hasAnyCompletion && day.day > (maxCompletedDay + 1);

        return WorkoutProgramUiItem(
          dayNumber: day.day,
          title: day.title,
          isCompleted: isCompleted,
          isLocked: isLocked,
          imagePath: 'assets/images/antrenman/day${((day.day - 1) % 16) + 1}.jpg',
        );
      })
      .toList(growable: false);
});
