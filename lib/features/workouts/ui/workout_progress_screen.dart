import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';
import '../provider/workout_provider.dart';
import '../widgets/exercise_progress_card.dart';
import '../widgets/date_selector.dart';

class WorkoutProgressScreen extends StatefulWidget {
  const WorkoutProgressScreen({
    super.key,
    this.exerciseIdToAdd,
    this.exerciseNameToAdd,
  });

  final String? exerciseIdToAdd;
  final String? exerciseNameToAdd;

  @override
  State<WorkoutProgressScreen> createState() => _WorkoutProgressScreenState();
}

class _WorkoutProgressScreenState extends State<WorkoutProgressScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: WorkoutProgressProvider(),
      child: _WorkoutProgressContent(
        selectedDate: _selectedDate,
        onDateSelected: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
        exerciseIdToAdd: widget.exerciseIdToAdd,
        exerciseNameToAdd: widget.exerciseNameToAdd,
      ),
    );
  }
}

class _WorkoutProgressContent extends StatefulWidget {
  const _WorkoutProgressContent({
    required this.selectedDate,
    required this.onDateSelected,
    this.exerciseIdToAdd,
    this.exerciseNameToAdd,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? exerciseIdToAdd;
  final String? exerciseNameToAdd;

  @override
  State<_WorkoutProgressContent> createState() => _WorkoutProgressContentState();
}

class _WorkoutProgressContentState extends State<_WorkoutProgressContent> {
  @override
  void initState() {
    super.initState();
    if (widget.exerciseIdToAdd != null && widget.exerciseNameToAdd != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<WorkoutProgressProvider>();
        final exercise = Exercise(
          id: widget.exerciseIdToAdd!,
          name: widget.exerciseNameToAdd!,
          imageUrl: '',
        );
        provider.addExerciseToWorkout(widget.selectedDate, exercise);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Workout Progress',
            ),
            DateSelector(
              selectedDate: widget.selectedDate,
              onDateSelected: widget.onDateSelected,
            ),
            Expanded(
              child: Consumer<WorkoutProgressProvider>(
                builder: (context, provider, child) {
                  final workoutProgress = provider.getWorkoutProgressForDate(widget.selectedDate);

                  if (workoutProgress.isEmpty) {
                    return Center(
                      child: Text(
                        'No exercises added for this date',
                        style: AppTextStyle.text16Medium.copyWith(
                          color: AppColors.grey400,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(
                      top: AppSpacing.md,
                      bottom: AppSpacing.xl,
                    ),
                    itemCount: workoutProgress.length,
                    itemBuilder: (context, index) {
                      final progress = workoutProgress[index];
                                    return ExerciseProgressCard(
                                      workoutProgress: progress,
                                      date: widget.selectedDate,
                                      onAddSet: () {
                                        context.push(
                                          '${EditExerciseSetRoute.path}?exerciseId=${progress.exerciseId}&exerciseName=${Uri.encodeComponent(progress.exerciseName)}&date=${widget.selectedDate.millisecondsSinceEpoch}',
                                        );
                                      },
                                    );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
            bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding.left),
          child: CustomButton(
            text: 'Add Exercise',
            type: ButtonType.filled,
            onPressed: () {
              context.push(
                '${ExercisesRoute.path}?fromWorkoutProgress=true&date=${widget.selectedDate.millisecondsSinceEpoch}',
              );
            },
            backgroundColor: AppColors.primary,
            textColor: AppColors.background,
            borderRadius: 12.r,
            icon: Icon(
              Icons.add,
              size: 20.sp,
              color: AppColors.background,
            ),
            iconPosition: IconPosition.left,
          ),
        ),
      ),
    );
  }
}

