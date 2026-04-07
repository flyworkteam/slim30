class ProgressSummaryModel {
  const ProgressSummaryModel({
    required this.totalDays,
    required this.completedDays,
    required this.remainingDays,
    required this.completionRate,
    required this.successRate,
    required this.totalCompletedExercises,
    required this.movementCount,
    required this.totalWorkoutSeconds,
    required this.totalWorkoutMinutes,
    required this.caloriesBurned,
    this.muscleGainKg,
    this.waistChangeCm,
    this.bodyFatChangePercent,
    this.weightLostKg,
    this.restingHeartRateBpm,
    this.hydrationPercent,
    this.sleepHours,
  });

  final int totalDays;
  final int completedDays;
  final int remainingDays;
  final double completionRate;
  final double successRate;
  final int totalCompletedExercises;
  final int movementCount;
  final int totalWorkoutSeconds;
  final int totalWorkoutMinutes;
  final int caloriesBurned;
  final double? muscleGainKg;
  final double? waistChangeCm;
  final double? bodyFatChangePercent;
  final double? weightLostKg;
  final int? restingHeartRateBpm;
  final int? hydrationPercent;
  final double? sleepHours;

  static double? _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return null;
  }

  static int? _asInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return null;
  }

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    final completionRate = (json['completionRate'] as num?)?.toDouble() ?? 0;

    return ProgressSummaryModel(
      totalDays: (json['totalDays'] as num?)?.toInt() ?? 30,
      completedDays: (json['completedDays'] as num?)?.toInt() ?? 0,
      remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 30,
      completionRate: completionRate,
      successRate: (json['successRate'] as num?)?.toDouble() ?? completionRate,
      totalCompletedExercises:
          (json['totalCompletedExercises'] as num?)?.toInt() ?? 0,
      movementCount: (json['movementCount'] as num?)?.toInt() ?? 0,
      totalWorkoutSeconds: (json['totalWorkoutSeconds'] as num?)?.toInt() ?? 0,
      totalWorkoutMinutes: (json['totalWorkoutMinutes'] as num?)?.toInt() ?? 0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toInt() ?? 0,
      muscleGainKg: _asDouble(json['muscleGainKg']),
      waistChangeCm: _asDouble(json['waistChangeCm']),
      bodyFatChangePercent: _asDouble(json['bodyFatChangePercent']),
      weightLostKg: _asDouble(json['weightLostKg']),
      restingHeartRateBpm: _asInt(json['restingHeartRateBpm']),
      hydrationPercent: _asInt(json['hydrationPercent']),
      sleepHours: _asDouble(json['sleepHours']),
    );
  }
}
