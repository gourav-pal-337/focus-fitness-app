import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_fitness/core/constants/app_assets.dart';
import 'package:focus_fitness/core/provider/session_popup_provider.dart';
import 'package:focus_fitness/core/provider/user_provider.dart';
import 'package:focus_fitness/features/home/widgets/complete_profile_dialog.dart';
import 'package:focus_fitness/features/profile/provider/client_profile_provider.dart';
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
  Future<void> checkuserDetails() async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final user = userProvider.user;
    final profileProvider = Provider.of<ClientProfileProvider>(
      context,
      listen: false,
    );
    await profileProvider.fetchProfile();
    final user = profileProvider.profile;
    print("user : ${user?.gender} | ");
    if (user != null) {
      final isProfileIncomplete =
          (user.gender == null || user.gender!.isEmpty) ||
          (user.dateOfBirth == null || user.dateOfBirth!.isEmpty);

      if (isProfileIncomplete) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const CompleteProfileDialog(),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LinkedTrainerProvider>(context, listen: false);
    // Fetch linked trainer when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // Ensure we have latest details
      // await userProvider.fetchUserDetails();

      if (!mounted) return;

      userProvider.getFcmToken();
      provider.fetchLinkedTrainer();
      checkuserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainerProvider = Provider.of<LinkedTrainerProvider>(context);
    return RefreshIndicator(
      onRefresh: () async {
        final provider = Provider.of<LinkedTrainerProvider>(
          context,
          listen: false,
        );
        provider.fetchLinkedTrainer();
        // checkuserDetails();
      },
      child: Scaffold(
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
                      child: Image.asset(AppAssets.homeScreenBottomImage),
                    ),
                    SizedBox(height: 32.h),
                  ]),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: trainerProvider.trainer == null
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.transparent,
                splashColor: Color(0xFF25D366),

                elevation: 0,
                onPressed: () {
                  //  if (trainerName != null &&
                  //       sessionDate != null &&
                  //       sessionTime != null) {
                  // Schedule session popup
                  final trainerProv = Provider.of<LinkedTrainerProvider>(
                    context,
                    listen: false,
                  );
                  final sessionPopupProvider =
                      Provider.of<SessionPopupProvider>(context, listen: false);

                  final data = SessionPopupData(
                    trainerId: trainerProv.trainer?.id ?? '',
                    trainerName: trainerProv.trainer?.fullName ?? '',
                    trainerImageUrl: trainerProv.trainer?.profilePhoto,
                    trainerContact: trainerProv.trainer?.whatsappNumber ?? '',
                    sessionDate: "",
                    sessionTime: "",
                    onJoinSession: () {
                      // TODO: Handle join session action
                    },
                  );
                  sessionPopupProvider.showPopup(data);

                  // sessionPopupProvider.schedulePopupAt(data, sessionStartTime!);
                  // if (sessionStartTime != null) {
                  // } else {
                  //   sessionPopupProvider.schedulePopup(
                  //     data,
                  //     delay: const Duration(seconds: 5),
                  //   );
                  // }
                  // }
                },
                child: Container(
                  height: 60.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF25D366),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(AppAssets.whatsapp),
                ),
              ),
      ),
    );
  }
}
