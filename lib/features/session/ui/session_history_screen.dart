import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_sliver_app_bar.dart';
import '../provider/session_history_provider.dart';
import '../widgets/session_card.dart';
import '../widgets/session_tab_bar.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SessionHistoryProvider>(context, listen: false).fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<SessionHistoryProvider>(
          context,
          listen: false,
        ).fetchBookings();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              onBack: () {
                context.go(HomeRoute.path);
              },
              title: 'Session History',
              backgroundImage:
                  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 24.sp,
                    color: AppColors.background,
                  ),
                  onPressed: () {
                    // TODO: Handle menu
                  },
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,

              // floating: true,
              delegate: _TabBarDelegate(child: const SessionTabBar()),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.left,
                vertical: AppSpacing.md,
              ),
              sliver: Consumer<SessionHistoryProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (provider.error != null) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.error!,
                              style: AppTextStyle.text14Regular.copyWith(
                                color: AppColors.grey400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppSpacing.md),
                            TextButton(
                              onPressed: () => provider.refresh(),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final sessions = provider.sessions;

                  if (sessions.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No sessions found',
                          style: AppTextStyle.text14Regular.copyWith(
                            color: AppColors.grey400,
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: sessions.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: Divider(color: AppColors.grey300, height: 1),
                    ),
                    itemBuilder: (context, index) {
                      return SessionCard(session: sessions[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate({required this.child});

  @override
  double get minExtent {
    // Container vertical padding: AppSpacing.xl (32.w) * 2 = 64
    // Tab button vertical padding: AppSpacing.sm (8.w) * 2 = 16
    // Text height: ~20 (approximate)
    // Total: ~100
    return 100.h;
  }

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: minExtent,
      child: Container(color: AppColors.background, child: child),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
