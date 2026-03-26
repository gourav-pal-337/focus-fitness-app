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
import '../models/exercise_model.dart';
import '../providers/workout_provider.dart' as api_workout_provider;
import '../providers/exercise_provider.dart';
import '../provider/workout_provider.dart' as local_workout_provider;
import '../widgets/exercise_card.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({
    super.key,
    this.fromWorkoutProgress = false,
    this.workoutDate,
    this.fromAssignedWorkout = false,
    this.assignedCategoryId,
  });

  final bool fromWorkoutProgress;
  final DateTime? workoutDate;
  final bool fromAssignedWorkout;
  final String? assignedCategoryId;

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  static const String _fallbackExerciseImageUrl =
      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800';

  late final ExerciseProvider _provider;
  late final api_workout_provider.WorkoutProvider _workoutProvider;

  @override
  void initState() {
    super.initState();
    _provider = ExerciseProvider();
    _workoutProvider = api_workout_provider.WorkoutProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromAssignedWorkout) {
        final date = widget.workoutDate ?? DateTime.now();
        _workoutProvider.fetchWorkoutByDate(date);
      } else {
        _provider.fetchCategories();
        _provider.fetchExercises();
      }
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExerciseProvider>.value(value: _provider),
        ChangeNotifierProvider<api_workout_provider.WorkoutProvider>.value(
          value: _workoutProvider,
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Exercises',
              ),
              SizedBox(height: AppSpacing.md),
              if (!widget.fromAssignedWorkout)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding.left,
                    vertical: AppSpacing.md,
                  ),
                  child: _SearchBar(provider: _provider),
                ),
              if (!widget.fromAssignedWorkout)
                _CategoryFilter(provider: _provider),
              Expanded(
                child: Consumer2<api_workout_provider.WorkoutProvider,
                    ExerciseProvider>(
                  builder: (context, workoutProvider, exerciseProvider, _) {
                    if (widget.fromAssignedWorkout) {
                      if (workoutProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final assignedCategoryId = widget.assignedCategoryId;
                      final assignedExercises = workoutProvider.workouts.where(
                        (w) =>
                            assignedCategoryId != null &&
                            w.category?.id == assignedCategoryId,
                      ).toList();

                      return assignedExercises.isEmpty
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
                                  childAspectRatio: 6 / 5,
                                ),
                                itemCount: assignedExercises.length,
                                itemBuilder: (context, index) {
                                  final item = assignedExercises[index];
                                  final dateMillis =
                                      widget.workoutDate?.millisecondsSinceEpoch;
                                  final imageUrl =
                                      item.imageUrl ??
                                          item.category?.imageUrl ??
                                          _fallbackExerciseImageUrl;

                                  return ExerciseCard(
                                    name: item.exerciseName,
                                    imageUrl: imageUrl,
                                    onTap: () {
                                      context.push(
                                        '${ExerciseDetailsRoute.path}?exerciseId=${item.exerciseId}${dateMillis != null ? '&date=$dateMillis' : ''}',
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                    }

                    if (workoutProvider.isLoading || exerciseProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final exercisesToShow = _resolveExercisesToShow(
                      workoutProvider: workoutProvider,
                      exerciseProvider: exerciseProvider,
                    );

                    return exercisesToShow.isEmpty
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
                                childAspectRatio: 6 / 5,
                              ),
                              itemCount: exercisesToShow.length,
                              itemBuilder: (context, index) {
                                final exercise = exercisesToShow[index];
                                return ExerciseCard(
                                  name: exercise.name,
                                  imageUrl: exercise.imageUrl,
                                  onTap: () {
                                    final dateMillis =
                                        widget.workoutDate?.millisecondsSinceEpoch;

                                    if (widget.fromWorkoutProgress &&
                                        widget.workoutDate != null) {
                                      final workoutProgressProvider =
                                          local_workout_provider
                                              .WorkoutProgressProvider();
                                      workoutProgressProvider.addExerciseToWorkout(
                                        widget.workoutDate!,
                                        local_workout_provider.Exercise(
                                          id: exercise.id,
                                          name: exercise.name,
                                          imageUrl: exercise.imageUrl,
                                        ),
                                      );
                                      context.pop();
                                      return;
                                    }

                                    context.push(
                                      '${ExerciseDetailsRoute.path}?exerciseId=${exercise.id}${dateMillis != null ? '&date=$dateMillis' : ''}',
                                    );
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

  List<ExerciseModel> _resolveExercisesToShow({
    required api_workout_provider.WorkoutProvider workoutProvider,
    required ExerciseProvider exerciseProvider,
  }) {
    if (!widget.fromAssignedWorkout) {
      return exerciseProvider.exercises;
    }

    final assignedCategoryId = widget.assignedCategoryId;
    final assigned = workoutProvider.workouts.where((w) {
      final cId = w.category?.id;
      return cId != null &&
          assignedCategoryId != null &&
          cId == assignedCategoryId;
    }).toList();

    final exercisesById = <String, ExerciseModel>{};
    for (final e in exerciseProvider.exercises) {
      exercisesById[e.id] = e;
    }

    final result = <ExerciseModel>[];
    for (final w in assigned) {
      final match = exercisesById[w.exerciseId];
      if (match != null) result.add(match);
    }
    return result;
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.provider});

  final ExerciseProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey75,
        borderRadius: AppRadius.medium,
      ),
      child: TextField(
        onChanged: (value) {
          provider.searchExercises(value);
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

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.provider});

  final ExerciseProvider provider;

  @override
  Widget build(BuildContext context) {
    final categories = provider.categories;
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = provider.selectedCategory == category;
          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) {
              provider.setCategory(isSelected ? null : category);
            },
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: AppSpacing.xs),
        itemCount: categories.length,
      ),
    );
  }
}

