class WeeklyProgressModel {
  final String date;
  final int completed;
  final int expected;
  final int percent;

  WeeklyProgressModel({
    required this.date,
    required this.completed,
    required this.expected,
    required this.percent,
  });

  factory WeeklyProgressModel.fromJson(Map<String, dynamic> json) {
    return WeeklyProgressModel(
      date: json['date'] ?? '',
      completed: json['completed'] ?? 0,
      expected: json['expected'] ?? 0,
      percent: json['percent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'completed': completed,
      'expected': expected,
      'percent': percent,
    };
  }
}
