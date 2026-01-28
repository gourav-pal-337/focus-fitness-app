import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_router.dart';
import '../provider/account_details_provider.dart';
import '../widgets/edit_detail_row.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountDetailsProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Account Details',
                centerTitle: true,
                actions: [
                  Consumer<AccountDetailsProvider>(
                    builder: (context, provider, child) {
                      return GestureDetector(
                        onTap: () {
                          provider.save();
                          context.pop();
                        },
                        child: Icon(
                          Icons.check,
                          size: 24.sp,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.md),
                      Consumer<AccountDetailsProvider>(
                        builder: (context, provider, child) {
                          final fields = provider.fields;
                          return Column(
                            children: [
                              EditDetailRow(
                                label: fields[0].label,
                                value: provider.values[0],
                                onChanged: (value) {
                                  provider.updateValue(0, value);
                                },
                              ),
                              Divider(
                                color: AppColors.grey200,
                                thickness: 1,
                                height: 0,
                              ),
                              EditDetailRow(
                                label: fields[1].label,
                                value: provider.values[1],
                                onChanged: (value) {
                                  provider.updateValue(1, value);
                                },
                              ),
                              Divider(
                                color: AppColors.grey200,
                                thickness: 1,
                                height: 0,
                              ),
                              EditDetailRow(
                                label: fields[2].label,
                                value: provider.values[2],
                                onChanged: (value) {
                                  provider.updateValue(2, value);
                                },
                              ),
                              Divider(
                                color: AppColors.grey200,
                                thickness: 1,
                                height: 0,
                              ),
                              EditDetailRow(
                                label: fields[3].label,
                                value: provider.values[3],
                                onChanged: (value) {
                                  provider.updateValue(3, value);
                                },
                              ),
                              Divider(
                                color: AppColors.grey200,
                                thickness: 1,
                                height: 0,
                              ),
                              EditDetailRow(
                                label: fields[4].label,
                                value: provider.values[4],
                                onChanged: (value) {
                                  provider.updateValue(4, value);
                                },
                              ),
                              Divider(
                                color: AppColors.grey200,
                                thickness: 1,
                                height: 0,
                              ),
                              // _AccountPasswordRow(
                              //   label: fields[5].label,
                              //   value: provider.values[5],
                              //   onChanged: (value) {
                              //     provider.updateValue(5, value);
                              //   },
                              // ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.xl),

                      Consumer<AccountDetailsProvider>(
                        builder: (context, provider, child) {
                          return GestureDetector(
                            onTap: () {
                              context.push(ChangePasswordRoute.path);
                            },
                            child: Text(
                              'Change Password',
                              style: AppTextStyle.text16Regular.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountPasswordRow extends StatefulWidget {
  const _AccountPasswordRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_AccountPasswordRow> createState() => _AccountPasswordRowState();
}

class _AccountPasswordRowState extends State<_AccountPasswordRow> {
  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_AccountPasswordRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: AppSpacing.screenPadding.left,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.label,
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              textAlign: TextAlign.right,
              obscureText: _obscureText,
              style: AppTextStyle.text16Regular.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20.sp,
                    color: AppColors.grey400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
