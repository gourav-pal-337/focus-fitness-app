import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_sliver_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';
import '../provider/workout_provider.dart';
import '../widgets/exercise_overview_section.dart';
import '../widgets/exercise_video_section.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  const ExerciseDetailsScreen({
    super.key,
    required this.exerciseId,
  });

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExercisesProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<ExercisesProvider>(
        builder: (context, provider, child) {
          final exercise = provider.exercises.firstWhere(
            (e) => e.id == exerciseId,
            orElse: () => provider.exercises.first,
          );

          return CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: exercise.name,
                backgroundImage: exercise.imageUrl,
                expandedHeight: 200.h,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding.left,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.lg),
                      ExerciseOverviewSection(exercise: exercise),
                      SizedBox(height: AppSpacing.xl),
                      if (exercise.videoThumbnailUrl != null) ...[
                        ExerciseVideoSection(exercise: exercise),
                        SizedBox(height: AppSpacing.xl),
                      ],
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<ExercisesProvider>(
        builder: (context, provider, child) {
          final exercise = provider.exercises.firstWhere(
            (e) => e.id == exerciseId,
            orElse: () => provider.exercises.first,
          );
          final isLogged = provider.isExerciseLogged(exerciseId);

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding.left),
              child: CustomButton(
                text: isLogged ? 'Exercise Added' : 'Add Exercise',
                type: ButtonType.filled,
                onPressed: isLogged
                    ? null
                    : () {
                        provider.logExercise(exercise);
                        context.push(
                          '${WorkoutProgressRoute.path}?exerciseId=${exercise.id}&exerciseName=${Uri.encodeComponent(exercise.name)}',
                        );
                      },
                backgroundColor: AppColors.primary,
                textColor: AppColors.background,
                borderRadius: 12.r,
                
                icon: isLogged
                    ? null
                    : Icon(
                        Icons.add,
                        size: 20.sp,
                        color: AppColors.background,
                      ),
                iconPosition: IconPosition.left,
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}

