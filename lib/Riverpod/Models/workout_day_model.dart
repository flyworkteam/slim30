class WorkoutDayModel {
  const WorkoutDayModel({
    required this.day,
    required this.type,
    required this.title,
  });

  final int day;
  final String type;
  final String title;

  factory WorkoutDayModel.fromJson(Map<String, dynamic> json) {
    return WorkoutDayModel(
      day: (json['day'] as num?)?.toInt() ?? 0,
      type: (json['type'] as String?) ?? 'workout',
      title: (json['title'] as String?) ?? 'Workout',
    );
  }
}

class WorkoutExerciseModel {
  const WorkoutExerciseModel({
    required this.name,
    required this.sets,
    required this.reps,
  });

  final String name;
  final int sets;
  final String reps;

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      name: (json['name'] as String?) ?? 'Exercise',
      sets: (json['sets'] as num?)?.toInt() ?? 1,
      reps: (json['reps'] as String?) ?? '-',
    );
  }
}

class WorkoutDayDetailModel {
  const WorkoutDayDetailModel({
    required this.day,
    required this.type,
    required this.title,
    required this.estimatedMinutes,
    required this.exercises,
  });

  final int day;
  final String type;
  final String title;
  final int estimatedMinutes;
  final List<WorkoutExerciseModel> exercises;

  factory WorkoutDayDetailModel.fromJson(Map<String, dynamic> json) {
    final rawExercises = json['exercises'];
    final exercises = rawExercises is List
        ? rawExercises
              .whereType<Map<String, dynamic>>()
              .map(WorkoutExerciseModel.fromJson)
              .toList(growable: false)
        : const <WorkoutExerciseModel>[];

    return WorkoutDayDetailModel(
      day: (json['day'] as num?)?.toInt() ?? 0,
      type: (json['type'] as String?) ?? 'workout',
      title: (json['title'] as String?) ?? 'Workout',
      estimatedMinutes: (json['estimated_minutes'] as num?)?.toInt() ?? 0,
      exercises: exercises,
    );
  }
}
