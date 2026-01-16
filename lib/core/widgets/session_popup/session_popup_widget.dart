import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/session_popup_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/custom_bottom.dart';
import '../../../routes/app_router.dart';

/// Global session popup widget that can be shown on any screen using Overlay
class SessionPopupWidget extends StatefulWidget {
  const SessionPopupWidget({super.key});

  @override
  State<SessionPopupWidget> createState() => _SessionPopupWidgetState();
}

class _SessionPopupWidgetState extends State<SessionPopupWidget> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    // Listen to provider changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SessionPopupProvider>(context, listen: false);
      provider.addListener(_onProviderChanged);
      // Check if popup should be shown immediately
      _checkAndShowPopup(provider);
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    final provider = Provider.of<SessionPopupProvider>(context, listen: false);
    provider.removeListener(_onProviderChanged);
    super.dispose();
  }

  void _onProviderChanged() {
    final provider = Provider.of<SessionPopupProvider>(context, listen: false);
    _checkAndShowPopup(provider);
  }

  void _checkAndShowPopup(SessionPopupProvider provider) {
    if (provider.shouldShowPopup && 
        provider.popupData != null && 
        !provider.isBottomSheetShowing &&
        mounted &&
        _overlayEntry == null) {
      // Use a small delay to ensure overlay is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && 
            provider.shouldShowPopup && 
            !provider.isBottomSheetShowing && 
            _overlayEntry == null) {
          _showSessionBottomSheet(provider.popupData!, provider);
        }
      });
    } else if (!provider.shouldShowPopup && _overlayEntry != null) {
      _removeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  void _showSessionBottomSheet(
    SessionPopupData data,
    SessionPopupProvider provider,
  ) {
    if (!mounted) return;
    
    // Use router's navigator key to get navigator state
    final navigatorState = AppRouter.rootNavigatorKey.currentState;
    if (navigatorState == null) {
      // Retry after a short delay if navigator is not ready
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && provider.shouldShowPopup && !provider.isBottomSheetShowing) {
          _showSessionBottomSheet(data, provider);
        }
      });
      return;
    }
    
    // Get overlay from navigator state
    final overlay = navigatorState.overlay;
    if (overlay == null) {
      // Retry after a short delay if overlay is not ready
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && provider.shouldShowPopup && !provider.isBottomSheetShowing) {
          _showSessionBottomSheet(data, provider);
        }
      });
      return;
    }
    
    provider.setBottomSheetShowing(true);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => _SessionBottomSheetOverlay(
        data: data,
        onDismiss: () {
          _removeOverlay();
          provider.hidePopup();
          data.onDismiss?.call();
        },
      ),
    );
    
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _SessionBottomSheetOverlay extends StatefulWidget {
  const _SessionBottomSheetOverlay({
    required this.data,
    required this.onDismiss,
  });

  final SessionPopupData data;
  final VoidCallback onDismiss;

  @override
  State<_SessionBottomSheetOverlay> createState() => _SessionBottomSheetOverlayState();
}

class _SessionBottomSheetOverlayState extends State<_SessionBottomSheetOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    _animationController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    // Container(
    //  height: 400,
    //  width: double.infinity,
    //  color: AppColors.primary,
    // );
    Container(
      height: 400,
      width: double.infinity,
      // color: ,
      child: 
      //  SessionBottomSheetContent(
      //           data: widget.data,
      //           onDismiss: _handleDismiss,
      //         ),
      Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleDismiss,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  color: AppColors.overlayDark80,
                ),
              ),
            ),
          ),
          // Bottom sheet content
          SlideTransition(
            position: _slideAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SessionBottomSheetContent(
                data: widget.data,
                onDismiss: _handleDismiss,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SessionBottomSheetContent extends StatelessWidget {
  const SessionBottomSheetContent({
    required this.data,
    required this.onDismiss,
  });

  final SessionPopupData data;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return  
    
    ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.r),
        topRight: Radius.circular(24.r),
      ),
      child: Material(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding.left,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with close button
                    _buildHeader(),
                    SizedBox(height: AppSpacing.sm),
                    // // Profile pictures
                    _buildProfilePictures(),
                    SizedBox(height: AppSpacing.sm),
                    // // Title
                    _buildTitle(),
                    SizedBox(height: AppSpacing.sm),
                    // // Session details bar
                    _buildSessionDetails(),
                    SizedBox(height: AppSpacing.lg * 1.5),
                    // // Join session button
                    _buildJoinButton(context),
                    SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return 
    // Container(
    //   height: 40,
    //   width: double.infinity,
    //   color: AppColors.primary,
    // );
    Padding(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        right: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: onDismiss,
            child: Icon(
              Icons.close,
              size: 24.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictures() {
    return Container(
      height: 80.w,
      width: 130.w,
      // color: AppColors.primary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Trainer profile picture (behind, slightly to left)
          Positioned(
            left: 0,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE91E63), // Pink/purple background
                image: data.trainerImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(data.trainerImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: data.trainerImageUrl == null
                  ? Icon(
                      Icons.person,
                      size: 30.sp,
                      color: AppColors.background,
                    )
                  : null,
            ),
          ),
          // User emoji/avatar (in front, slightly to right)
          Positioned(
            right: 0,
            // left: -1,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF87CEEB), // Light blue outline
                  width: 2,
                ),
                color: AppColors.background,
              ),
              child: Center(
                child: Text(
                  '😊',
                  style: TextStyle(fontSize: 32.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        'Your session with ${data.trainerName} is about to get started!',
        textAlign: TextAlign.center,
        style: AppTextStyle.text16SemiBold.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSessionDetails() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: AppRadius.small,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date with clock icon
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 20.sp,
                  color: AppColors.primary, // Light blue
                ),
                SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    data.sessionDate,
                    style: AppTextStyle.text12Regular.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          // Time
          Flexible(
            child: Text(
              data.sessionTime,
              style: AppTextStyle.text12Regular.copyWith(
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    return CustomButton(
      text: 'Join Session',
      size: ButtonSize.large,
      width: double.infinity,
      height: 52.h,
      backgroundColor: Color(0xFF25D366),
      textColor: AppColors.background,
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Image.network(
          "https://cdn-icons-png.flaticon.com/512/3670/3670051.png",
        ),
      ),
      iconPosition: IconPosition.left,
      textStyle: AppTextStyle.text16SemiBold.copyWith(
        color: AppColors.background,
      ),
      borderRadius: 12.r,
      onPressed: () {
        onDismiss();
        data.onJoinSession?.call();
      },
    );
  }
}
