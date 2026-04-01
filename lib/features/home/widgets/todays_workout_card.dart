import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';
import '../../workouts/models/today_workout_summary_model.dart';
import '../../workouts/providers/workout_provider.dart';

class TodaysWorkoutSection extends StatefulWidget {
  const TodaysWorkoutSection({super.key});

  @override
  State<TodaysWorkoutSection> createState() => _TodaysWorkoutSectionState();
}

class _TodaysWorkoutSectionState extends State<TodaysWorkoutSection> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().fetchTodaySummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Today's Workout",
              style: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(height: 1.h, color: AppColors.grey200),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Consumer<WorkoutProvider>(
          builder: (context, provider, child) {
            if (provider.isSummaryLoading) {
              return const _LoadingCard();
            }

            if (provider.errorMessage != null && provider.todaySummary == null) {
              return _ErrorCard(
                message: provider.errorMessage!,
                onRetry: () => provider.fetchTodaySummary(),
              );
            }

            final summary = provider.todaySummary;
            if (summary == null) {
              return const _NoPlanCard();
            }

            if (!summary.hasWorkout) {
              if (summary.planName != null) {
                return _RestDayCard(message: summary.message);
              }
              return const _NoPlanCard();
            }

            return _HasWorkoutCard(summary: summary);
          },
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 116.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteBlue.withOpacity(0.5),
        borderRadius: AppRadius.large,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: AppRadius.large,
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          Text(
            "Couldn't load today's workout",
            style: AppTextStyle.text14SemiBold.copyWith(color: Colors.red.shade900),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class _HasWorkoutCard extends StatelessWidget {
  final TodayWorkoutSummaryModel summary;

  const _HasWorkoutCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final isCompleted = summary.status == 'completed';
    final isInProgress = summary.status == 'in_progress';
    final progress = (summary.progress ?? 0) / 100.0;

    return GestureDetector(
      onTap: () {
        context.push(WorkoutProgressRoute.path);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.large,
          boxShadow: [
            BoxShadow(
              color: (isCompleted ? AppColors.green : AppColors.secondary)
                  .withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.large,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.greenLight
                      : AppColors.background,
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.green.withOpacity(0.2)
                        : AppColors.grey100,
                  ),
                  borderRadius: AppRadius.large,
                ),
                child: Row(
                  children: [
                    _WorkoutImage(
                      imageUrl: summary.thumbnail,
                      isCompleted: isCompleted,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  summary.planName ?? 'Your Plan',
                                  style: AppTextStyle.text10SemiBold.copyWith(
                                    color: (isCompleted
                                            ? AppColors.green
                                            : AppColors.secondary)
                                        .withOpacity(0.7),
                                    letterSpacing: 0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isInProgress)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: AppTextStyle.text10SemiBold.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            summary.title ?? 'Workout Title',
                            style: AppTextStyle.text16SemiBold.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppSpacing.md),
                          _ProgressBar(
                            progress: progress,
                            isCompleted: isCompleted,
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${summary.completedSets ?? 0}/${summary.totalSets ?? 0} Sets',
                                style: AppTextStyle.text10Medium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${summary.progress ?? 0}% Done',
                                style: AppTextStyle.text10SemiBold.copyWith(
                                  color: isCompleted
                                      ? AppColors.green
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 12.w),
                        SizedBox(width: 4.w),
                        Text(
                          'DONE',
                          style: AppTextStyle.text10SemiBold.copyWith(
                            color: Colors.white,
                          ),
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

class _RestDayCard extends StatelessWidget {
  final String? message;

  const _RestDayCard({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.whiteBlue.withOpacity(0.4),
            AppColors.whiteBlue.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.whiteBlue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            height: 54.w,
            width: 54.w,
            decoration: BoxDecoration(
              color: AppColors.whiteBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.spa_rounded,
              color: AppColors.secondary,
              size: 28.w,
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Time to Recover",
                  style: AppTextStyle.text16SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  message ?? "Take a breather! Proper rest is just as important as the workout itself.",
                  style: AppTextStyle.text12Regular.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NoPlanCard extends StatelessWidget {
  const _NoPlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.whiteBlue.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              color: AppColors.grey400,
              size: 32.w,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            "Ready to start your journey?",
            style: AppTextStyle.text16Medium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            "Contact your coach to receive your personalized training and nutrition plan.",
            style: AppTextStyle.text12Regular.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.mail_outline, size: 18.w),
            label: const Text("Message Coach"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTextStyle.text14SemiBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutImage extends StatelessWidget {
  final String? imageUrl;
  final bool isCompleted;

  const _WorkoutImage({this.imageUrl, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76.w,
      height: 76.w,
      decoration: BoxDecoration(
        borderRadius: AppRadius.medium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.medium,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholder();
                },
              )
            else
              _buildPlaceholder(),
            if (isCompleted)
              Container(
                color: AppColors.green.withOpacity(0.4),
                child: const Center(
                  child: Icon(
                    Icons.done_all_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.grey100,
      child: Icon(
        Icons.fitness_center_rounded,
        color: AppColors.grey300,
        size: 30.w,
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final bool isCompleted;

  const _ProgressBar({required this.progress, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 8.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              height: 8.h,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isCompleted
                      ? [AppColors.green, AppColors.green.withOpacity(0.8)]
                      : [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: (isCompleted ? AppColors.green : AppColors.primary)
                        .withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
