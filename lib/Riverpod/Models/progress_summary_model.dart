class ProgressSummaryModel {
  const ProgressSummaryModel({
    required this.totalDays,
    required this.completedDays,
    required this.remainingDays,
    required this.completionRate,
  });

  final int totalDays;
  final int completedDays;
  final int remainingDays;
  final double completionRate;

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProgressSummaryModel(
      totalDays: (json['totalDays'] as num?)?.toInt() ?? 30,
      completedDays: (json['completedDays'] as num?)?.toInt() ?? 0,
      remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 30,
      completionRate: (json['completionRate'] as num?)?.toDouble() ?? 0,
    );
  }
}
