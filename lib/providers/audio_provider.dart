import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Central audio controller for all Baraem narration and adhkar sounds.
/// Only one asset is played at a time.
class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  String? _currentAsset;
  bool isPlaying = false;
  bool isMuted = false;
  String? lastError;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  AudioProvider() {
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      isPlaying = false;
      _currentAsset = null;
      if (duration > Duration.zero) {
        position = duration;
      }
      notifyListeners();
    });
    _positionSubscription = _player.onPositionChanged.listen((value) {
      position = value;
      notifyListeners();
    });
    _player.onDurationChanged.listen((value) {
      duration = value;
      notifyListeners();
    });
  }

  String? get currentAsset => _currentAsset;

  Future<void> playAsset(String assetPath) async {
    if (isMuted || assetPath.trim().isEmpty) return;

    lastError = null;
    if (_currentAsset == assetPath && isPlaying) {
      await stop();
      return;
    }

    try {
      await _player.stop();
      _currentAsset = assetPath;
      position = Duration.zero;
      duration = Duration.zero;
      await _player.play(AssetSource(assetPath));
      isPlaying = true;
      notifyListeners();
    } catch (error, stackTrace) {
      _currentAsset = null;
      isPlaying = false;
      lastError = error.toString();
      debugPrint('Baraem audio error: $error\n$stackTrace');
      notifyListeners();
    }
  }

  Future<void> toggleMute() async {
    isMuted = !isMuted;
    if (isMuted) {
      await stop();
    }
    notifyListeners();
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (error) {
      lastError = error.toString();
      debugPrint('Baraem audio stop error: $error');
    }
    isPlaying = false;
    _currentAsset = null;
    position = Duration.zero;
    duration = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    _positionSubscription?.cancel();
    unawaited(_player.dispose());
    super.dispose();
  }
}
