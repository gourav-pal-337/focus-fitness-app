import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../provider/video_player_provider.dart';
import 'app_video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    this.title,
  });

  final String videoUrl;
  final String? title;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoPlayerProvider(),
      child: Consumer<VideoPlayerProvider>(
        builder: (context, provider, child) {
          final isFullscreen = provider.state.isFullscreen;

          if (isFullscreen) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
          } else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            body: isFullscreen
                ? AppVideoPlayer(videoUrl: widget.videoUrl)
                : SafeArea(
                    child: Column(
                      children: [
                        CustomAppBar(
                          title: widget.title ?? 'Video',
                        ),
                        Expanded(
                          child: AppVideoPlayer(videoUrl: widget.videoUrl),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

