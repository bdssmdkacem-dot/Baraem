import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:baraem/activities/activity_definitions.dart';
import 'package:baraem/activities/activity_provider.dart';
import 'package:baraem/models/story_item.dart';
import 'package:baraem/providers/audio_provider.dart';
import 'package:baraem/providers/character_provider.dart';
import 'package:baraem/providers/progress_provider.dart';
import 'package:baraem/screens/adab_screen.dart';
import 'package:baraem/screens/story_detail_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<_Scope> scope() async {
    final progress = ProgressProvider();
    await progress.load();
    final character = CharacterProvider()..onAppOpened();
    final activity = ActivityProvider(progress: progress, character: character);
    return _Scope(progress, character, activity, AudioProvider());
  }

  Widget app(Widget child, _Scope s) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: s.progress),
          ChangeNotifierProvider.value(value: s.activity),
          ChangeNotifierProvider.value(value: s.audio),
        ],
        child: MaterialApp(home: child),
      );

  testWidgets('آدابي completes, rewards, then opens the next activity', (tester) async {
    final s = await scope();
    addTearDown(s.dispose);
    s.activity.start(mannersActivity('adab_eating', 'آداب الطعام'));

    await tester.pumpWidget(app(const AdabScreen(), s));
    await tester.pumpAndSettle();

    expect(s.activity.status.name, 'inProgress');
    expect(find.text('آدابي'), findsOneWidget);
    expect(find.text('بِسْمِ اللَّهِ'), findsOneWidget);

    await tester.tap(find.text('بِسْمِ اللَّهِ'));
    await tester.pumpAndSettle();

    expect(s.activity.lastResult?.completed, isTrue);
    expect(s.progress.stars, 1);
    expect(s.progress.isCompleted('adab_eating'), isTrue);
    expect(find.text('أحسنت! 🎉'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);

    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();

    expect(find.text('أحسنت! 🎉'), findsNothing);
    expect(find.text('قابلت صديقك في الحديقة، ماذا تقول له؟'), findsOneWidget);
    expect(s.progress.stars, 1);
    expect(s.progress.isCompleted('adab_eating'), isTrue);
  });

  testWidgets('قصص الأنبياء advances pages and completes adaptive quiz/game', (tester) async {
    final s = await scope();
    addTearDown(s.dispose);

    const story = StoryItem(
      id: 'story_test_nuh',
      title: 'قصة سيدنا نوح',
      coverAsset: 'unused',
      pages: [
        StoryPage(text: 'بدأت القصة', imageAsset: 'unused'),
        StoryPage(text: 'وصلنا إلى النهاية', imageAsset: 'unused'),
      ],
      quiz: [
        QuizQuestion(
          question: 'ماذا فعل نوح عليه السلام؟',
          options: ['بنى السفينة', 'بنى قصرًا'],
          correctIndex: 0,
        ),
      ],
      games: [
        StoryGame(
          id: 'story_test_nuh_game',
          title: 'اختر الإجابة الصحيحة',
          kind: StoryGameKind.choose,
          items: ['بنى السفينة', 'بنى قصرًا'],
          correctOrder: [0],
        ),
      ],
    );
    s.activity.start(storyActivity(story.id, story.title));

    await tester.pumpWidget(app(const StoryDetailScreen(story: story), s));
    await tester.pumpAndSettle();

    expect(s.activity.status.name, 'inProgress');
    expect(find.text('بدأت القصة'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();
    expect(find.text('وصلنا إلى النهاية'), findsOneWidget);

    expect(find.text('ماذا فعل نوح عليه السلام؟'), findsOneWidget);
    await tester.tap(find.text('بنى السفينة'));
    await tester.pumpAndSettle();

    expect(find.text('اختر الإجابة الصحيحة'), findsOneWidget);
    await tester.tap(find.text('بنى السفينة'));
    await tester.pumpAndSettle();

    expect(s.activity.lastResult?.completed, isTrue);
    expect(s.progress.stars, greaterThanOrEqualTo(1));
    expect(s.progress.isCompleted('story_test_nuh'), isTrue);
    expect(find.text('أحسنت! 🎉'), findsOneWidget);
  });

  testWidgets('regression: reopening completed activity awards no second star', (tester) async {
    final s = await scope();
    addTearDown(s.dispose);
    s.activity.start(mannersActivity('adab_eating', 'آداب الطعام'));

    await tester.pumpWidget(app(const AdabScreen(), s));
    await tester.pumpAndSettle();
    await tester.tap(find.text('بِسْمِ اللَّهِ'));
    await tester.pumpAndSettle();

    expect(s.progress.stars, 1);
    expect(s.progress.isCompleted('adab_eating'), isTrue);

    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();

    s.activity.reset();
    s.activity.start(mannersActivity('adab_eating', 'آداب الطعام'));
    await tester.pumpWidget(app(const AdabScreen(), s));
    await tester.pumpAndSettle();

    expect(s.activity.status.name, 'completed');
    expect(s.progress.stars, 1);
    expect(s.progress.isCompleted('adab_eating'), isTrue);
    expect(find.text('أحسنت! 🎉'), findsNothing);
  });
}

class _Scope {
  _Scope(this.progress, this.character, this.activity, this.audio);
  final ProgressProvider progress;
  final CharacterProvider character;
  final ActivityProvider activity;
  final AudioProvider audio;

  void dispose() {
    audio.dispose();
    activity.dispose();
    character.dispose();
    progress.dispose();
  }
}
