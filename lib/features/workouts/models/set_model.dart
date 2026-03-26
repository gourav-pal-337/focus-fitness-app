class SetModel {
  const SetModel({required this.reps, this.weight});

  final int reps;
  final double? weight;

  factory SetModel.fromJson(Map<String, dynamic> json) {
    final repsRaw = json['reps'];
    final weightRaw = json['weight'];

    int reps = 0;
    if (repsRaw is num) {
      reps = repsRaw.toInt();
    } else if (repsRaw is String) {
      reps = int.tryParse(repsRaw) ?? 0;
    }

    double? weight;
    if (weightRaw is num) {
      weight = weightRaw.toDouble();
    } else if (weightRaw is String && weightRaw.trim().isNotEmpty) {
      weight = double.tryParse(weightRaw);
    }

    return SetModel(
      reps: reps,
      weight: weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }
}
