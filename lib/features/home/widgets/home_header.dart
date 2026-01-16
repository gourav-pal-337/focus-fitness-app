import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back,',
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Aman',
              style: AppTextStyle.text24SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 24.sp,
                  color: AppColors.textPrimary,
                ),
                Positioned(
                  top: -2.h,
                  right: -2.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.grey200,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/150?img=12',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

