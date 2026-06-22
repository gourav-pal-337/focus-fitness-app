import 'package:flutter/material.dart';
import 'package:focus_fitness/core/widgets/show_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/app_features_provider.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';

import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
import 'package:focus_fitness/features/profile/widgets/profile_header_section.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/loading/background_refresh_indicator.dart';
import '../../trainer/provider/linked_trainer_provider.dart';
import '../../../routes/app_router.dart';

class PinnedHomeHeader extends StatelessWidget {
  const PinnedHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      ClientProfileProvider,
      UserProvider,
      LinkedTrainerProvider
    >(
      builder: (context, authProv, userProvider, trainerProvider, _) {
        final user = userProvider.user;
        final isRefreshing =
            (userProvider.isLoading && user != null) ||
            (trainerProvider.isLoading && trainerProvider.trainer != null);

        final displayName =
            [
              user?.forename,
              authProv.profile?.forename,
              user?.fullName,
              authProv.profile?.fullName,
            ].firstWhere(
              (name) => name != null && name.trim().isNotEmpty,
              orElse: () => '',
            ) ??
            '';

        return Container(
          color: AppColors.background,
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding.left,
            right: AppSpacing.screenPadding.right,
            top: AppSpacing.screenPadding.top,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
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
                      displayName,
                      style: AppTextStyle.text24SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  BackgroundRefreshIndicator(isRefreshing: isRefreshing),
                  // Notification bell — hidden when notifications are disabled.
                  if (context
                      .watch<AppFeaturesProvider>()
                      .isNotificationsEnabled) ...[
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
                  ],
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
