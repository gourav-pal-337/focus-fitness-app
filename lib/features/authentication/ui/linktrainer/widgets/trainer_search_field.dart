import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../trainer/data/models/trainer_referral_response_model.dart';
import '../../../provider/auth_provider.dart';

class TrainerSearchField extends StatefulWidget {
  const TrainerSearchField({super.key});

  @override
  State<TrainerSearchField> createState() => _TrainerSearchFieldState();
}

class _TrainerSearchFieldState extends State<TrainerSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final provider = context.read<AuthProvider>();
    final query = _controller.text.trim();
    
    // If user starts typing and a trainer is selected, clear selection
    if (provider.selectedTrainer != null && _controller.text != provider.selectedTrainer!.referralCode) {
      provider.clearTrainerValidation();
    }
    
    // Update trainer ID immediately
    provider.updateTrainerId(_controller.text);
    
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Clear results if query is empty
    if (query.isEmpty) {
      provider.clearTrainerValidation();
      return;
    }
    
    // Only search if query is at least 4 characters (as per API requirement)
    if (query.length < 4) {
      provider.clearTrainerValidation();
      return;
    }
    
    // Debounce the search API call (wait 500ms after user stops typing)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted && _controller.text.trim() == query) {
        provider.searchTrainer(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final hasError = provider.trainerId.isEmpty && !_focusNode.hasFocus && provider.selectedTrainer == null;
    final showDropdown = provider.hasTrainers && _focusNode.hasFocus && provider.selectedTrainer == null;
    final showSelectedBox = provider.selectedTrainer != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show selected trainer box or search field
        if (showSelectedBox)
          _SelectedTrainerBox(
            trainer: provider.selectedTrainer!,
            onClear: () {
              provider.clearTrainerValidation();
              _controller.clear();
              _focusNode.requestFocus();
            },
          )
        else
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            style: AppTextStyle.text16Regular.copyWith(
              color: AppColors.textPrimary,
            ),
           
            decoration: InputDecoration(
              hintText: 'Enter trainer\'s name or referral code',
              hintStyle: AppTextStyle.text14Regular.copyWith(
                color: AppColors.grey400,
              ),
             
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 16.h,
              ),
              suffixIcon: Icon(
                showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: AppColors.grey400,
                size: 24.sp,
              ),
            ),
          ),
        if (hasError && !showSelectedBox) ...[
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(
                '*',
                style: AppTextStyle.text14Regular.copyWith(
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'This field is required',
                style: AppTextStyle.text14Regular.copyWith(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
        // Show dropdown list below the field
        if (showDropdown) ...[
          SizedBox(height: 4.h),
          Container(
            constraints: BoxConstraints(
              maxHeight: 300.h,
            ),
            decoration: BoxDecoration(
              
            ),
            child: CupertinoScrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              thicknessWhileDragging: 8,
              radius: Radius.circular(12.r),
              thickness: 6,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: provider.foundTrainers.length,
                itemBuilder: (context, index) {
                  final trainer = provider.foundTrainers[index];
                  final isSelected = provider.selectedTrainer?.id == trainer.id;
                  
                  return _TrainerDropdownItem(
                    trainer: trainer,
                    isSelected: isSelected,
                    onTap: () {
                      provider.selectTrainer(trainer);
                      // _controller.text = trainer.referralCode;
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SelectedTrainerBox extends StatelessWidget {
  const _SelectedTrainerBox({
    required this.trainer,
    required this.onClear,
  });

  final TrainerInfo trainer;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.primary,
          // width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Profile Photo
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey200,
              image: trainer.profilePhoto != null
                  ? DecorationImage(
                      image: NetworkImage(trainer.profilePhoto!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: trainer.profilePhoto == null
                ? Icon(
                    Icons.person,
                    size: 28.sp,
                    color: AppColors.grey400,
                  )
                : null,
          ),
          SizedBox(width: AppSpacing.md),
          // Trainer Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trainer.fullName ?? 'Trainer',
                  style: AppTextStyle.text16Regular.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  trainer.referralCode,
                  style: AppTextStyle.text14Regular.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ),
          ),
          // Clear button
          GestureDetector(
            onTap: onClear,
            child: Icon(
              Icons.close,
              size: 20.sp,
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainerDropdownItem extends StatelessWidget {
  const _TrainerDropdownItem({
    required this.trainer,
    required this.isSelected,
    required this.onTap,
  });

  final TrainerInfo trainer;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            // Profile Photo
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey200,
                image: trainer.profilePhoto != null
                    ? DecorationImage(
                        image: NetworkImage(trainer.profilePhoto!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: trainer.profilePhoto == null
                  ? Icon(
                      Icons.person,
                      size: 24.sp,
                      color: AppColors.grey400,
                    )
                  : null,
            ),
            SizedBox(width: AppSpacing.md),
            // Trainer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer.fullName ?? 'Trainer',
                    style: AppTextStyle.text14Regular.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    trainer.referralCode,
                    style: AppTextStyle.text12Regular.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
            // Selection Indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}

