import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Central audio controller for all Baraem narration and adhkar sounds.
/// Only one asset is played at a time.
class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;

  String? _currentAsset;
  bool isPlaying = false;
  bool isMuted = false;
  String? lastError;

  AudioProvider() {
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      isPlaying = false;
      _currentAsset = null;
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
    notifyListeners();
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    unawaited(_player.dispose());
    super.dispose();
  }
}
