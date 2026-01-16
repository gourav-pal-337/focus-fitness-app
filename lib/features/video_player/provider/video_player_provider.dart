import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

import '../controller/app_video_controller.dart';
import '../models/video_player_state.dart';

class VideoPlayerProvider extends ChangeNotifier {
  final AppVideoController _videoController = AppVideoController();
  VideoPlayerState _state = const VideoPlayerState();
  Timer? _controlsTimer;
  StreamSubscription? _positionSubscription;
  String? _currentVideoUrl;

  VideoPlayerState get state => _state;
  VideoPlayerController? get videoController => _videoController.controller;

  Future<void> initialize(String videoUrl) async {
    _currentVideoUrl = videoUrl;
    _updateState(_state.copyWith(
      status: VideoPlayerStatus.initializing,
      hasError: false,
      errorMessage: null,
    ));

    try {
      await _videoController.initialize(videoUrl);
      _setupListeners();
      final duration = _videoController.duration ?? Duration.zero;
      _updateState(_state.copyWith(
        status: VideoPlayerStatus.ready,
        duration: duration,
      ));
      await play();
    } catch (e) {
      _updateState(_state.copyWith(
        status: VideoPlayerStatus.error,
        hasError: true,
        errorMessage: _getErrorMessage(e),
      ));
    }
  }

  void _setupListeners() {
    final controller = _videoController.controller;
    if (controller == null) return;

    controller.removeListener(_onVideoUpdate);
    controller.addListener(_onVideoUpdate);

    _positionSubscription?.cancel();
    _positionSubscription = Stream.periodic(
      const Duration(milliseconds: 100),
      (count) => controller.value.position,
    ).listen((position) {
      if (controller.value.isInitialized) {
        _updateState(_state.copyWith(position: position));
      }
    });
  }

  void _onVideoUpdate() {
    final controller = _videoController.controller;
    if (controller == null) return;

    final value = controller.value;

    if (value.hasError) {
      _updateState(_state.copyWith(
        status: VideoPlayerStatus.error,
        hasError: true,
        errorMessage: value.errorDescription,
      ));
      return;
    }

    if (!value.isInitialized) return;

    VideoPlayerStatus status = _state.status;
    if (value.isPlaying && !value.isBuffering) {
      status = VideoPlayerStatus.playing;
    } else if (value.isBuffering) {
      status = VideoPlayerStatus.buffering;
    } else if (!value.isPlaying && _state.status == VideoPlayerStatus.playing) {
      status = VideoPlayerStatus.paused;
    }

    if (value.position >= value.duration && value.duration > Duration.zero) {
      status = VideoPlayerStatus.completed;
    }

    _updateState(_state.copyWith(
      status: status,
      isPlaying: value.isPlaying,
      isBuffering: value.isBuffering,
      duration: value.duration,
      position: value.position,
    ));
  }

  Future<void> play() async {
    await _videoController.play();
    _updateState(_state.copyWith(isPlaying: true));
    _resetControlsTimer();
  }

  Future<void> pause() async {
    await _videoController.pause();
    _updateState(_state.copyWith(isPlaying: false));
    _resetControlsTimer();
  }

  Future<void> togglePlayPause() async {
    if (_state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seekTo(Duration position) async {
    await _videoController.seekTo(position);
    _updateState(_state.copyWith(position: position));
    _resetControlsTimer();
  }

  Future<void> seekForward() async {
    final newPosition = _state.position + const Duration(seconds: 10);
    final maxPosition = _state.duration;
    await seekTo(newPosition > maxPosition ? maxPosition : newPosition);
  }

  Future<void> seekBackward() async {
    final newPosition = _state.position - const Duration(seconds: 10);
    await seekTo(newPosition.isNegative ? Duration.zero : newPosition);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await _videoController.setPlaybackSpeed(speed);
    _updateState(_state.copyWith(playbackSpeed: speed));
    _resetControlsTimer();
  }

  void toggleFullscreen() {
    _updateState(_state.copyWith(isFullscreen: !_state.isFullscreen));
    _resetControlsTimer();
  }

  void showControls() {
    _updateState(_state.copyWith(showControls: true));
    _resetControlsTimer();
  }

  void hideControls() {
    if (_state.isPlaying) {
      _updateState(_state.copyWith(showControls: false));
    }
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    if (_state.isPlaying) {
      _controlsTimer = Timer(const Duration(seconds: 3), hideControls);
    }
  }

  Future<void> replay() async {
    await seekTo(Duration.zero);
    await play();
  }

  Future<void> retry() async {
    if (_state.status == VideoPlayerStatus.error && _currentVideoUrl != null) {
      await initialize(_currentVideoUrl!);
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is String) return error;
    return 'Failed to load video. Please try again.';
  }

  void _updateState(VideoPlayerState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _positionSubscription?.cancel();
    _videoController.controller?.removeListener(_onVideoUpdate);
    _videoController.dispose();
    super.dispose();
  }
}

