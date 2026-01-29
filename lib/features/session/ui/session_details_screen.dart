import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/features/session/provider/session_history_provider.dart';
import 'package:focus_fitness/features/trainer/provider/linked_trainer_provider.dart';
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

class SessionDetailsScreen extends StatefulWidget {
  const SessionDetailsScreen({super.key, required this.session});

  final SessionData session;

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = SessionDetailsProvider();
    debugPrint("Booking ID: ${widget.session.bookingId}");
    if (widget.session.bookingId != null &&
        widget.session.bookingId!.isNotEmpty) {
      provider.fetchSessionSummary(widget.session.bookingId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = SessionDetailsProvider();

        // Call fetch asynchronously only for completed sessions
        // if (widget.session.status == SessionStatus.completed &&
        //     widget.session.bookingId != null &&
        //     widget.session.bookingId!.isNotEmpty) {
        //   provider.fetchSessionSummary(widget.session.bookingId);
        // }
        return provider;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: 'Session Details'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TrainerInfoCard(session: widget.session),
                      SizedBox(height: AppSpacing.lg),
                      _DateTimeBar(session: widget.session),

                      if (widget.session.status == SessionStatus.completed &&
                          widget.session.booking?.feedback == null) ...[
                        SizedBox(height: AppSpacing.xl),
                        _SessionSummarySection(session: widget.session),
                        SizedBox(height: AppSpacing.xl),
                        _FeedbackSection(),
                        SizedBox(height: AppSpacing.xl),
                      ],
                    ],
                  ),
                ),
              ),
              _ActionButton(session: widget.session),
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
                SizedBox(height: 8.h),
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
      date: session.date,
      time: gettime(session),
      margin: EdgeInsets.zero, // No margin since parent already has padding
    );
  }
}

String gettime(SessionData session) {
  DateTime startTime = DateTime.parse(session.booking!.startTime);
  DateTime endTime = DateTime.parse(session.booking!.endTime);
  return "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";
}

class _SessionSummarySection extends StatelessWidget {
  const _SessionSummarySection({required this.session});

  final SessionData session;

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
          child: CircularProgressIndicator(color: AppColors.primary),
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
          style: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
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
          style: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
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

        // Trainer Notes
        if (session.booking?.trainerNotes != null &&
            session.booking!.trainerNotes!.isNotEmpty) ...[
          _NotesCard(
            title: 'Trainer Notes',
            notes: session.booking!.trainerNotes!,
            icon: Icons.person_outline,
          ),
          SizedBox(height: AppSpacing.md),
        ],
        // Client Notes
        if (session.booking?.notes != null &&
            session.booking!.notes!.isNotEmpty) ...[
          _NotesCard(
            title: 'Your Notes',
            notes: session.booking!.notes!,
            icon: Icons.note_outlined,
          ),
        ],
      ],
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
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: AppColors.primary),
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
              borderSide: BorderSide(color: AppColors.grey200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(color: AppColors.grey200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
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

  void bookAgain(BuildContext context) {
    debugPrint(session.booking?.trainer?.id);
    final trainerProv = context.read<LinkedTrainerProvider>();
    if (session.booking?.trainer?.id != trainerProv?.trainer?.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You are not linked with this trainer now',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      context.push(
        TrainerProfileRoute.path.replaceAll(
          ':trainerId',
          session.booking?.trainer?.id ?? '',
        ),
      );
      debugPrint('same trainer');
    }
    // trainerProv.setTrainer(session.booking?.trainer?.id);
    // TODO: Handle book again
    // context.pop();
  }

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
    final providerH = context.read<SessionHistoryProvider>();
    switch (session.status) {
      case SessionStatus.upcoming:
        return Consumer<SessionDetailsProvider>(
          builder: (context, provider, _) {
            final isCancelling = provider.isCancelling;
            return CustomButton(
              text: isCancelling ? 'Canceling...' : 'Cancel Session',
              type: ButtonType.filled,
              isLoading:
                  isCancelling ||
                  provider.isSubmittingFeedback ||
                  providerH.isLoading,
              onPressed: () {
                CancelSessionDialog.show(
                  context: context,
                  trainerName: session.trainerName,
                  onConfirm: () async {
                    if (session.bookingId != null) {
                      if (context.mounted) {
                        SessionCancelledDialog.show(
                          context: context,
                          onOk: () async {
                            await provider.cancelSession(session.bookingId!);
                            // await provider.fe;
                            await context
                                .read<SessionHistoryProvider>()
                                .fetchBookings();
                            context
                              ..pop() // Close dialog
                              ..pop()
                              ..pop(); // Close screen
                          },
                        );
                      }
                    } else {
                      context
                          .pop(); // Close dialog if no booking ID (shouldn't happen)
                    }
                  },
                );
              },
              width: double.infinity,
              backgroundColor: AppColors.primary,
              textColor: AppColors.background,
              borderRadius: 12.r,
            );
          },
        );
      case SessionStatus.completed:
        return Consumer<SessionDetailsProvider>(
          builder: (context, provider, _) {
            final hasFeedback = provider.hasFeedback;
            final isSubmitting = provider.isSubmittingFeedback;

            return CustomButton(
              text: hasFeedback ? 'Submit Feedback' : 'Book Again',
              type: ButtonType.filled,
              isLoading: isSubmitting,
              onPressed: () async {
                if (hasFeedback) {
                  if (session.bookingId != null) {
                    final success = await provider.submitFeedback(
                      session.bookingId!,
                    );
                    context.read<SessionHistoryProvider>().fetchBookings();
                    context.pop();
                    if (success && context.mounted) {
                      context.push(FeedbackSuccessRoute.path);
                    }
                  }
                } else {
                  bookAgain(context);
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
            bookAgain(context);
          },
          width: double.infinity,
          backgroundColor: AppColors.primary,
          textColor: AppColors.background,
          borderRadius: 12.r,
        );
    }
  }
}
