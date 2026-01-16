import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class SessionCancelledDialog extends StatelessWidget {
  const SessionCancelledDialog({
    super.key,
    required this.onOk,
  });

  final VoidCallback onOk;

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onOk,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.5),
      barrierDismissible: false,
      builder: (context) => SessionCancelledDialog(onOk: onOk),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding.left,
        vertical: AppSpacing.xl,
      ),
      
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.medium,
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CancellationIcon(),
                SizedBox(height: AppSpacing.xl),
                Text(
                  'Session Cancelled',
                  style: AppTextStyle.text24SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Your scheduled session with your trainer has been cancelled. A refund for this session has been processed and will be credited to your original payment method shortly.',
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xl),
                CustomButton(
                  text: 'Ok',
                  type: ButtonType.filled,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onOk();
                  },
                  width: double.infinity,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.background,
                  borderRadius: 12.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CancellationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        color:  Colors.red, // Orange-red color
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.close,
        size: 40.sp,
        color: AppColors.background,
      ),
    );
  }
}

