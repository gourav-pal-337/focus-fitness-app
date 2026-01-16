/// Response model for get session summary
class SessionSummaryResponseModel {
  SessionSummaryResponseModel({
    required this.success,
    this.summary,
  });

  final bool success;
  final SessionSummary? summary;

  factory SessionSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    return SessionSummaryResponseModel(
      success: json['success'] as bool? ?? false,
      summary: json['summary'] != null
          ? SessionSummary.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Session summary model
class SessionSummary {
  SessionSummary({
    required this.id,
    required this.bookingId,
    required this.trainerId,
    required this.clientId,
    required this.sessionDate,
    required this.createdAt,
    required this.updatedAt,
    this.weight,
    this.performance,
    this.exercises,
    this.trainerNotes,
    this.clientNotes,
  });

  final String id;
  final String bookingId;
  final String trainerId;
  final String clientId;
  final double? weight;
  final PerformanceMetrics? performance;
  final List<ExerciseSummary>? exercises;
  final String? trainerNotes;
  final String? clientNotes;
  final String sessionDate;
  final String createdAt;
  final String updatedAt;

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    return SessionSummary(
      id: json['_id'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? '',
      trainerId: json['trainerId'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      performance: json['performance'] != null
          ? PerformanceMetrics.fromJson(json['performance'] as Map<String, dynamic>)
          : null,
      exercises: json['exercises'] != null
          ? (json['exercises'] as List)
              .map((item) => ExerciseSummary.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      trainerNotes: json['trainerNotes'] as String?,
      clientNotes: json['clientNotes'] as String?,
      sessionDate: json['sessionDate'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}

/// Performance metrics model
class PerformanceMetrics {
  PerformanceMetrics({
    this.reps,
    this.sets,
  });

  final int? reps;
  final int? sets;

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      reps: json['reps'] as int?,
      sets: json['sets'] as int?,
    );
  }
}

/// Exercise summary model
class ExerciseSummary {
  ExerciseSummary({
    required this.name,
    this.sets,
    this.reps,
    this.weight,
    this.duration,
    this.notes,
  });

  final String name;
  final int? sets;
  final int? reps;
  final double? weight;
  final int? duration; // Duration in seconds
  final String? notes;

  factory ExerciseSummary.fromJson(Map<String, dynamic> json) {
    return ExerciseSummary(
      name: json['name'] as String? ?? '',
      sets: json['sets'] as int?,
      reps: json['reps'] as int?,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      duration: json['duration'] as int?,
      notes: json['notes'] as String?,
    );
  }
}

