import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';
import 'package:focus_fitness/core/widgets/buttons/custom_bottom.dart';
import 'package:focus_fitness/features/profile/provider/account_details_provider.dart';
import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';

class CompleteProfileDialog extends StatelessWidget {
  const CompleteProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        maxHeight: screenHeight * 0.5,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
            ),
            // Using onboarding image as placeholder since exact asset wasn't provided
            child: Image.asset(
              AppAssets.onboarding1,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                Text(
                  'Complete your profile',
                  style: AppTextStyle.text24SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Complete your profile to unlock full features.',
                  style: AppTextStyle.text14Medium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xl),
                CustomButton(
                  text: 'Complete Profile',
                  type: ButtonType.filled,
                  height: 56.h,
                  onPressed: () {
                    context.pop(); // Close dialog
                    context.push(ProfileRoute.path);
                  },
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.background,
                  borderRadius: 12.r,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.primary,
                //       padding: EdgeInsets.symmetric(vertical: 16.h),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: AppRadius.small,
                //       ),
                //       elevation: 0,
                //     ),
                //     onPressed: () {
                //       context.pop(); // Close dialog

                //       context.push(ProfileRoute.path);
                //     },
                //     child: Text(
                //       'Complete Profile',
                //       style: AppTextStyle.text16SemiBold.copyWith(
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
