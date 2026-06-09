import 'dart:io';
import 'package:focus_fitness/core/widgets/app_modal_sheet.dart';

import 'package:flutter/material.dart';
import 'package:focus_fitness/core/widgets/show_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';
import 'package:focus_fitness/core/theme/app_radius.dart';

import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key, this.profileImageUrl});

  final String? profileImageUrl;

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final provider = context.read<ClientProfileProvider>();
    final picker = ImagePicker();

    // Show source selection bottom sheet
    final ImageSource? source = await showAppModalSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Profile Photo',
              style: AppTextStyle.text18SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: Text('Take Photo', style: AppTextStyle.text16Medium),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                'Choose from Gallery',
                style: AppTextStyle.text16Medium,
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1000,
      maxHeight: 1000,
    );

    if (pickedFile == null) return;

    // Trigger cropping
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust Photo',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(
          title: 'Adjust Photo',
          aspectRatioPresets: [CropAspectRatioPreset.square],
          doneButtonTitle: 'Done',
          cancelButtonTitle: 'Cancel',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile != null && context.mounted) {
      // Show confirmation dialog with a preview of the CROPPED image
      final bool? confirm = await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (context, anim1, anim2) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300.w,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppRadius.medium,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Preview Photo', style: AppTextStyle.text18SemiBold),
                  SizedBox(height: 20.h),
                  Container(
                    width: 150.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.file(
                        File(croppedFile.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            'Cancel',
                            style: AppTextStyle.text16Medium.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Confirm',
                            style: AppTextStyle.text16Medium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if (confirm == true && context.mounted) {
        final success = await provider.updateProfilePhoto(
          XFile(croppedFile.path),
        );
        if (context.mounted) {
          if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.error ?? 'Failed to upload photo'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.redAccent,
              ),
            );
          } else {
            // Update UserProvider as well to ensure synchronization across app
            final userProvider = context.read<UserProvider>();
            if (userProvider.user != null && provider.profile != null) {
              userProvider.updateUser(
                userProvider.user!.copyWith(
                  profilePicture: provider.profile!.profilePicture,
                ),
              );
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile photo updated successfully'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final authProvider = context.watch<ClientProfileProvider>();
    final user = userProvider.user;
    final displayImageUrl =
        profileImageUrl ?? authProvider.profile?.profilePicture;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey75,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ShowImage(
                  imageUrl: displayImageUrl,
                  width: 110.w,
                  height: 110.w,
                  isCircle: true,
                  errorWidget: DefaultAvatar(
                    name: user?.fullName ?? authProvider.profile?.fullName,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: () => _pickAndUploadImage(context),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // if (authProvider.isLoading)
            //   Positioned.fill(
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.black.withOpacity(0.4),
            //         shape: BoxShape.circle,
            //       ),
            //       child: const Center(
            //         child: CircularProgressIndicator(
            //           color: Colors.white,
            //           strokeWidth: 3,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          user?.fullName ?? authProvider.profile?.fullName ?? '',
          style: AppTextStyle.text24Bold.copyWith(
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          user?.email ?? authProvider.profile?.email ?? '',
          style: AppTextStyle.text16Regular.copyWith(color: AppColors.grey400),
        ),
        SizedBox(height: AppSpacing.sm),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            'Member since ${DateFormat('MMMM yyyy').format(user?.createdAt ?? DateTime.now())}',
            style: AppTextStyle.text12Medium.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({super.key, this.size = 50, this.name});
  final double size;
  final String? name;

  String _getInitials(String? name) {
    if (name == null) return '👤';
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '👤';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length > 1 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '👤';
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    return Center(
      child: initials == '👤'
          ? Icon(Icons.person, size: size.sp, color: AppColors.grey400)
          : Text(
              initials,
              style: AppTextStyle.text24Bold.copyWith(
                color: AppColors.primary,
                fontSize: (size / 2).sp,
              ),
            ),
    );
  }
}
