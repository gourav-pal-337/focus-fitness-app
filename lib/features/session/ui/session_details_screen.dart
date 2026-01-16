import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import '../../../core/widgets/date_time_bar.dart';
import '../../../../routes/app_router.dart';
import '../provider/session_details_provider.dart';
import '../widgets/session_card.dart' show SessionData, SessionStatus;
import '../widgets/session_status_badge.dart';
import '../widgets/cancel_session_dialog.dart';
import '../widgets/session_cancelled_dialog.dart';
import '../data/models/session_summary_response_model.dart';

class SessionDetailsScreen extends StatelessWidget {
  const SessionDetailsScreen({
    super.key,
    required this.session,
  });

  final SessionData session;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = SessionDetailsProvider();
        // Call fetch asynchronously only for completed sessions
        if (session.status == SessionStatus.completed && 
            session.bookingId != null && 
            session.bookingId!.isNotEmpty) {
          provider.fetchSessionSummary(session.bookingId);
        }
        return provider;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Session Details',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TrainerInfoCard(session: session),
                      SizedBox(height: AppSpacing.lg),
                      _DateTimeBar(session: session),
                      if (session.status == SessionStatus.completed) ...[
                        SizedBox(height: AppSpacing.xl),
                        _SessionSummarySection(),
                        SizedBox(height: AppSpacing.xl),
                        _FeedbackSection(),
                        SizedBox(height: AppSpacing.xl),
                      ],
                    ],
                  ),
                ),
              ),
              _ActionButton(session: session),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainerInfoCard extends StatelessWidget {
  const _TrainerInfoCard({required this.session});

  final SessionData session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: NetworkImage(session.trainerImageUrl),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.trainerName,
                  style: AppTextStyle.text16SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${session.sessionType} • ${session.duration}',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
                SizedBox(height: 4.h),
                SessionStatusBadge(status: session.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimeBar extends StatelessWidget {
  const _DateTimeBar({required this.session});

  final SessionData session;

  @override
  Widget build(BuildContext context) {
    // Parse date to get day of week - for now using mock data
    // In real app, parse the date string to get day of week
    return DateTimeBar(
      date: 'Monday Jun 9, 2025',
      time: '7:00 - 7:30 am',
      margin: EdgeInsets.zero, // No margin since parent already has padding
    );
  }
}

class _SessionSummarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionDetailsProvider>();
    final summary = provider.summary;
    final isLoading = provider.isLoadingSummary;
    final error = provider.summaryError;

    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (error != null && error.isNotEmpty) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.grey200.withOpacity(0.3),
          borderRadius: AppRadius.medium,
        ),
        child: Text(
          error,
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.grey400,
          ),
        ),
      );
    }

    if (summary == null) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.grey200.withOpacity(0.3),
          borderRadius: AppRadius.medium,
        ),
        child: Text(
          'Session summary not available yet',
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.grey400,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Summary',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        // Performance Metrics
        if (summary.performance != null || summary.weight != null) ...[
          _PerformanceMetricsCard(summary: summary),
          SizedBox(height: AppSpacing.md),
        ],
        // Exercises
        if (summary.exercises != null && summary.exercises!.isNotEmpty) ...[
          Text(
            'Exercises',
            style: AppTextStyle.text14SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          ...summary.exercises!.map((exercise) => _ExerciseCard(exercise: exercise)),
          SizedBox(height: AppSpacing.md),
        ],
        // Trainer Notes
        if (summary.trainerNotes != null && summary.trainerNotes!.isNotEmpty) ...[
          _NotesCard(
            title: 'Trainer Notes',
            notes: summary.trainerNotes!,
            icon: Icons.person_outline,
          ),
          SizedBox(height: AppSpacing.md),
        ],
        // Client Notes
        if (summary.clientNotes != null && summary.clientNotes!.isNotEmpty) ...[
          _NotesCard(
            title: 'Your Notes',
            notes: summary.clientNotes!,
            icon: Icons.note_outlined,
          ),
        ],
      ],
    );
  }
}

class _PerformanceMetricsCard extends StatelessWidget {
  const _PerformanceMetricsCard({required this.summary});

