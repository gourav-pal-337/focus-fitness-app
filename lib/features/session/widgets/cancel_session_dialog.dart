import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/custom_bottom.dart';

class CancelSessionDialog extends StatelessWidget {
  const CancelSessionDialog({
    super.key,
    required this.trainerName,
    required this.onConfirm,
  });

  final String trainerName;
  final VoidCallback onConfirm;

  static Future<void> show({
    required BuildContext context,
    required String trainerName,
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.textPrimary.withValues(alpha: 0.5),
      barrierDismissible: true,
      builder: (context) => CancelSessionDialog(
        trainerName: trainerName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: screenHeight * 0.6,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.small,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  _IllustrationSection(),
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20.sp,
                          color: AppColors.grey400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.screenPadding.left),
                child: Column(
                  children: [
                    Text(
                      'Are you sure?',
                      style: AppTextStyle.text24SemiBold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'You want to cancel your booked training session with $trainerName',
                      style: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.grey400,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    CustomButton(
                      text: 'Confirm Cancellation',
                      type: ButtonType.filled,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      width: double.infinity,
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.background,
                      borderRadius: 12.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IllustrationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      height: screenHeight * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey75,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        child: Image.network(
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.person_outline,
                size: 120.sp,
                color: AppColors.grey400,
              ),
            );
          },
        ),
      ),
    );
  }
}

