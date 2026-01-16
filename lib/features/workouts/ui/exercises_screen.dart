import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';
import '../provider/workout_provider.dart';
import '../widgets/exercise_card.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({
    super.key,
    this.fromWorkoutProgress = false,
    this.workoutDate,
  });

  final bool fromWorkoutProgress;
  final DateTime? workoutDate;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExercisesProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Exercises',
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.left,
                  vertical: AppSpacing.md,
                ),
                child: _SearchBar(),
              ),
              Expanded(
                child: Consumer<ExercisesProvider>(
                  builder: (context, provider, child) {
                    final exercises = provider.filteredExercises;
                    return exercises.isEmpty
                        ? Center(
                            child: Text(
                              'No exercises found',
                              style: AppTextStyle.text16Medium.copyWith(
                                color: AppColors.grey400,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.screenPadding.left,
                            ),
                            child: GridView.builder(
                              padding: EdgeInsets.only(bottom: AppSpacing.xl),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppSpacing.md,
                                mainAxisSpacing: AppSpacing.md,
                                childAspectRatio: 6/5,
                              ),
                              itemCount: exercises.length,
                              itemBuilder: (context, index) {
                                final exercise = exercises[index];
                                return ExerciseCard(
                                  exercise: exercise,
                                  onTap: () {
                                    if (fromWorkoutProgress && workoutDate != null) {
                                      final workoutProvider = WorkoutProgressProvider();
                                      workoutProvider.addExerciseToWorkout(
                                        workoutDate!,
                                        exercise,
                                      );
                                      context.pop();
                                    } else {
                                      context.push(
                                        '${ExerciseDetailsRoute.path}?exerciseId=${exercise.id}',
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExercisesProvider>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey75,
        borderRadius: AppRadius.medium,
      ),
      child: TextField(
        onChanged: (value) {
          provider.setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search exercises',
          hintStyle: AppTextStyle.text14Regular.copyWith(
            color: AppColors.grey400,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20.sp,
            color: AppColors.grey400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
        style: AppTextStyle.text14Regular.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

