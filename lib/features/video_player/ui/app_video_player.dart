import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/video_player_state.dart';
import '../provider/video_player_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/video_controls.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = true,
  });

  final String videoUrl;
  final bool autoPlay;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoPlayerProvider>().initialize(widget.videoUrl);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final provider = context.read<VideoPlayerProvider>();
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      provider.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerProvider>(
      builder: (context, provider, child) {
        final state = provider.state;
        final controller = provider.videoController;

        if (state.hasError) {
          return VideoErrorView(
            errorMessage: state.errorMessage,
            onRetry: () {
              provider.retry();
            },
          );
        }

        if (state.status == VideoPlayerStatus.initializing ||
            controller == null ||
            !controller.value.isInitialized) {
          return Container(
            color: AppColors.grey75,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        if (state.status == VideoPlayerStatus.completed) {
          return GestureDetector(
            onTap: () {
              provider.replay();
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                VideoPlayer(controller),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.replay,
                      size: 48.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            if (state.showControls) {
              provider.hideControls();
            } else {
              provider.showControls();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
              if (state.isBuffering)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              VideoControls(),
            ],
          ),
        );
      },
    );
  }
}

