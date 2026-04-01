import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../workouts/providers/workout_provider.dart';
import '../../workouts/models/weekly_progress_model.dart';

class ProgressSection extends StatefulWidget {
  const ProgressSection({super.key});

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection>
    with AutomaticKeepAliveClientMixin {
  bool _showGraph = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().fetchWeeklyProgress();
    });
  }

  void _toggleView() {
    setState(() {
      _showGraph = !_showGraph;
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
              'Progress',
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
            if (provider.isWeeklyLoading) {
              return const _LoadingCard();
            }

            if (provider.errorMessage != null &&
                provider.weeklyProgress.isEmpty) {
              return _ErrorCard(
                message: provider.errorMessage!,
                onRetry: () => provider.fetchWeeklyProgress(),
              );
            }

            if (provider.weeklyProgress.isEmpty) {
              return const _EmptyProgressCard();
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _showGraph
                  ? _ProgressGraphCard(
                      progressData: provider.weeklyProgress,
                      onClose: _toggleView,
                    )
                  : _InitialProgressCard(
                      progressData: provider.weeklyProgress,
                      onShowGraph: _toggleView,
                    ),
            );
          },
        ),
      ],
    );
  }
}

class _InitialProgressCard extends StatelessWidget {
  final List<WeeklyProgressModel> progressData;
  final VoidCallback onShowGraph;

  const _InitialProgressCard({
    required this.progressData,
    required this.onShowGraph,
  });

  @override
  Widget build(BuildContext context) {
    final completedDays = progressData
        .where((d) => d.completed >= d.expected && d.expected > 0)
        .length;
    final totalExpectedDays = progressData.where((d) => d.expected > 0).length;

    return Container(
      key: const ValueKey('initial_card'),
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2070&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.grey.shade900.withOpacity(0.7),
                  Colors.grey.shade800.withOpacity(0.4),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Workout this week',
                  style: AppTextStyle.text18Medium.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$completedDays/$totalExpectedDays',
                      style: AppTextStyle.text48Bold.copyWith(
                        color: Colors.white,
                        fontSize: 64.sp,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Text(
                        'days',
                        style: AppTextStyle.text16Regular.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 16.w,
            bottom: 16.h,
            child: InkWell(
              onTap: onShowGraph,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Text(
                      'Show Graph',
                      style: AppTextStyle.text12Medium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.white,
                      size: 16.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressGraphCard extends StatelessWidget {
  final List<WeeklyProgressModel> progressData;
  final VoidCallback onClose;

  const _ProgressGraphCard({required this.progressData, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final completedDays = progressData
        .where((d) => d.completed >= d.expected && d.expected > 0)
        .length;
    final totalExpectedDays = progressData.where((d) => d.expected > 0).length;

    return Container(
      key: const ValueKey('graph_card'),
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.large,
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.large,
        child: Stack(
          children: [
            Positioned(
              right: -30.w,
              top: -30.h,
              child: Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Workout Consistency',
                            style: AppTextStyle.text14SemiBold.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Last 7 days activity',
                            style: AppTextStyle.text10Regular.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '$completedDays/$totalExpectedDays Days',
                              style: AppTextStyle.text12SemiBold.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: onClose,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18.w,
                                color: AppColors.grey500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: progressData
                        .map((day) => _DayBar(day: day))
                        .toList(),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    height: 1.h,
                    color: AppColors.grey100,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: AppColors.secondary,
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          completedDays == totalExpectedDays
                              ? "Perfect Week! Keep it up!"
                              : "You've completed $completedDays of your $totalExpectedDays scheduled sessions.",
                          style: AppTextStyle.text10Medium.copyWith(
                            color: AppColors.textSecondary,
                          ),
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
    );
  }
}

class _DayBar extends StatelessWidget {
  final WeeklyProgressModel day;

  const _DayBar({required this.day});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(day.date);
    final dayName = DateFormat('E').format(date).substring(0, 1);
    final isToday = DateUtils.isSameDay(date, DateTime.now());

    final double maxBarHeight = 60.h;
    final double currentBarHeight = (day.percent / 100.0) * maxBarHeight;
    final bool isRestDay = day.expected == 0;
    final bool isAchieved = day.percent >= 100;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 28.w,
              height: maxBarHeight,
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              width: 28.w,
              height: isRestDay
                  ? 0
                  : currentBarHeight.clamp(28.w, maxBarHeight),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isAchieved
                      ? [AppColors.green, AppColors.green.withOpacity(0.4)]
                      : [AppColors.primary, AppColors.primary.withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(6.r),
                boxShadow: [
                  if (!isRestDay)
                    BoxShadow(
                      color: (isAchieved ? AppColors.green : AppColors.primary)
                          .withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: isAchieved
                  ? Center(
                      child: Icon(Icons.check, color: Colors.white, size: 14.w),
                    )
                  : null,
            ),
            if (isRestDay)
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(
                      color: AppColors.grey200,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          dayName,
          style: AppTextStyle.text12Medium.copyWith(
            color: isToday ? AppColors.primary : AppColors.grey400,
          ),
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
      height: 220.h,
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: AppRadius.large,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
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
      height: 220.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: AppRadius.large,
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 32.w),
          SizedBox(height: 12.h),
          Text(
            "Progress stats unavailable",
            style: AppTextStyle.text14SemiBold.copyWith(
              color: Colors.red.shade900,
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}

class _EmptyProgressCard extends StatelessWidget {
  const _EmptyProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220.h,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: AppRadius.large,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, color: AppColors.grey200, size: 48.w),
          SizedBox(height: 12.h),
          Text(
            "Start working out to see your progress here",
            style: AppTextStyle.text14Medium.copyWith(color: AppColors.grey400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
