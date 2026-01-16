import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';
import '../widgets/date_selector.dart';
import '../widgets/empty_workout_section.dart';
import '../widgets/exercise_category_card.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  DateTime _selectedDate = DateTime.now();

  static final List<_ExerciseCategory> _exerciseCategories = [
    _ExerciseCategory(
      name: 'Upper Body',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800',
    ),
    _ExerciseCategory(
      name: 'Lower Body',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800',
    ),
    _ExerciseCategory(
      name: 'Push',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
    ),
    _ExerciseCategory(
      name: 'Pull',
      imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800',
    ),
    _ExerciseCategory(
      name: 'Core',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
    ),
    _ExerciseCategory(
      name: 'Full Body',
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
             CustomAppBar(
                onBack: () {
                  context.go(HomeRoute.path);
                },
              title: 'Workout',
            ),
            DateSelector(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            SizedBox(height: AppSpacing.xl),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EmptyWorkoutSection(
                      onCreateTap: () {
                        context.push(WorkoutProgressRoute.path);
                      },
                      onViewLogTap: () {
                        context.push(SessionLogRoute.path);
                      },
                    ),
                    SizedBox(height: AppSpacing.xl),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding.left,
                      ),
                      child: Text(
                        'Add Exercises',
                        style: AppTextStyle.text20SemiBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding.left,
                      ),
                      child: _ExerciseCategoryGrid(),
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
}

class _ExerciseCategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        // mainAxisExtent: 100.h,
        // aspectRatio: 1.0,
        childAspectRatio: 6/5,
      ),
      itemCount: _WorkoutsScreenState._exerciseCategories.length,
      itemBuilder: (context, index) {
        final category = _WorkoutsScreenState._exerciseCategories[index];
        return ExerciseCategoryCard(
          categoryName: category.name,
          imageUrl: category.imageUrl,
          onTap: () {
            context.push(ExercisesRoute.path);
          },
        );
      },
    );
  }
}

class _ExerciseCategory {
  const _ExerciseCategory({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;
}
