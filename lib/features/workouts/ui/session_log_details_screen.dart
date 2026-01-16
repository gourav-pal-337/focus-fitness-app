import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/workout_provider.dart';

class SessionLogDetailsScreen extends StatelessWidget {
  const SessionLogDetailsScreen({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: WorkoutProgressProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Session Log',
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SessionSummarySection(date: date),
                      SizedBox(height: AppSpacing.xl),
                      Consumer<WorkoutProgressProvider>(
                        builder: (context, provider, child) {
                          final workoutProgress = provider.getWorkoutProgressForDate(date);

                          if (workoutProgress.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                              child: Center(
                                child: Text(
                                  'No exercises logged for this session',
                                  style: AppTextStyle.text16Medium.copyWith(
                                    color: AppColors.grey400,
                                  ),
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            itemCount: workoutProgress.length,
                            separatorBuilder: (context, index) => SizedBox(
                              height: AppSpacing.md,
                            ),
                            itemBuilder: (context, index) {
                              return _ExerciseCard(
                                workoutProgress: workoutProgress[index],
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionSummarySection extends StatelessWidget {
  const _SessionSummarySection({
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(date.year, date.month, date.day);

    String dateDisplay;
    if (sessionDate.year == today.year &&
        sessionDate.month == today.month &&
        sessionDate.day == today.day) {
      dateDisplay = 'Today';
    } else {
      dateDisplay = DateFormat('dd/MM/yyyy').format(sessionDate);
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gym Session',
                  style: AppTextStyle.text16SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  '$dateDisplay • 04:10 PM',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60.w,
                  height: 60.w,
                  color: AppColors.grey75,
                  child: Icon(
                    Icons.fitness_center,
                    size: 24.sp,
                    color: AppColors.grey400,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.workoutProgress,
  });

  final WorkoutProgress workoutProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
            // offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fitness_center,
                size: 20.sp,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                workoutProgress.exerciseName,
                style: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Divider(
            color: AppColors.grey200,
            thickness: 1,
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text(
                  'Sets',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Reps',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Weight',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Divider(
            color: AppColors.grey200,
            thickness: 1,
          ),
          if (workoutProgress.sets.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Center(
                child: Text(
                  'No sets added',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ),
            )
          else
            ...workoutProgress.sets.asMap().entries.map((entry) {
              final index = entry.key;
              final set = entry.value;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyle.text14Medium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${set.reps}',
                        style: AppTextStyle.text14Medium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        set.weight != null ? '${set.weight}kg' : '-',
                        style: AppTextStyle.text14Medium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

