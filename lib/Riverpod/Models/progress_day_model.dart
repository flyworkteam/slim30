class ProgressDayModel {
  const ProgressDayModel({
    required this.day,
    required this.completed,
  });

  final int day;
  final bool completed;

  factory ProgressDayModel.fromJson(Map<String, dynamic> json) {
    return ProgressDayModel(
      day: (json['day'] as num?)?.toInt() ?? 0,
      completed: json['completed'] == true,
    );
  }
}
