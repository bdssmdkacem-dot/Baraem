import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:baraem/activities/activity_engine.dart';
import 'package:baraem/activities/activity_models.dart';
import 'package:baraem/character/character_state.dart';
import 'package:baraem/providers/character_provider.dart';
import 'package:baraem/providers/progress_provider.dart';

void main() {
  const activity = ActivityDefinition(
    id: 'test-activity',
    title: 'نشاط تجريبي',
    type: ActivityType.adhkar,
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('unified lifecycle starts, completes, rewards once and updates character', () async {
    final progress = ProgressProvider();
    await progress.load();
    final character = CharacterProvider()..onAppOpened();
    final engine = ActivityEngine(progress: progress, character: character);

    engine.start(activity);
    expect(engine.status, ActivityStatus.inProgress);
    expect(character.mood, CharacterMood.learning);

    final result = await engine.complete(activity);
    expect(result.completed, isTrue);
    expect(result.starsEarned, 1);
    expect(engine.status, ActivityStatus.completed);
    expect(character.mood, CharacterMood.celebrate);
    expect(progress.stars, 1);
    expect(progress.isCompleted(activity.id), isTrue);

    final duplicate = await engine.complete(activity);
    expect(duplicate.completed, isFalse);
    expect(progress.stars, 1);

    character.dispose();
  });

  test('missing an in-progress activity encourages the child', () async {
    final progress = ProgressProvider();
    await progress.load();
    final character = CharacterProvider()..onAppOpened();
    final engine = ActivityEngine(progress: progress, character: character);

    engine.start(activity);
    engine.miss(activity);

    expect(engine.status, ActivityStatus.missed);
    expect(character.mood, CharacterMood.encourage);
    expect(progress.stars, 0);

    character.dispose();
  });
}
