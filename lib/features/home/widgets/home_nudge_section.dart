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
  int? _quoteIndex;
  int? _messageIndex;
  bool _previousSessionLoading = true;
  bool _hasFetchedForLinkedTrainer = false;

  @override
  void initState() {
    super.initState();
    // _fetchData();
  }

  Future<void> _fetchData() async {
    final sessionHistory = Provider.of<SessionHistoryProvider>(
      context,
      listen: false,
    );

    // Initial fetch for bookings. We rely on build() to catch the trainer fetch
    // once the LinkedTrainer details arrive.
    await sessionHistory.fetchBookings();
  }

  String _generateMessage(
    bool hasUpcoming,
    TrainerProfileProvider trainerProfile,
    String todayStr,
    String tomorrowStr,
  ) {
    final sessionMessages = [
      'are you ready for our session?',
      'let\'s get ready for our next workout!',
      'see you soon for our session!',
      'ready to smash another workout together?',
      'Are you ready for your Focus Fusion session?',
      'Focus Fusion is waiting! Are you ready?',
      'Ready to push the limits today?',
      'Let\'s make this next session count!',
      'Another session, another step forward. Ready?',
      'Prepare your gear—it\'s almost go-time!',
    ];

    final suggestionMessages = [
      'should we have a workout at {time} {day}?',
      'how about a session at {time} {day}?',
      'let\'s smash a workout at {time} {day}!',
      'why don\'t we train at {time} {day}?',
      'Should we have a Focus Fusion workout at {time} {day}?',
      'Time to ignite your focus! Session at {time} {day}?',
      'How about we crush a session at {time} {day}?',
      'Let\'s find your focus at {time} {day}.',
      'Ready to Fusion your workout at {time} {day}?',
      'Stay ahead of your goals! Train at {time} {day}?',
    ];

    final fallbacks = [
      'consistency is the key to success. Let\'s keep going!',
      'your goals don\'t care how you feel. Show up and work hard!',
      'small steps every day lead to big results. Stay focused!',
      'every workout counts. Don\'t stop until you\'re proud!',
      'progress over perfection. Let\'s make today count!',
      'Stay focused with Focus Fusion. Consistency is the key to success!',
      'Progress over perfection. Make today count with Focus Fusion!',
      'Fuel your focus and achieve greatness today!',
      'The only bad workout is the one that didn\'t happen.',
      'Motivation gets you started. Habit keeps you going.',
      'Focus Fusion: Where sweat becomes strength.',
      'Don\'t count the days, make the days count.',
      'Convince your mind, and your body will follow!',
      'Action is the foundational key to all success.',
      'A one-hour workout is only 4% of your day. No excuses!',
      'The hard part is training your mind. Let\'s do it!',
      'Everything you want is on the other side of hard work.',
      'Be stronger than your strongest excuse today!',
      'Success starts with self-discipline. Stay focused!',
      'Your future self will thank you for today\'s effort.',
    ];

    if (hasUpcoming) {
      _messageIndex ??= DateTime.now().millisecondsSinceEpoch;
      return sessionMessages[_messageIndex! % sessionMessages.length];
    } else {
      final nextSlot = trainerProfile.nextAvailableSlot;
      if (nextSlot != null) {
        final startTime = DateTime.parse(nextSlot.startTime).toLocal();
        final timeStr = DateFormat('h:mm a').format(startTime);

        final isToday = nextSlot.date == todayStr;
        final isTomorrow = nextSlot.date == tomorrowStr;

        final String dayStr;
        if (isToday) {
          dayStr = 'today';
        } else if (isTomorrow) {
          dayStr = 'tomorrow';
        } else {
          dayStr = 'on ${DateFormat('EEEE').format(startTime)}';
        }

        _messageIndex ??= DateTime.now().millisecondsSinceEpoch;
        final template =
            suggestionMessages[_messageIndex! % suggestionMessages.length];

        return template
            .replaceAll('{time}', timeStr)
            .replaceAll('{day}', dayStr);
      } else {
        _messageIndex ??= DateTime.now().millisecondsSinceEpoch;
        return fallbacks[_messageIndex! % fallbacks.length];
      }
    }
  }

  String _generateQuote() {
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

    _quoteIndex ??= DateTime.now().millisecondsSinceEpoch;
    return quotes[_quoteIndex! % quotes.length];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      LinkedTrainerProvider,
      SessionHistoryProvider,
      TrainerProfileProvider
    >(
      builder: (context, trainerProvider, sessionHistory, trainerProfile, _) {
        final isLinked =
            trainerProvider.isLinked && trainerProvider.trainer != null;

        // if (isLinked) {
        //   bool shouldFetch = false;

        //   // 1. Have we ever fetched for this trainer? If the provider just loaded asynchronously, we catch it here.
        //   if (!_hasFetchedForLinkedTrainer) {
        //     _hasFetchedForLinkedTrainer = true;
        //     shouldFetch = true;
        //   }

        //   // 2. Did the user pull-to-refresh on the Home screen? (session history went from loading -> done)
        //   if (_previousSessionLoading && !sessionHistory.isLoading) {
        //     shouldFetch = true;
        //   }

        //   if (shouldFetch) {
        //     // WidgetsBinding.instance.addPostFrameCallback((_) {
        //     //   trainerProfile.fetchTrainerProfile(trainerProvider.trainer!.id);
        //     //   trainerProfile.fetchNextAvailableSlot(
        //     //     trainerProvider.trainer!.id,
        //     //   );
        //     // });
        //   }
        // }

        // Delaying state update until end of build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _previousSessionLoading = sessionHistory.isLoading;
          }
        });

        if (!isLinked) {
          return const SizedBox.shrink();
        }

        if (sessionHistory.isLoading ||
            trainerProfile.isLoadingNextSlot ||
            trainerProfile.isLoading) {
          return const _LoadingNudge();
        }

        final trainer = trainerProvider.trainer!;
        final today = DateTime.now();
        final todayStr = DateFormat('yyyy-MM-dd').format(today);
        final tomorrowStr = DateFormat(
          'yyyy-MM-dd',
        ).format(today.add(const Duration(days: 1)));

        // Get User Name for personalization
        final userProfile = Provider.of<ClientProfileProvider>(context);
        final profileClient = userProfile.profile;
        final userName = profileClient?.fullName?.split(' ').first ?? 'there';

        bool hasUpcoming = sessionHistory.allBookings.any((booking) {
          final bookingDate = booking.startTime.split('T')[0];
          return (bookingDate == todayStr || bookingDate == tomorrowStr) &&
              booking.status.toLowerCase() != 'cancelled';
        });

        final message = _generateMessage(
          hasUpcoming,
          trainerProfile,
          todayStr,
          tomorrowStr,
        );
        final quote = _generateQuote();

        return _NudgeCard(
          trainerName: trainer.fullName ?? 'Trainer',
          trainerImageUrl: trainer.profilePhoto,
          userName: userName,
          message: message,
          quote: quote,
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
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
              color: AppColors.primary.withValues(
                alpha: 0.1 + (0.4 * _animation.value),
              ),
              width: 2,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: 0.2 * _animation.value,
                  ),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 45.r,
              backgroundColor: AppColors.grey200,
              backgroundImage:
                  widget.imageUrl != null && widget.imageUrl!.isNotEmpty
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
      child: const Center(child: CircularProgressIndicator(strokeWidth: 3)),
    );
  }
}
