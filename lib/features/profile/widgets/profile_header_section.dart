import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';
import 'package:focus_fitness/features/authentication/provider/auth_provider.dart';
import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key, this.profileImageUrl});

  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final authProvider = context.read<ClientProfileProvider>();
    final user = userProvider.user;
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grey75,
          ),
          child: profileImageUrl != null
              ? ClipOval(
                  child: Image.network(
                    profileImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return DefaultAvatar();
                    },
                  ),
                )
              : DefaultAvatar(),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          user?.fullName ?? authProvider.profile?.fullName ?? '',
          style: AppTextStyle.text24Bold.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          user?.email ?? authProvider.profile?.email ?? '',
          style: AppTextStyle.text16Regular.copyWith(color: AppColors.grey400),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Member since - ${DateFormat('dd/MM/yyyy').format(user?.createdAt ?? DateTime.now())}',
          style: AppTextStyle.text14Regular.copyWith(color: AppColors.grey400),
        ),
      ],
    );
  }
}

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({super.key, this.size = 50});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('👤', style: TextStyle(fontSize: size.sp)),
    );
  }
}
