import 'package:flutter_test/flutter_test.dart';

import 'package:baraem/character/character_state.dart';

void main() {
  test('character starts idle and reacts to activity lifecycle', () {
    final state = CharacterState();
    expect(state.mood, CharacterMood.idle);

    state.onActivityStarted();
    expect(state.mood, CharacterMood.learning);

    state.onActivityCompleted();
    expect(state.mood, CharacterMood.happy);

    state.onStarEarned();
    expect(state.mood, CharacterMood.celebrate);

    state.onActivityMissed();
    expect(state.mood, CharacterMood.encourage);

    state.onAppOpened();
    expect(state.mood, CharacterMood.idle);
  });
}
