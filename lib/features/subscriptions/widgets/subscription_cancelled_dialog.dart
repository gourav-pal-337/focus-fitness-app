import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_info_dialog.dart';

class SubscriptionCancelledDialog {
  static Future<void> show({
    required BuildContext context,
    required VoidCallback onReactivate,
  }) {
    return CustomInfoDialog.show(
      context: context,
      title: "We're sorry to see you go",
      message: 'Your membership plan has been cancelled',
      buttonText: 'Reactivate my plan',
      onButtonPressed: onReactivate,
      // titleStyle: AppTextStyle.text24SemiBold.copyWith(
      //   color: AppColors.textPrimary,
      // ),
      // messageStyle: AppTextStyle.text14Regular.copyWith(
      //   color: AppColors.grey400,
      // ),
      buttonColor: AppColors.primary,
    );
  }
}

