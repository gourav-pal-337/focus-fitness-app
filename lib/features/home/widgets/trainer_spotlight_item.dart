import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/session_popup_provider.dart';
import 'package:focus_fitness/core/widgets/session_popup/session_popup_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_router.dart';

class TrainerSpotlightItem extends StatelessWidget {
  const TrainerSpotlightItem({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    this.showDivider = false,
    this.trainerId,
  });

  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;
  final bool showDivider;
  final String? trainerId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            final id = trainerId ?? name.toLowerCase().replaceAll(' ', '-');
            context.push(
              TrainerProfileRoute.path.replaceAll(':trainerId', id),
            );
            // showModalBottomSheet(
            //   context: context,
            //   builder: (context) =>   SessionBottomSheetContent(
            //     data: SessionPopupData(
            //       trainerName: name,
            //       trainerImageUrl: imageUrl,
            //       sessionDate: '2025-01-01',
            //       sessionTime: '10:00 AM',
            //     ),
            //     onDismiss: () {},
            //   ),
            // );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32.r,
                  backgroundColor: AppColors.grey200,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyle.text16SemiBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Text(
                            specialty,
                            style: AppTextStyle.text12Regular.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                         
                        ],
                      ),
                                   

                      Row(children: [
                         Icon(
                            Icons.star,
                            size: 16.sp,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '$rating/5',
                            style: AppTextStyle.text12Regular.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                      ],)
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: AppColors.grey400,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1.h,
            color: AppColors.grey200,
          ),
      ],
    );
  }
}

