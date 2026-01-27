import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/features/trainer/provider/linked_trainer_provider.dart';
import 'package:focus_fitness/features/trainer/provider/trainer_profile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class TrainerProfileHeader extends StatelessWidget {
  const TrainerProfileHeader({super.key, this.trainerImageUrl, this.onBack});

  final String? trainerImageUrl;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 270.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.screenPadding.left,
                    right: AppSpacing.screenPadding.right,
                    top: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Consumer<TrainerProfileProvider>(
                        builder: (context, trainerProvider, child) {
                          return GestureDetector(
                            onTap:
                                onBack ??
                                () {
                                  if (trainerProvider.showBookingConfirmation) {
                                    trainerProvider.hideBookingView();
                                    return;
                                  }
                                  context.pop();
                                },
                            child: Icon(
                              Icons.arrow_back,
                              size: 24.sp,
                              color: AppColors.background,
                            ),
                          );
                        },
                      ),
                      SizedBox(width: AppSpacing.md),
                      Text(
                        'Trainer',
                        style: AppTextStyle.text20SemiBold.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -40.h,
          left: 0,
          right: 0,
          child: Center(
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: AppColors.grey200,
              backgroundImage: trainerImageUrl != null
                  ? NetworkImage(trainerImageUrl!)
                  : null,
              child: trainerImageUrl == null
                  ? Icon(Icons.person, size: 40.sp, color: AppColors.grey400)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
