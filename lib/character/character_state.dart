import 'package:flutter/foundation.dart';

enum CharacterMood { idle, happy, learning, encourage, celebrate }

class CharacterState extends ChangeNotifier {
  CharacterMood _mood = CharacterMood.idle;

  CharacterMood get mood => _mood;

  void setMood(CharacterMood mood) {
    if (_mood == mood) return;
    _mood = mood;
    notifyListeners();
  }

  void onAppOpened() => setMood(CharacterMood.idle);
  void onActivityStarted() => setMood(CharacterMood.learning);
  void onActivityCompleted() => setMood(CharacterMood.happy);
  void onStarEarned() => setMood(CharacterMood.celebrate);
  void onActivityMissed() => setMood(CharacterMood.encourage);
}
