import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Wrapper simple autour d'audioplayers pour la narration des dhikr
/// et des histoires. Un seul lecteur actif à la fois (on coupe le
/// précédent si l'enfant tape vite sur plusieurs cartes).
class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  String? _currentAsset;
  bool isPlaying = false;

  Future<void> playAsset(String assetPath) async {
    if (_currentAsset == assetPath && isPlaying) {
      await stop();
      return;
    }
    await _player.stop();
    _currentAsset = assetPath;
    // assetPath attendu sous la forme "audio/adkar/xxx.mp3"
    // (sans le préfixe "assets/", conforme à AssetSource d'audioplayers)
    await _player.play(AssetSource(assetPath));
    isPlaying = true;
    notifyListeners();

    _player.onPlayerComplete.listen((_) {
      isPlaying = false;
      notifyListeners();
    });
  }

  Future<void> stop() async {
    await _player.stop();
    isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
