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
