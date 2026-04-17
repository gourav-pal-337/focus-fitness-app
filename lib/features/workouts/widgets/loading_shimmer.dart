import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: AppSpacing.screenPadding.left,
        //   ),
        //   child: Shimmer.fromColors(
        //     baseColor: AppColors.grey75,
        //     highlightColor: Colors.white,
        //     child: Container(
        //       width: 140.w,
        //       height: 24.h,
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(4.r),
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(height: AppSpacing.md),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.grey75,
            highlightColor: Colors.white,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 6 / 5,
              ),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
