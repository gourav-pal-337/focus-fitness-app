import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../provider/video_player_provider.dart';
import 'full_screen_button.dart';
import 'play_pause_button.dart';
import 'progress_bar.dart';
import 'volume_button.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        if (!state.showControls && state.isPlaying) {
          return const SizedBox.shrink();
        }

        return AnimatedOpacity(
          opacity: state.showControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Row(
                          children: [
                            VolumeButton(
                              isMuted: false,
                              onPressed: () {
                                // TODO: Implement volume toggle
                              },
                            ),
                            SizedBox(width: AppSpacing.sm),
                            FullScreenButton(
                              isFullscreen: state.isFullscreen,
                              onPressed: () {
                                provider.toggleFullscreen();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: VideoProgressBar(
                      position: state.position,
                      duration: state.duration,
                      onSeek: (position) {
                        provider.seekTo(position);
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => provider.seekBackward(),
                        child: Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            Icons.replay_10,
                            size: 28.sp,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      PlayPauseButton(
                        isPlaying: state.isPlaying,
                        onPressed: () {
                          provider.togglePlayPause();
                        },
                      ),
                      SizedBox(width: AppSpacing.lg),
                      GestureDetector(
                        onTap: () => provider.seekForward(),
                        child: Container(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Icon(
                            Icons.forward_10,
                            size: 28.sp,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

