import 'package:flutter/foundation.dart';

import '../core/storage_service.dart';

/// App-wide preferences that are independent from child progress.
class AppStateProvider extends ChangeNotifier {
  static const _kOnboardingComplete = 'baraem_onboarding_complete';
  static const _kSoundEnabled = 'baraem_sound_enabled';
  static const _kMusicEnabled = 'baraem_music_enabled';

  bool onboardingComplete = false;
  bool soundEnabled = true;
  bool musicEnabled = true;

  StorageService? _storage;

  Future<void> load() async {
    _storage = await StorageService.getInstance();
    onboardingComplete = _storage!.getBool(_kOnboardingComplete);
    soundEnabled = _storage!.getBool(_kSoundEnabled, defaultValue: true);
    musicEnabled = _storage!.getBool(_kMusicEnabled, defaultValue: true);
    notifyListeners();
  }

  Future<void> setOnboardingComplete(bool value) async {
    onboardingComplete = value;
    await _storage?.setBool(_kOnboardingComplete, value);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    soundEnabled = value;
    await _storage?.setBool(_kSoundEnabled, value);
    notifyListeners();
  }

  Future<void> setMusicEnabled(bool value) async {
    musicEnabled = value;
    await _storage?.setBool(_kMusicEnabled, value);
    notifyListeners();
  }
}
