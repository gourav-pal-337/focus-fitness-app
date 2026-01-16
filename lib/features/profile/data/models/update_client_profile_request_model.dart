class UpdateClientProfileRequestModel {
  UpdateClientProfileRequestModel({
    this.fullName,
    this.preferredName,
    this.dateOfBirth,
    this.age,
    this.height,
    this.weight,
    this.fitnessLevel,
    this.goals,
    this.weightGoal,
    this.bodyType,
    this.performanceGoal,
    this.healthNotes,
    this.notes,
  });

  final String? fullName;
  final String? preferredName;
  final String? dateOfBirth; // ISO 8601 date string (YYYY-MM-DD)
  final int? age; // Calculated from dateOfBirth
  final double? height;
  final double? weight;
  final String? fitnessLevel;
  final String? goals;
  final String? weightGoal;
  final String? bodyType;
  final String? performanceGoal;
  final String? healthNotes;
  final String? notes;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        data[key] = value;
      }
    }

    addIfNotNull('fullName', fullName?.trim().isEmpty == true ? null : fullName?.trim());
    addIfNotNull('preferredName', preferredName?.trim().isEmpty == true ? null : preferredName?.trim());
    // Always include dob when dateOfBirth is provided (for updates)
    final dobValue = dateOfBirth?.trim();
    if (dobValue != null) {
      // Send the value (even if empty, to allow clearing the field)
      data['dob'] = dobValue.isEmpty ? null : dobValue;
    } else if (dateOfBirth != null) {
      // dateOfBirth is not null but trim returned null (shouldn't happen, but handle it)
      data['dob'] = null;
    }
    // Include age when provided (calculated from DOB)
    addIfNotNull('age', age);
    addIfNotNull('height', height);
    addIfNotNull('weight', weight);
    addIfNotNull('fitnessLevel', fitnessLevel?.trim().isEmpty == true ? null : fitnessLevel?.trim());
    addIfNotNull('goals', goals?.trim().isEmpty == true ? null : goals?.trim());
    addIfNotNull('weightGoal', weightGoal?.trim().isEmpty == true ? null : weightGoal?.trim());
    addIfNotNull('bodyType', bodyType?.trim().isEmpty == true ? null : bodyType?.trim());
    addIfNotNull('performanceGoal', performanceGoal?.trim().isEmpty == true ? null : performanceGoal?.trim());
    addIfNotNull('healthNotes', healthNotes?.trim().isEmpty == true ? null : healthNotes?.trim());
    addIfNotNull('notes', notes?.trim().isEmpty == true ? null : notes?.trim());

    return data;
  }
}
