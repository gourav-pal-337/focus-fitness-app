import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_sliver_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';
import '../providers/exercise_provider.dart';
import '../widgets/exercise_overview_section.dart';
import '../widgets/exercise_video_section.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  const ExerciseDetailsScreen({
    super.key,
    required this.exerciseId,
    this.workoutDate,
  });

  final String exerciseId;
  final DateTime? workoutDate;

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  late final ExerciseProvider _provider;

  static const String _fallbackHeaderImageUrl =
      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800';

  @override
  void initState() {
    super.initState();
    _provider = ExerciseProvider();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch only this exercise by id to keep the screen fast.
      _provider.fetchExerciseById(widget.exerciseId);
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExerciseProvider>.value(
      value: _provider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<ExerciseProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.exercises.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: CustomButton(
                    text: 'Retry',
                    type: ButtonType.text,
                    onPressed: () => provider.fetchExerciseById(widget.exerciseId),
                    borderColor: AppColors.textPrimary,
                    textColor: AppColors.textPrimary,
                    borderRadius: 12.r,
                  ),
                ),
              );
            }

            final exercise = provider.exercises.firstWhere(
              (e) => e.id == widget.exerciseId,
              orElse: () => provider.exercises.first,
            );

            return CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                  title: exercise.name,
                  backgroundImage: exercise.imageUrl.isNotEmpty
                      ? exercise.imageUrl
                      : _fallbackHeaderImageUrl,
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
        bottomNavigationBar: Consumer<ExerciseProvider>(
          builder: (context, provider, child) {
            if (provider.exercises.isEmpty) return const SizedBox.shrink();

            final exercise = provider.exercises.firstWhere(
              (e) => e.id == widget.exerciseId,
              orElse: () => provider.exercises.first,
            );

            final workoutDateMillis =
                widget.workoutDate?.millisecondsSinceEpoch;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                child: CustomButton(
                  text: 'Add Exercise',
                  type: ButtonType.filled,
                  onPressed: () {
                    context.push(
                      '${WorkoutProgressRoute.path}?exerciseId=${exercise.id}&exerciseName=${Uri.encodeComponent(exercise.name)}${workoutDateMillis != null ? '&date=$workoutDateMillis' : ''}',
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
            );
          },
        ),
      ),
    );
  }
}

