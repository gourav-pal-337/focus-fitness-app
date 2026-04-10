import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../profile/provider/client_profile_provider.dart';
import '../../session/provider/session_history_provider.dart';
import '../../trainer/provider/linked_trainer_provider.dart';
import '../../trainer/provider/trainer_profile_provider.dart';

class HomeNudgeSection extends StatefulWidget {
  const HomeNudgeSection({super.key});

  @override
  State<HomeNudgeSection> createState() => _HomeNudgeSectionState();
}

class _HomeNudgeSectionState extends State<HomeNudgeSection> {
  String? _cachedQuote;
  String? _cachedMessage;
  bool _hasInitializedContent = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final sessionHistory =
        Provider.of<SessionHistoryProvider>(context, listen: false);
    final linkedTrainer =
        Provider.of<LinkedTrainerProvider>(context, listen: false);

    await sessionHistory.fetchBookings();

    if (linkedTrainer.isLinked && linkedTrainer.trainer != null) {
      final today = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(today);
      final tomorrowStr = DateFormat('yyyy-MM-dd').format(
        today.add(const Duration(days: 1)),
      );

      final hasSession = sessionHistory.allBookings.any((booking) {
        final bookingDate = booking.startTime.split('T')[0];
        return (bookingDate == todayStr || bookingDate == tomorrowStr) &&
            booking.status.toLowerCase() != 'cancelled';
      });

      if (!hasSession) {
        // Fetch trainer profile to get availability
        final trainerProfile =
            Provider.of<TrainerProfileProvider>(context, listen: false);
        await trainerProfile.fetchTrainerProfile(linkedTrainer.trainer!.id);
      }
    }
  }

  void _generateContent(
    SessionHistoryProvider sessionHistory,
    TrainerProfileProvider trainerProfile,
    String todayStr,
    String tomorrowStr,
  ) {
    if (_hasInitializedContent && !sessionHistory.isLoading && !trainerProfile.isLoading) return;

    // 1. Check for session today or tomorrow
    bool hasUpcoming = sessionHistory.allBookings.any((booking) {
      final bookingDate = booking.startTime.split('T')[0];
      return (bookingDate == todayStr || bookingDate == tomorrowStr) &&
          booking.status.toLowerCase() != 'cancelled';
    });

    // Random Message Variants
    final sessionMessages = [
      'are you ready for our session?',
      'let\'s get ready for our next workout!',
      'see you soon for our session!',
      'ready to smash another workout together?',
    ];

    final suggestionMessages = [
      'should we have a workout at {time} {day}?',
      'how about a session at {time} {day}?',
      'let\'s smash a workout at {time} {day}!',
      'why don\'t we train at {time} {day}?',
    ];

    String message;
    if (hasUpcoming) {
      message = sessionMessages[DateTime.now().millisecondsSinceEpoch % sessionMessages.length];
    } else {
      final availability = trainerProfile.availability;
      if (availability.isNotEmpty) {
        final nextDay = availability.firstWhere(
          (day) => day.availableSlots.isNotEmpty,
          orElse: () => availability.first,
        );

        if (nextDay.availableSlots.isNotEmpty) {
          final nextSlot = nextDay.availableSlots.first;
          final startTime = DateTime.parse(nextSlot.startTime);
          final timeStr = DateFormat('h:mm a').format(startTime);
          final isToday = nextDay.date == todayStr;
          final dayStr = isToday ? 'today' : 'on ${DateFormat('EEEE').format(startTime)}';

          final template = suggestionMessages[DateTime.now().millisecondsSinceEpoch % suggestionMessages.length];
          message = template.replaceAll('{time}', timeStr).replaceAll('{day}', dayStr);
        } else {
          message = "Consistency is the key to success. Let's keep going!";
        }
      } else {
        message = "Consistency is the key to success. Let's keep going!";
      }
    }

    final quotes = [
      'STAY CONSISTENT',
      'PUSH YOUR LIMITS',
      'NO EXCUSES',
      'KEEP GROWING',
      'YOU\'VE GOT THIS',
      'BELIEVE IN YOURSELF',
      'MAKE IT HAPPEN',
      'TRAIN LIKE A PRO',
      'STAY FOCUSED',
      'WORK HARD',
    ];

    final quote = quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];

    _cachedQuote = quote;
    _cachedMessage = message;
    _hasInitializedContent = true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LinkedTrainerProvider, SessionHistoryProvider,
        TrainerProfileProvider>(
      builder: (context, trainerProvider, sessionHistory, trainerProfile, _) {
        if (!trainerProvider.isLinked || trainerProvider.trainer == null) {
          return const SizedBox.shrink();
        }

        if (sessionHistory.isLoading || trainerProfile.isLoading) {
          return const _LoadingNudge();
        }

        final trainer = trainerProvider.trainer!;
        final today = DateTime.now();
        final todayStr = DateFormat('yyyy-MM-dd').format(today);
        final tomorrowStr = DateFormat('yyyy-MM-dd').format(
          today.add(const Duration(days: 1)),
        );

        // Get User Name for personalization
        final userProfile = Provider.of<ClientProfileProvider>(context);
        final profileClient = userProfile.profile;
        final userName = profileClient?.fullName?.split(' ').first ?? 'there';

        // Stabilize content only on initial load or data changes
        _generateContent(sessionHistory, trainerProfile, todayStr, tomorrowStr);

        if (_cachedQuote == null || _cachedMessage == null) {
          return const SizedBox.shrink();
        }

        return _NudgeCard(
          trainerName: trainer.fullName ?? 'Trainer',
          trainerImageUrl: trainer.profilePhoto,
          userName: userName,
          message: _cachedMessage!,
          quote: _cachedQuote!,
        );
      },
    );
  }
}

class _NudgeCard extends StatelessWidget {
  final String trainerName;
  final String? trainerImageUrl;
  final String userName;
  final String message;
  final String quote;

  const _NudgeCard({
    required this.trainerName,
    this.trainerImageUrl,
    required this.userName,
    required this.message,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulseAvatar(imageUrl: trainerImageUrl),
          SizedBox(height: 20.h),
          Text(
            quote,
            style: AppTextStyle.text12Bold.copyWith(
              color: AppColors.primary,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Hi $userName, $message',
              textAlign: TextAlign.center,
              style: AppTextStyle.text18SemiBold.copyWith(
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseAvatar extends StatefulWidget {
  final String? imageUrl;
  const _PulseAvatar({this.imageUrl});

  @override
  State<_PulseAvatar> createState() => _PulseAvatarState();
}

class _PulseAvatarState extends State<_PulseAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(4.r + (4 * _animation.value)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.1 + (0.4 * _animation.value)),
              width: 2,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2 * _animation.value),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 45.r,
              backgroundColor: AppColors.grey200,
              backgroundImage: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                  ? NetworkImage(widget.imageUrl!)
                  : null,
              child: widget.imageUrl == null || widget.imageUrl!.isEmpty
                  ? Icon(Icons.person, color: AppColors.grey400, size: 40.r)
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _LoadingNudge extends StatelessWidget {
  const _LoadingNudge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}
