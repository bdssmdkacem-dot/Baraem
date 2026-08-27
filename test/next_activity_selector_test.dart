import 'package:flutter_test/flutter_test.dart';
import 'package:baraem/activities/activity_models.dart';
import 'package:baraem/activities/next_activity_selector.dart';

void main() {
  const selector = NextActivitySelector();

  final activities = <ActivityDefinition>[
    const ActivityDefinition(
      id: 'adab-1',
      title: 'آدابي',
      type: ActivityType.manners,
      description: 'آداب يومية',
    ),
    const ActivityDefinition(
      id: 'story-1',
      title: 'قصة نبي',
      type: ActivityType.stories,
      description: 'قصة قصيرة',
    ),
    const ActivityDefinition(
      id: 'game-1',
      title: 'لعبة',
      type: ActivityType.games,
      description: 'نشاط ممتع',
    ),
  ];

  test('selects the first available activity', () {
    final result = selector.select(
      activities: activities,
      completedIds: const {},
    );

    expect(result?.id, 'adab-1');
  });

  test('skips completed activities', () {
    final result = selector.select(
      activities: activities,
      completedIds: const {'adab-1'},
    );

    expect(result?.id, 'story-1');
  });

  test('skips the current activity even when it is not completed', () {
    final result = selector.select(
      activities: activities,
      completedIds: const {},
      currentActivityId: 'adab-1',
    );

    expect(result?.id, 'story-1');
  });

  test('returns null when no activity is available', () {
    final result = selector.select(
      activities: activities,
      completedIds: const {'adab-1', 'story-1', 'game-1'},
    );

    expect(result, isNull);
  });
}
