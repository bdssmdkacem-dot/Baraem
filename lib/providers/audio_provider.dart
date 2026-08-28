import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Central audio controller for all Baraem narration and adhkar sounds.
/// Only one asset/sequence is played at a time.
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
  int _playbackToken = 0;
  bool _sequenceActive = false;

  AudioProvider() {
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      if (_sequenceActive) return;
      isPlaying = false;
      _currentAsset = null;
      if (duration > Duration.zero) position = duration;
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

  /// Existing Noah aliases are resolved to the agreed narrator -> Quran -> narrator sequence.
  Future<void> playAsset(String assetPath) async {
    if (isMuted || assetPath.trim().isEmpty) return;

    final noahSequence = _noahSequenceForAlias(assetPath);
    if (noahSequence != null) {
      if (_currentAsset == assetPath && isPlaying) {
        await stop();
        return;
      }
      await playSequence(noahSequence, logicalAsset: assetPath);
      return;
    }

    lastError = null;
    if (_currentAsset == assetPath && isPlaying) {
      await stop();
      return;
    }

    final token = ++_playbackToken;
    _sequenceActive = false;
    try {
      await _player.stop();
      _currentAsset = assetPath;
      position = Duration.zero;
      duration = Duration.zero;
      await _player.play(AssetSource(assetPath));
      if (token != _playbackToken) return;
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

  /// Plays segmented narration continuously, waiting for each file to finish.
  Future<void> playSequence(List<String> assets, {String? logicalAsset}) async {
    final sequence = assets.where((asset) => asset.trim().isNotEmpty).toList(growable: false);
    if (sequence.isEmpty || isMuted) return;

    final token = ++_playbackToken;
    _sequenceActive = true;
    lastError = null;
    try {
      await _player.stop();
      _currentAsset = logicalAsset ?? sequence.first;
      isPlaying = true;
      position = Duration.zero;
      duration = Duration.zero;
      notifyListeners();

      for (final asset in sequence) {
        if (token != _playbackToken || isMuted) return;
        _currentAsset = logicalAsset ?? asset;
        position = Duration.zero;
        duration = Duration.zero;
        await _player.play(AssetSource(asset));
        notifyListeners();
        await _player.onPlayerComplete.first;
      }

      if (token == _playbackToken) {
        isPlaying = false;
        _currentAsset = null;
        if (duration > Duration.zero) position = duration;
        notifyListeners();
      }
    } catch (error, stackTrace) {
      if (token == _playbackToken) {
        _currentAsset = null;
        isPlaying = false;
        lastError = error.toString();
        debugPrint('Baraem audio sequence error: $error\n$stackTrace');
        notifyListeners();
      }
    } finally {
      if (token == _playbackToken) _sequenceActive = false;
    }
  }

  List<String>? _noahSequenceForAlias(String assetPath) {
    const base = 'audio/stories/nuh/';
    const aliases = <String, List<String>>{
      'audio/stories/nuh_01.mp3': ['${base}nuh_1_a.mp3', '${base}nuh_quran_01.mp3', '${base}nuh_1_b.mp3'],
      'audio/stories/nuh_02.mp3': ['${base}nuh_2_a.mp3', '${base}nuh_quran_02.mp3', '${base}nuh_2_b.mp3'],
      'audio/stories/nuh_03.mp3': ['${base}nuh_3_a.mp3', '${base}nuh_quran_03.mp3', '${base}nuh_3_b.mp3'],
      'audio/stories/nuh_04.mp3': ['${base}nuh_4_a.mp3', '${base}nuh_quran_04.mp3', '${base}nuh_4_b.mp3'],
      'audio/stories/nuh_05.mp3': ['${base}nuh_5_a.mp3', '${base}nuh_quran_05.mp3', '${base}nuh_5_b.mp3'],
      'audio/stories/nuh_06.mp3': ['${base}nuh_6_a.mp3', '${base}nuh_quran_06.mp3', '${base}nuh_6_b.mp3'],
      'audio/stories/nuh_07.mp3': ['${base}nuh_7_a.mp3', '${base}nuh_quran_07.mp3', '${base}nuh_7_b.mp3'],
      'audio/stories/nuh_08.mp3': ['${base}nuh_8_a.mp3', '${base}nuh_quran_08.mp3', '${base}nuh_8_b.mp3'],
    };
    return aliases[assetPath];
  }

  Future<void> toggleMute() async {
    isMuted = !isMuted;
    if (isMuted) await stop();
    notifyListeners();
  }

  Future<void> stop() async {
    ++_playbackToken;
    _sequenceActive = false;
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
