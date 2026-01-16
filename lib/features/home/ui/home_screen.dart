import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_fitness/core/constants/app_assets.dart';
import 'package:focus_fitness/features/trainer/provider/linked_trainer_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/pinned_header_delegate.dart';
import '../widgets/trainer_connection_card.dart';
import '../widgets/todays_workout_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/trainer_summary_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch linked trainer when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LinkedTrainerProvider>(context, listen: false);
      provider.fetchLinkedTrainer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              // pinned: true,
              floating: true,
              delegate: PinnedHeaderDelegate(),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding.left,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 24.h),
                  const TrainerConnectionCard(),
                  SizedBox(height: 32.h),
                  const TodaysWorkoutSection(),
                  SizedBox(height: 32.h),
                  const ProgressSection(),
                  SizedBox(height: 32.h),
                  // const TrainerSpotlightSection(),
                  // SizedBox(height: 24.h),
                  const TrainerSummarySection(),
                  SizedBox(
                    // width: 150,
                    height: 100.h,
                    child: Image.asset(AppAssets.homeScreenBottomImage)),
                  SizedBox(height: 32.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
