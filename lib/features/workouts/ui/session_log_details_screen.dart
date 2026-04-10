import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/service/local_storage_service.dart';
import '../widgets/date_selector.dart';
import '../models/workout_exercise_model.dart';
import '../models/workout_day_response_model.dart';
import '../services/workout_api_service.dart';

class SessionLogDetailsScreen extends StatefulWidget {
  SessionLogDetailsScreen({super.key, required this.date});

  DateTime date;

  @override
  State<SessionLogDetailsScreen> createState() =>
      _SessionLogDetailsScreenState();
}

class _SessionLogDetailsScreenState extends State<SessionLogDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Session Log'),
            DateSelector(
              selectedDate: widget.date,
              onDateSelected: (newDate) {
                setState(() {
                  widget.date = newDate;
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.xl),
                    FutureBuilder<List<WorkoutExerciseModel>>(
                      future: _fetchWorkoutsForDate(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final workouts = snapshot.data ?? const [];

                        if (workouts.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(
                              AppSpacing.screenPadding.left,
                            ),
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
                          itemCount: workouts.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            return _ExerciseCard(
                              workoutExercise: workouts[index],
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
    );
  }

  Future<List<WorkoutExerciseModel>> _fetchWorkoutsForDate() async {
    final api = WorkoutApiService();
    try {
      final response = await api.getWorkoutProgressByDate(widget.date);
      return response.progress.where((w) => w.sets.isNotEmpty).toList();
    } catch (_) {
      // Offline fallback to cached data.
      final dateKey = _dateKey(widget.date);
      final cachedJson = await LocalStorageService.getWorkoutCache(dateKey);
      if (cachedJson == null || cachedJson.isEmpty) return const [];
      final decoded = jsonDecode(cachedJson);
      
      if (decoded is Map<String, dynamic>) {
        final response = WorkoutDayResponseModel.fromJson(decoded);
        return response.progress.where((w) => w.sets.isNotEmpty).toList();
      } else if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(WorkoutExerciseModel.fromJson)
            .toList()
            .where((w) => w.sets.isNotEmpty)
            .toList();
      }
      return const [];
    }
  }

  String _dateKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class _SessionSummarySection extends StatelessWidget {
  const _SessionSummarySection({required this.date});

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
  const _ExerciseCard({required this.workoutExercise});

  final WorkoutExerciseModel workoutExercise;

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
                workoutExercise.exerciseName,
                style: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Divider(color: AppColors.grey200, thickness: 1),
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
          Divider(color: AppColors.grey200, thickness: 1),
          if (workoutExercise.sets.isEmpty)
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
            ...workoutExercise.sets.asMap().entries.map((entry) {
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
