import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'trainer_spotlight_item.dart';

class TrainerSpotlightSection extends StatelessWidget {
  const TrainerSpotlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Trainer Spotlight',
              style: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(
                height: 1.h,
                color: AppColors.grey200,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Column(
          children: [
            TrainerSpotlightItem(
              name: 'James Gustavsson',
              specialty: 'HIIT & Cardio',
              rating: 4.6,
              imageUrl: 'https://i.pravatar.cc/150?img=3',
              trainerId: 'james-gustavsson',
              showDivider: true,
            ),
            TrainerSpotlightItem(
              name: 'Lisa Tran',
              specialty: 'Yoga & Flexibility',
              rating: 4.8,
              imageUrl: 'https://i.pravatar.cc/150?img=5',
              trainerId: 'lisa-tran',
              showDivider: true,
            ),
            TrainerSpotlightItem(
              name: 'Marco Alvarado',
              specialty: 'Strength Training',
              rating: 4.7,
              imageUrl: 'https://i.pravatar.cc/150?img=7',
              trainerId: 'marco-alvarado',
              showDivider: true,
            ),
            TrainerSpotlightItem(
              name: 'Nina Patel',
              specialty: 'Pilates & Core',
              rating: 4.9,
              imageUrl: 'https://i.pravatar.cc/150?img=9',
              trainerId: 'nina-patel',
              showDivider: false,
            ),
          ],
        ),
      ],
    );
  }
}

