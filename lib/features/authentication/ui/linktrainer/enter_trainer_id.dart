import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/custom_bottom.dart';
import '../../provider/auth_provider.dart';

class EnterTrainerIdScreen extends StatelessWidget {
  const EnterTrainerIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canProceed = context.watch<AuthProvider>().canProceedWithTrainerId;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.screenPadding.left,
            right: AppSpacing.screenPadding.right,
            bottom: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Enter Trainer\nUnique Code',
                style: AppTextStyle.text48Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm + 5),
              Text(
                'Please enter your Trainer Unique Code to proceed.',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.lg * 1.5),
              const _TrainerIdField(),
             
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.only(
          left: AppSpacing.screenPadding.left,
          right: AppSpacing.screenPadding.right,
          bottom: AppSpacing.lg,
        ),
                text: 'Next',
                size: ButtonSize.large,
                width: double.infinity,
                height: 52.h,
                backgroundColor: canProceed ? AppColors.primary : AppColors.grey300,
                textColor: AppColors.background,
                icon: Icon(
                  Icons.arrow_forward,
                  size: 20.sp,
                  color: AppColors.background,
                ),
                textStyle: AppTextStyle.text16SemiBold.copyWith(
                  color: AppColors.background,
                ),
                iconPosition: IconPosition.right,
                borderRadius: 12.r,
                isEnabled: canProceed,
                onPressed: canProceed
                    ? () {
                        final trainerId = context.read<AuthProvider>().trainerId;
                        context.go('/link-trainer/$trainerId');
                      }
                    : null,
              ),
    );
  }
}

class _TrainerIdField extends StatelessWidget {
  const _TrainerIdField();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AuthProvider>();

    return TextFormField(
      style: AppTextStyle.text16Regular.copyWith(
        color: AppColors.textPrimary,
      ),
      cursorColor: AppColors.primary,
      onChanged: provider.updateTrainerId,
      decoration: InputDecoration(
        hintText: 'Trainer Unique Code',
        hintStyle: AppTextStyle.text14Regular.copyWith(
          color: AppColors.grey400,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.only(
          bottom: 8.h,
        ),
      ),
    );
  }
}
