import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';
import '../provider/workout_provider.dart';

class SessionLogScreen extends StatelessWidget {
  const SessionLogScreen({super.key});

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
                child: Consumer<WorkoutProgressProvider>(
                  builder: (context, provider, child) {
                    final allSessions = _getAllSessions(provider);

                    if (allSessions.isEmpty) {
                      return Center(
                        child: Text(
                          'No sessions logged yet',
                          style: AppTextStyle.text16Medium.copyWith(
                            color: AppColors.grey400,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding.left,
                        vertical: AppSpacing.md,
                      ),
                      itemCount: allSessions.length,
                      separatorBuilder: (context, index) => Divider(
                        color: AppColors.grey200,
                        thickness: 1,
                      ),
                      itemBuilder: (context, index) {
                        final session = allSessions[index];
                        return _SessionLogItem(session: session);
                      },
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

  List<_SessionLogEntry> _getAllSessions(WorkoutProgressProvider provider) {
    final sessions = <_SessionLogEntry>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final allWorkoutProgress = provider.getAllWorkoutProgress();

    for (var entry in allWorkoutProgress.entries) {
      final dateKey = entry.key;
      final workoutProgressList = entry.value;

      if (workoutProgressList.isEmpty) continue;

      final dateParts = dateKey.split('-');
      if (dateParts.length != 3) continue;

      final sessionDate = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      );

      final totalExercises = workoutProgressList.length;
      final totalSets = workoutProgressList.fold<int>(
        0,
        (sum, wp) => sum + wp.sets.length,
      );

      String dateDisplay;
      if (sessionDate.year == today.year &&
          sessionDate.month == today.month &&
          sessionDate.day == today.day) {
        dateDisplay = 'Today';
      } else {
        dateDisplay = DateFormat('dd/MM/yyyy').format(sessionDate);
      }

      sessions.add(_SessionLogEntry(
        date: sessionDate,
        dateDisplay: dateDisplay,
        timeDisplay: '04:10 PM',
        totalExercises: totalExercises,
        totalSets: totalSets,
        thumbnailUrl: workoutProgressList.isNotEmpty &&
                workoutProgressList.first.exerciseName.isNotEmpty
            ? 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800'
            : null,
      ));
    }

    sessions.sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }
}

class _SessionLogEntry {
  const _SessionLogEntry({
    required this.date,
    required this.dateDisplay,
    required this.timeDisplay,
    required this.totalExercises,
    required this.totalSets,
    this.thumbnailUrl,
  });

  final DateTime date;
  final String dateDisplay;
  final String timeDisplay;
  final int totalExercises;
  final int totalSets;
  final String? thumbnailUrl;
}

class _SessionLogItem extends StatelessWidget {
  const _SessionLogItem({
    required this.session,
  });

  final _SessionLogEntry session;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '${SessionLogDetailsRoute.path}?date=${session.date.millisecondsSinceEpoch}',
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                    '${session.dateDisplay} • ${session.timeDisplay}',
                    style: AppTextStyle.text14Regular.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
            if (session.thumbnailUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  session.thumbnailUrl!,
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
      ),
    );
  }
}

