import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class VideoProgressBar extends StatelessWidget {
  const VideoProgressBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.grey200,
            thumbColor: AppColors.primary,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
            trackHeight: 4.h,
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (duration.inMilliseconds * value).round(),
              );
              onSeek(newPosition);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: AppTextStyle.text12Regular.copyWith(
                  color: AppColors.background,
                ),
              ),
              Text(
                _formatDuration(duration),
                style: AppTextStyle.text12Regular.copyWith(
                  color: AppColors.background,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

