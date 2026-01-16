import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';
import 'session_card.dart';

class SessionActionButtons extends StatelessWidget {
  const SessionActionButtons({
    super.key,
    required this.session,
  });

  final SessionData session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _RateSessionButton(
          onTap: () {
            // TODO: Handle rate session
          },
        ),
      ],
    );
  }
}

class _RateSessionButton extends StatelessWidget {
  const _RateSessionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Rate your Session',
      type: ButtonType.text,
      onPressed: onTap,
      icon: Icon(
        Icons.thumb_up,
        size: 18.sp,
        color: AppColors.textPrimary,
      ),
      iconPosition: IconPosition.left,
      textColor: AppColors.textPrimary,
      textStyle: AppTextStyle.text14Medium.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }
}

