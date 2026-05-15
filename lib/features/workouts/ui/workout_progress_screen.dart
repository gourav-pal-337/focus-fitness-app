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
import '../models/set_model.dart';
import '../models/workout_exercise_model.dart';
import '../providers/session_provider.dart';
import '../services/workout_api_service.dart';
import '../provider/workout_provider.dart';
import '../../../core/provider/app_features_provider.dart';
import '../../../core/widgets/feature_disabled_widget.dart';
import '../../../core/widgets/feature_flag_wrapper.dart';
import '../widgets/exercise_progress_card.dart';
import '../widgets/date_selector.dart';

class WorkoutProgressScreen extends StatefulWidget {
  const WorkoutProgressScreen({
    super.key,
    this.initialDate,
    this.exerciseIdToAdd,
    this.exerciseNameToAdd,
  });

  final DateTime? initialDate;
  final String? exerciseIdToAdd;
  final String? exerciseNameToAdd;

  @override
  State<WorkoutProgressScreen> createState() => _WorkoutProgressScreenState();
}

class _WorkoutProgressScreenState extends State<WorkoutProgressScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled =
        context
            .watch<AppFeaturesProvider>()
            .features
            ?.workouts
            .workoutProgress ??
        true;

    return FeatureFlagWrapper(
      isEnabled: isEnabled,
      title: 'Coming Soon',
      message:
          'Workout tracking is currently under maintenance. Please check back later.',
      icon: Icons.history,
      child: ChangeNotifierProvider.value(
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
  State<_WorkoutProgressContent> createState() =>
      _WorkoutProgressContentState();
}

class _WorkoutProgressContentState extends State<_WorkoutProgressContent> {
  final SessionProvider _sessionProvider = SessionProvider();
  final WorkoutApiService _workoutApiService = WorkoutApiService();
  bool _isSyncingFromBackend = false;
  bool _isFinishing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncAssignedWorkoutFromBackendIfNeeded();

      if (widget.exerciseIdToAdd != null && widget.exerciseNameToAdd != null) {
        final provider = context.read<WorkoutProgressProvider>();
        final exercise = Exercise(
          id: widget.exerciseIdToAdd!,
          name: widget.exerciseNameToAdd!,
          imageUrl: '',
        );
        provider.addExerciseToWorkout(widget.selectedDate, exercise);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _WorkoutProgressContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncAssignedWorkoutFromBackendIfNeeded();
      });
    }
  }

  Future<void> _syncAssignedWorkoutFromBackendIfNeeded() async {
    final provider = context.read<WorkoutProgressProvider>();
    final existing = provider.getWorkoutProgressForDate(widget.selectedDate);
    if (existing.isNotEmpty) return;

    final normalizedDate = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    setState(() => _isSyncingFromBackend = true);

    try {
      final response = await _workoutApiService.getWorkoutProgressByDate(
        normalizedDate,
      );

      for (final workout in response.progress) {
        final exercise = Exercise(
          id: workout.exerciseId,
          name: workout.exerciseName,
          imageUrl: '',
        );

        provider.addExerciseToWorkout(
          normalizedDate,
          exercise,
          planSets: workout.planSets,
          planReps: workout.planReps,
        );

        for (final set in workout.sets) {
          provider.addSetToExercise(
            normalizedDate,
            workout.exerciseId,
            WorkoutSet(reps: set.reps, weight: set.weight),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _syncAssignedWorkoutFromBackendIfNeeded,
          ),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isSyncingFromBackend = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Workout Progress'),
            DateSelector(
              selectedDate: widget.selectedDate,
              onDateSelected: widget.onDateSelected,
            ),
            Expanded(
              child: Consumer<WorkoutProgressProvider>(
                builder: (context, provider, child) {
                  final workoutProgress = provider.getWorkoutProgressForDate(
                    widget.selectedDate,
                  );

                  if (_isSyncingFromBackend) {
                    return const Center(child: CircularProgressIndicator());
                  }

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
      // bottomNavigationBar: SafeArea(
      //   child: Consumer<WorkoutProgressProvider>(
      //     builder: (context, provider, _) {
      //       final workouts = provider.getWorkoutProgressForDate(
      //         widget.selectedDate,
      //       );
      //       final hasExercises = workouts.isNotEmpty;

      //       return Padding(
      //         padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      //         child: CustomButton(
      //           text: hasExercises
      //               ? (_isFinishing ? 'Saving...' : 'Finish Workout')
      //               : 'Add Exercise',
      //           type: ButtonType.filled,
      //           onPressed: _isFinishing
      //               ? null
      //               : () async {
      //                   if (!hasExercises) {
      //                     context.push(
      //                       '${ExercisesRoute.path}?fromWorkoutProgress=true&date=${widget.selectedDate.millisecondsSinceEpoch}',
      //                     );
      //                     return;
      //                   }

      //                   final payload = workouts
      //                       .map(
      //                         (w) => WorkoutExerciseModel(
      //                           exerciseId: w.exerciseId,
      //                           exerciseName: w.exerciseName,
      //                           date: widget.selectedDate,
      //                           sets: w.sets
      //                               .map(
      //                                 (s) => SetModel(
      //                                   reps: s.reps,
      //                                   weight: s.weight,
      //                                 ),
      //                               )
      //                               .toList(),
      //                         ),
      //                       )
      //                       .toList();

      //                   setState(() => _isFinishing = true);

      //                   final success = await _sessionProvider.saveFullDay(
      //                     date: widget.selectedDate,
      //                     workouts: payload,
      //                   );

      //                   if (!mounted) return;
      //                   setState(() => _isFinishing = false);

      //                   ScaffoldMessenger.of(context).showSnackBar(
      //                     SnackBar(
      //                       content: Text(
      //                         success
      //                             ? 'Workout saved successfully'
      //                             : (_sessionProvider.errorMessage ??
      //                                   'Failed to save workout'),
      //                       ),
      //                       action: !success
      //                           ? SnackBarAction(
      //                               label: 'Retry',
      //                               onPressed: () async {
      //                                 setState(() => _isFinishing = true);
      //                                 final retrySuccess =
      //                                     await _sessionProvider.saveFullDay(
      //                                       date: widget.selectedDate,
      //                                       workouts: payload,
      //                                     );
      //                                 if (!mounted) return;
      //                                 setState(() => _isFinishing = false);

      //                                 if (retrySuccess) {
      //                                   context.pop(true);
      //                                 } else {
      //                                   ScaffoldMessenger.of(
      //                                     context,
      //                                   ).showSnackBar(
      //                                     SnackBar(
      //                                       content: Text(
      //                                         _sessionProvider.errorMessage ??
      //                                             'Retry failed',
      //                                       ),
      //                                     ),
      //                                   );
      //                                 }
      //                               },
      //                             )
      //                           : null,
      //                     ),
      //                   );

      //                   if (success) {
      //                     context.pop(true);
      //                   }
      //                 },
      //           backgroundColor: AppColors.primary,
      //           textColor: AppColors.background,
      //           borderRadius: 12.r,
      //           icon: Icon(
      //             hasExercises ? Icons.check : Icons.add,
      //             size: 20.sp,
      //             color: AppColors.background,
      //           ),
      //           iconPosition: IconPosition.left,
      //         ),
      //       );
      //     },
      // ),
      // ),
    );
  }
}
