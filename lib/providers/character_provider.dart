import 'package:flutter/foundation.dart';

import '../character/character_state.dart';

class CharacterProvider extends ChangeNotifier {
  final CharacterState _state = CharacterState();

  CharacterMood get mood => _state.mood;

  void onAppOpened() => _set(_state.onAppOpened);
  void onActivityStarted() => _set(_state.onActivityStarted);
  void onActivityCompleted() => _set(_state.onActivityCompleted);
  void onStarEarned() => _set(_state.onStarEarned);
  void onActivityMissed() => _set(_state.onActivityMissed);

  void _set(void Function() action) {
    action();
    notifyListeners();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }
}
