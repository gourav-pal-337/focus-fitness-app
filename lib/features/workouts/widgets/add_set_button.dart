import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class AddSetButton extends StatelessWidget {
  const AddSetButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Add New Set',
      type: ButtonType.text,
      onPressed: onTap,
      borderColor: AppColors.textPrimary,
      textColor: AppColors.textPrimary,
      borderRadius: 12.r,
      textStyle: AppTextStyle.text16Regular.copyWith(color: AppColors.textPrimary),
      icon: Icon(Icons.add, size: 20.sp, color: AppColors.textPrimary),
      iconPosition: IconPosition.left,
    );
  }
}
