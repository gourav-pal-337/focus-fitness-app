enum VideoPlayerStatus {
  idle,
  initializing,
  ready,
  playing,
  paused,
  buffering,
  error,
  completed,
}

class VideoPlayerState {
  const VideoPlayerState({
    this.status = VideoPlayerStatus.idle,
    this.isPlaying = false,
    this.isBuffering = false,
    this.hasError = false,
    this.errorMessage,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.isFullscreen = false,
    this.playbackSpeed = 1.0,
    this.showControls = true,
  });

  final VideoPlayerStatus status;
  final bool isPlaying;
  final bool isBuffering;
  final bool hasError;
  final String? errorMessage;
  final Duration duration;
  final Duration position;
  final bool isFullscreen;
  final double playbackSpeed;
  final bool showControls;

  VideoPlayerState copyWith({
    VideoPlayerStatus? status,
    bool? isPlaying,
    bool? isBuffering,
    bool? hasError,
    String? errorMessage,
    Duration? duration,
    Duration? position,
    bool? isFullscreen,
    double? playbackSpeed,
    bool? showControls,
  }) {
    return VideoPlayerState(
      status: status ?? this.status,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      showControls: showControls ?? this.showControls,
    );
  }
}

