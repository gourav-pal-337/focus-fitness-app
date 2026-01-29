import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';
import 'package:focus_fitness/features/authentication/provider/auth_provider.dart';
import 'package:focus_fitness/features/profile/widgets/profile_header_section.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';

class PinnedHomeHeader extends StatelessWidget {
  const PinnedHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    final user = userProvider.user;
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding.left,
        right: AppSpacing.screenPadding.right,
        top: AppSpacing.screenPadding.top,
        // bottom: AppSpacing.md,
      ),
      child: Row(
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
                user?.fullName ?? authProv.name ?? '',
                style: AppTextStyle.text24SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => context.push(NotificationsRoute.path),
                child: Stack(
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
              ),
              SizedBox(width: 16.w),
              // CircleAvatar(
              //   radius: 20.r,
              //   backgroundColor: AppColors.grey200,
              //   backgroundImage: const NetworkImage(
              //     'https://i.pravatar.cc/150?img=12',
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  context.push(ProfileRoute.path);
                },
                child: Container(
                  width: 35.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.grey75,
                  ),
                  child: user?.profilePhoto != null
                      ? ClipOval(
                          child: Image.network(
                            user!.profilePhoto!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return DefaultAvatar(size: 15.w);
                            },
                          ),
                        )
                      : DefaultAvatar(size: 15.w),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
