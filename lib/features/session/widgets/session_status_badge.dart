import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'session_card.dart';

class SessionStatusBadge extends StatelessWidget {
  const SessionStatusBadge({
    super.key,
    required this.status,
  });

  final SessionStatus status;

  Color get _backgroundColor {
    switch (status) {
      case SessionStatus.cancelled:
        return const Color(0xFFFF6B6B); // Light red
      case SessionStatus.completed:
        return const Color(0xFF51CF66); // Light green
      case SessionStatus.upcoming:
        return AppColors.primary;
    }
  }

  String get _label {
    switch (status) {
      case SessionStatus.cancelled:
        return 'Cancelled';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.upcoming:
        return 'Upcoming';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor.withValues( alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        _label,
        style: AppTextStyle.text10SemiBold.copyWith(
          color: _backgroundColor,
        ),
      ),
    );
  }
}

