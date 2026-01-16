import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/delete_account_provider.dart';
import '../widgets/delete_account_confirmation_dialog.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeleteAccountProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Delete Account',
              ),
              Expanded(
                child: Consumer<DeleteAccountProvider>(
                  builder: (context, provider, child) {
                    if (!provider.showDeleteForm) {
                      return _InitialDeleteView();
                    }
                    return _DeleteAccountForm();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InitialDeleteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Provider.of<DeleteAccountProvider>(context, listen: false).showForm();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding.left,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.xl),
              Text(
                'Delete Account',
                style: AppTextStyle.text16Regular.copyWith(
                  color: Colors.red,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Permanently remove your account and all associated data. This action cannot be undone.',
                style: AppTextStyle.text16Regular.copyWith(
                  color: AppColors.grey400,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteAccountForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding.left,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.xl),
            Text(
              'Reason for leaving',
              style: AppTextStyle.text16SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            _ReasonTextField(),
            SizedBox(height: AppSpacing.lg),
            Text(
                    '⚠️ Warning: Once deleted, your account cannot be recovered. All subscriptions or purchased content will also be canceled.',
                    style: AppTextStyle.text12Regular.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.warning_amber_rounded,
            //       size: 20.sp,
            //       color: Colors.orange,
            //     ),
            //     SizedBox(width: AppSpacing.sm),
            //     Expanded(
            //       child: 
            //     ),
            //   ],
            // ),
            SizedBox(height: AppSpacing.xl),
            Consumer<DeleteAccountProvider>(
              builder: (context, provider, child) {
                return GestureDetector(
                  onTap: () {
                    DeleteAccountConfirmationDialog.show(
                      context: context,
                      onDelete: () {
                        provider.deleteAccount();
                        context.pop();
                        // TODO: Handle account deletion and navigation
                      },
                      onCancel: () {
                        context.pop();
                        // Dialog will close automatically
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Delete Account',
                          style: AppTextStyle.text16Regular.copyWith(
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.arrow_forward,
                          size: 20.sp,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _ReasonTextField extends StatefulWidget {
  @override
  State<_ReasonTextField> createState() => _ReasonTextFieldState();
}

class _ReasonTextFieldState extends State<_ReasonTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DeleteAccountProvider>(context, listen: false);
    _controller = TextEditingController(text: provider.reason);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeleteAccountProvider>(
      builder: (context, provider, child) {
        if (_controller.text != provider.reason) {
          _controller.text = provider.reason;
        }
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.small,
            border: Border.all(
              color: AppColors.grey200,
              width: 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              provider.updateReason(value);
            },
            maxLines: 8,
            style: AppTextStyle.text14Regular.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Tell us why you\'re leaving...',
              hintStyle: AppTextStyle.text14Regular.copyWith(
                color: AppColors.grey400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(AppSpacing.md),
            ),
          ),
        );
      },
    );
  }
}
