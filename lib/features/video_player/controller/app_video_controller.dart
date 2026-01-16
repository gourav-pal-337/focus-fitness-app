import 'package:video_player/video_player.dart';

class AppVideoController {
  VideoPlayerController? _controller;

  VideoPlayerController? get controller => _controller;

  Future<void> initialize(String videoUrl) async {
    try {
      await dispose();
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _controller!.initialize();
    } catch (e) {
      await dispose();
      rethrow;
    }
  }

  Future<void> play() async {
    await _controller?.play();
  }

  Future<void> pause() async {
    await _controller?.pause();
  }

  Future<void> seekTo(Duration position) async {
    await _controller?.seekTo(position);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await _controller?.setPlaybackSpeed(speed);
  }

  Duration? get position => _controller?.value.position;

  Duration? get duration => _controller?.value.duration;

  bool? get isPlaying => _controller?.value.isPlaying;

  bool? get isBuffering => _controller?.value.isBuffering;

  bool? get isInitialized => _controller?.value.isInitialized;

  bool? get hasError => _controller?.value.hasError;

  String? get errorDescription => _controller?.value.errorDescription;

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}