  final SessionSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (summary.weight != null) ...[
            Expanded(
              child: _MetricItem(
                label: 'Weight',
                value: '${summary.weight!.toStringAsFixed(1)} kg',
                icon: Icons.monitor_weight_outlined,
              ),
            ),
            if (summary.performance != null) ...[
              SizedBox(width: AppSpacing.md),
              Container(
                width: 1,
                height: 40.h,
                color: AppColors.grey200,
              ),
              SizedBox(width: AppSpacing.md),
            ],
          ],
          if (summary.performance != null) ...[
            if (summary.performance!.sets != null)
              Expanded(
                child: _MetricItem(
                  label: 'Sets',
                  value: '${summary.performance!.sets}',
                  icon: Icons.repeat_outlined,
                ),
              ),
            if (summary.performance!.reps != null) ...[
              SizedBox(width: AppSpacing.md),
              Container(
                width: 1,
                height: 40.h,
                color: AppColors.grey200,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MetricItem(
                  label: 'Reps',
                  value: '${summary.performance!.reps}',
                  icon: Icons.fitness_center_outlined,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24.sp,
          color: AppColors.primary,
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyle.text12Regular.copyWith(
            color: AppColors.grey400,
          ),
        ),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.exercise});

  final ExerciseSummary exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: AppTextStyle.text14SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (exercise.sets != null ||
              exercise.reps != null ||
              exercise.weight != null ||
              exercise.duration != null) ...[
            SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xs,
              children: [
                if (exercise.sets != null)
                  _ExerciseDetailChip(
                    label: 'Sets',
                    value: '${exercise.sets}',
                  ),
                if (exercise.reps != null)
                  _ExerciseDetailChip(
                    label: 'Reps',
                    value: '${exercise.reps}',
                  ),
                if (exercise.weight != null)
                  _ExerciseDetailChip(
                    label: 'Weight',
                    value: '${exercise.weight!.toStringAsFixed(1)} kg',
                  ),
                if (exercise.duration != null)
                  _ExerciseDetailChip(
                    label: 'Duration',
                    value: '${(exercise.duration! / 60).toStringAsFixed(0)} min',
                  ),
              ],
            ),
          ],
          if (exercise.notes != null && exercise.notes!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              exercise.notes!,
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExerciseDetailChip extends StatelessWidget {
  const _ExerciseDetailChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey200.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyle.text12Regular.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({
    required this.title,
    required this.notes,
    required this.icon,
  });

  final String title;
  final String notes;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.medium,
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: AppTextStyle.text14SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            notes,
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We would love to hear from you',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        _StarRating(),
        SizedBox(height: AppSpacing.lg),
        _FeedbackTextField(),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionDetailsProvider>();
    final rating = provider.rating;

    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            context.read<SessionDetailsProvider>().setRating(index + 1);
          },
          child: Padding(
            padding: EdgeInsets.only(right: AppSpacing.xs),
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              size: 32.sp,
              color: index < rating ? Colors.amber : AppColors.grey400,
            ),
          ),
        );
      }),
    );
  }
}

class _FeedbackTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 4.h),
        TextField(
          onChanged: (value) {
            context.read<SessionDetailsProvider>().setFeedback(value);
          },
          
          maxLines: 6,
          decoration: InputDecoration(
            labelText: 'Feedback',
            hintText: 'Write your Feedback here',
            hintStyle: AppTextStyle.text14Regular.copyWith(
              color: AppColors.grey400,
            ),
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(
                color: AppColors.grey200,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(
                color: AppColors.grey200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.all(AppSpacing.md),
          ),
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.session});

  final SessionData session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.screenPadding.left),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey400.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (session.status) {
      case SessionStatus.upcoming:
        return CustomButton(
          text: 'Cancel Session',
          type: ButtonType.filled,
          onPressed: () {
            CancelSessionDialog.show(
              context: context,
              trainerName: session.trainerName,
              onConfirm: () {
                // Show success dialog after cancellation
                SessionCancelledDialog.show(
                  context: context,
                  onOk: () {
                    // TODO: Handle session cancellation completion
                    context.pop();
                  },
                );
              },
            );
          },
          width: double.infinity,
          backgroundColor: AppColors.primary,
          textColor: AppColors.background,
          borderRadius: 12.r,
        );
      case SessionStatus.completed:
        return Consumer<SessionDetailsProvider>(
          builder: (context, provider, _) {
            final hasFeedback = provider.hasFeedback;
            return CustomButton(
              text: hasFeedback ? 'Submit Feedback' : 'Book Again',
              type: ButtonType.filled,
              onPressed: () {
                if (hasFeedback) {
                  // Navigate to feedback success screen
                  context.push(FeedbackSuccessRoute.path);
                } else {
                  // TODO: Handle book again
                  context.pop();
                }
              },
              width: double.infinity,
              backgroundColor: AppColors.primary,
              textColor: AppColors.background,
              borderRadius: 12.r,
            );
          },
        );
      case SessionStatus.cancelled:
        return CustomButton(
          text: 'Book Again',
          type: ButtonType.filled,
          onPressed: () {
            // TODO: Handle book again
            context.pop();
          },
          width: double.infinity,
          backgroundColor: AppColors.primary,
          textColor: AppColors.background,
          borderRadius: 12.r,
        );
    }
  }
}

