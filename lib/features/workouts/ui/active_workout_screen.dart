import 'package:flutter/material.dart';

import 'workout_progress_screen.dart';

class ActiveWorkoutScreen extends StatelessWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuses existing workout progress UI to preserve current look and feel.
    return const WorkoutProgressScreen();
  }
}
