import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';
import '../../trainer/provider/linked_trainer_provider.dart';

class DelinkTrainerScreen extends StatelessWidget {
  const DelinkTrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Delink Trainer',
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.left,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.lg),
                    const _TrainerInfoSection(),
                    SizedBox(height: AppSpacing.xl),
                    const _ReasonDropdown(),
                    SizedBox(height: AppSpacing.lg),
                    const _AdditionalCommentsField(),
                    SizedBox(height: AppSpacing.md),
                    const _DisclaimerNote(),
                    SizedBox(height: AppSpacing.xl),
                    
                    const _DelinkButton(),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainerInfoSection extends StatelessWidget {
  const _TrainerInfoSection();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LinkedTrainerProvider>();
    final trainer = provider.trainer;

    if (trainer == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 28.r,
          backgroundColor: AppColors.grey200,
          backgroundImage: trainer.profilePhoto != null
              ? NetworkImage(trainer.profilePhoto!)
              : null,
          child: trainer.profilePhoto == null
              ? Icon(
                  Icons.person,
                  size: 30.sp,
                  color: AppColors.grey400,
                )
              : null,
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                trainer.fullName ?? 'Trainer',
                style: AppTextStyle.text24SemiBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Trainer ID: ${trainer.referralCode}',
                style: AppTextStyle.text12Regular.copyWith(
                  color: AppColors.grey400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReasonDropdown extends StatelessWidget {
  const _ReasonDropdown();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LinkedTrainerProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Delinking',
          style: AppTextStyle.text16Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: () => _showReasonDialog(context, provider),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: AppRadius.small,
              border: Border.all(
                color: AppColors.grey200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (provider.delinkReason.isNotEmpty)
                  _getReasonIcon(provider.delinkReason),
                if (provider.delinkReason.isNotEmpty)
                  SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    provider.delinkReason.isEmpty
                        ? 'Select reason'
                        : provider.delinkReason,
                    style: AppTextStyle.text14Regular.copyWith(
                      color: provider.delinkReason.isEmpty
                          ? AppColors.grey400
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 24.sp,
                  color: AppColors.grey400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Icon _getReasonIcon(String reason) {
    switch (reason) {
      case 'Trainer Unresponsive':
        return Icon(
          Icons.chat_bubble_outline,
          size: 18.sp,
          color: AppColors.grey400,
        );
      case 'Not Satisfied with Service':
        return Icon(
          Icons.star_outline,
          size: 18.sp,
          color: AppColors.grey400,
        );
      case 'Found Another Trainer':
        return Icon(
          Icons.person_add_outlined,
          size: 18.sp,
          color: AppColors.grey400,
        );
      case 'Personal Reasons':
        return Icon(
          Icons.info_outline,
          size: 18.sp,
          color: AppColors.grey400,
        );
      default:
        return Icon(
          Icons.help_outline,
          size: 18.sp,
          color: AppColors.grey400,
        );
    }
  }

  void _showReasonDialog(
    BuildContext context,
    LinkedTrainerProvider provider,
  ) {
    final reasons = [
      'Trainer Unresponsive',
      'Not Satisfied with Service',
      'Found Another Trainer',
      'Personal Reasons',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.medium,
        ),
        title: Text(
          'Select Reason',
          style: AppTextStyle.text18SemiBold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: reasons.map((reason) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                provider.updateDelinkReason(reason);
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    _getReasonIcon(reason),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      reason,
                      style: AppTextStyle.text14Regular.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _AdditionalCommentsField extends StatefulWidget {
  const _AdditionalCommentsField();

  @override
  State<_AdditionalCommentsField> createState() => _AdditionalCommentsFieldState();
}

class _AdditionalCommentsFieldState extends State<_AdditionalCommentsField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LinkedTrainerProvider>();

    // Sync controller with provider value
    if (_controller.text != provider.delinkComments) {
      _controller.text = provider.delinkComments;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Comments',
          style: AppTextStyle.text16Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        TextField(
          maxLines: 7,
          controller: _controller,
          onChanged: (value) => provider.updateDelinkComments(value),
          style: AppTextStyle.text14Regular.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Describe your problem in detail',
            hintStyle: AppTextStyle.text14Regular.copyWith(
              color: AppColors.grey400,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.small,
              borderSide: BorderSide(
                color: AppColors.grey200,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.small,
              borderSide: BorderSide(
                color: AppColors.grey200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.small,
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}

class _DisclaimerNote extends StatelessWidget {
  const _DisclaimerNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Note - If you delink, your trainer will be notified. You can link to a new trainer anytime.',
      style: AppTextStyle.text12Regular.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }
}

class _DelinkButton extends StatelessWidget {
  const _DelinkButton();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LinkedTrainerProvider>();

    return Center(
      child: TextButton(
        onPressed: provider.canDelink
            ? () async {
                final success = await provider.unlinkTrainer();

                if (success && context.mounted) {
                  context.push(DelinkTrainerSuccessRoute.path);
                }
              }
            : null,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
        child: Text(
          'Delink Trainer',
          style: AppTextStyle.text16SemiBold.copyWith(
            color: provider.canDelink
                ? Colors.red
                : AppColors.grey400,
          ),
        ),
      ),
    );
  }
}

