import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/service/local_storage_service.dart';
import '../../../routes/app_router.dart';
import '../widgets/date_selector.dart';
import '../services/workout_api_service.dart';
import '../models/workout_exercise_model.dart';

class SessionLogScreen extends StatefulWidget {
  const SessionLogScreen({super.key});

  @override
  State<SessionLogScreen> createState() => _SessionLogScreenState();
}

class _SessionLogScreenState extends State<SessionLogScreen> {
  DateTime _selectedDate = DateTime.now();
  late Future<List<_SessionLogEntry>> _futureSessions;

  @override
  void initState() {
    super.initState();
    _futureSessions = _fetchSessionsForSelectedDate(_selectedDate);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _futureSessions = _fetchSessionsForSelectedDate(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Session Log',
            ),
            DateSelector(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
            SizedBox(height: AppSpacing.xl),
            Expanded(
              child: FutureBuilder<List<_SessionLogEntry>>(
                future: _futureSessions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final sessions = snapshot.data ?? const [];

                  if (sessions.isEmpty) {
                    return Center(
                      child: Text(
                        'No sessions logged for this date',
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
                    itemCount: sessions.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppColors.grey200,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return _SessionLogItem(session: session);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<_SessionLogEntry>> _fetchSessionsForSelectedDate(
    DateTime selectedDate,
  ) async {
    final normalized = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final api = WorkoutApiService();
    try {
      final workouts = await api.getWorkoutProgressByDate(normalized);
      final loggedWorkouts = workouts.where((w) => w.sets.isNotEmpty).toList();

      if (loggedWorkouts.isEmpty) return const [];

      final today = DateTime.now();
      final isToday = normalized.year == today.year &&
          normalized.month == today.month &&
          normalized.day == today.day;

      final totalExercises = loggedWorkouts.length;
      final totalSets =
          loggedWorkouts.fold<int>(0, (sum, w) => sum + w.sets.length);

      return [
        _SessionLogEntry(
          date: normalized,
          dateDisplay: isToday
              ? 'Today'
              : DateFormat('dd/MM/yyyy').format(normalized),
          timeDisplay: '04:10 PM',
          totalExercises: totalExercises,
          totalSets: totalSets,
          thumbnailUrl: loggedWorkouts.first.exerciseName.isNotEmpty
              ? 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800'
              : null,
        ),
      ];
    } catch (_) {
      // Offline fallback using the locally cached day.
      final dateKey = _dateKey(normalized);
      final cachedJson = await LocalStorageService.getWorkoutCache(dateKey);
      if (cachedJson == null || cachedJson.isEmpty) return const [];

      final decoded = jsonDecode(cachedJson);
      if (decoded is! List) return const [];

      final workouts = decoded
          .whereType<Map<String, dynamic>>()
          .map(WorkoutExerciseModel.fromJson)
          .toList();

      final loggedWorkouts =
          workouts.where((w) => w.sets.isNotEmpty).toList();
      if (loggedWorkouts.isEmpty) return const [];

      final today = DateTime.now();
      final isToday = normalized.year == today.year &&
          normalized.month == today.month &&
          normalized.day == today.day;

      final totalExercises = loggedWorkouts.length;
      final totalSets =
          loggedWorkouts.fold<int>(0, (sum, w) => sum + w.sets.length);

      return [
        _SessionLogEntry(
          date: normalized,
          dateDisplay: isToday
              ? 'Today'
              : DateFormat('dd/MM/yyyy').format(normalized),
          timeDisplay: '04:10 PM',
          totalExercises: totalExercises,
          totalSets: totalSets,
          thumbnailUrl: loggedWorkouts.first.exerciseName.isNotEmpty
              ? 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800'
              : null,
        ),
      ];
    }
  }

  String _dateKey(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
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

