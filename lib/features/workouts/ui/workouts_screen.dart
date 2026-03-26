import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../providers/workout_provider.dart';
import '../../../routes/app_router.dart';
import '../models/workout_category_model.dart';
import '../widgets/date_selector.dart';
import '../widgets/empty_workout_section.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/exercise_category_card.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  DateTime _selectedDate = DateTime.now();
  late final WorkoutProvider _workoutProvider;
  String? _lastErrorMessage;

  @override
  void initState() {
    super.initState();
    _workoutProvider = WorkoutProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _workoutProvider.fetchWorkoutByDate(_selectedDate);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WorkoutProvider>.value(
      value: _workoutProvider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                onBack: () {
                  context.go(HomeRoute.path);
                },
                title: 'Workout',
                actions: [
                  IconButton(
                    onPressed: () {
                      context.push(ManualsRoute.path);
                    },
                    icon: Icon(
                      Icons.menu_book,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              DateSelector(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  debugPrint('onDateSelected 1: $date');
                  setState(() {
                    _selectedDate = date;
                  });
                  debugPrint('onDateSelected 2: $date');
                  _workoutProvider.fetchWorkoutByDate(date);
                },
              ),
              SizedBox(height: AppSpacing.xl),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<WorkoutProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return const SizedBox(
                              height: 120,
                              child: LoadingShimmer(),
                            );
                          }

                          if (provider.errorMessage != null &&
                              provider.errorMessage != _lastErrorMessage) {
                            _lastErrorMessage = provider.errorMessage;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              final msg = provider.errorMessage ?? 'Failed to load workout';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  action: SnackBarAction(
                                    label: 'Retry',
                                    onPressed: () {
                                      provider.refresh();
                                    },
                                  ),
                                ),
                              );
                            });
                          }

                          if (provider.errorMessage != null &&
                              (provider.workouts.isEmpty)) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.screenPadding.left,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Could not load workout',
                                    style: AppTextStyle.text16SemiBold.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Text(
                                    (provider.errorMessage ?? '').replaceAll("Exception: ", ""),
                                    style: AppTextStyle.text12Medium.copyWith(
                                      color: AppColors.grey400,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.md),
                                  CustomButton(
                                    text: 'Retry',
                                    type: ButtonType.text,
                                    onPressed: provider.refresh,
                                    borderColor: AppColors.textPrimary,
                                    textColor: AppColors.textPrimary,
                                    borderRadius: 12.r,
                                  ),
                                ],
                              ),
                            );
                          }

                          // // if (provider.workouts.isEmpty) {
                          //   return ;
                          // // }

                          return Column(
                            children: [
                              EmptyWorkoutSection(
                              hasData: provider.workouts.isNotEmpty,
                              onCreateTap: () {
                                context.push(
                                  '${WorkoutProgressRoute.path}?date=${_selectedDate.millisecondsSinceEpoch}',
                                ).then((value) {
                                  if (value == true) {
                                    provider.refresh();
                                  }
                                });
                              },
                              onViewLogTap: () {
                                context.push(
                                  '${SessionLogDetailsRoute.path}?date=${_selectedDate.millisecondsSinceEpoch}',
                                );
                              },
                            ),
                            SizedBox(height: AppSpacing.md),
                              _AssignedCategoriesSection(
                                provider: provider,
                                selectedDate: _selectedDate,
                              ),
                            ],
                          );
                        },
                      ),
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

class _AssignedCategoriesSection extends StatelessWidget {
  const _AssignedCategoriesSection({
    required this.provider,
    required this.selectedDate,
  });

  final WorkoutProvider provider;
  final DateTime selectedDate;

  static const String _fallbackCategoryImageUrl =
      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800';

  @override
  Widget build(BuildContext context) {
    final categories = <WorkoutCategoryModel>[];
    final seen = <String>{};

    for (final w in provider.workouts) {
      final c = w.category;
      if (c == null || c.id.isEmpty) continue;
      if (seen.add(c.id)) {
        categories.add(c);
      }
    }

    if (categories.isEmpty) {
      return Container(
        height: 200.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding.left,
        ),
        child: Text(
          'No workout today',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Exercises',
            style: AppTextStyle.text20SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 6 / 5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ExerciseCategoryCard(
                categoryName: category.name,
                imageUrl: category.imageUrl ?? _fallbackCategoryImageUrl,
                onTap: () {
                  context.push(
                    '${ExercisesRoute.path}?fromAssignedWorkout=true&categoryId=${category.id}&date=${selectedDate.millisecondsSinceEpoch}',
                  );
                },
              );
            },
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
