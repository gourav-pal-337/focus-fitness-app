import 'package:flutter/material.dart';
import 'package:focus_fitness/core/widgets/show_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';

import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
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
    // final authProv = Provider.of<ClientProfileProvider>(context, listen: false);

    // final userProvider = Provider.of<UserProvider>(context, listen: false);

    // final user = userProvider.user;

    return Consumer2<ClientProfileProvider, UserProvider>(
      builder: (context, authProv, userProvider, _) {
        final user = userProvider.user;
        print("user: ${user?.fullName}");
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
                    user?.fullName ?? authProv.profile?.fullName ?? '',
                    style: AppTextStyle.text24SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(NotificationsRoute.path);
                    },
                    child: Badge(
                      isLabelVisible: false,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 24.sp,
                        color: AppColors.textPrimary,
                      ),
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
                      child: ShowImage(
                        imageUrl: user?.profilePicture,
                        width: 35.w,
                        height: 35.w,
                        isCircle: true,
                        errorWidget: DefaultAvatar(size: 15.w),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
