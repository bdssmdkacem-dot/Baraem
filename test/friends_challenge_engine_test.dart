import 'package:flutter_test/flutter_test.dart';
import 'package:baraem/models/player_profile.dart';
import 'package:baraem/models/story_item.dart';
import 'package:baraem/services/friends_challenge_engine.dart';

void main() {
  const questions = [
    QuizQuestion(question: 'سؤال صغير', options: ['نعم', 'لا'], correctIndex: 0, minAge: 5),
    QuizQuestion(question: 'سؤال متوسط', options: ['نعم', 'لا'], correctIndex: 0, minAge: 8),
    QuizQuestion(question: 'سؤال كبير', options: ['نعم', 'لا'], correctIndex: 0, minAge: 11),
  ];

  test('alternates players and scores correct answers', () {
    const players = [
      PlayerProfile(id: 'a', nickname: 'آدم', age: 6, gender: 'boy'),
      PlayerProfile(id: 'b', nickname: 'سارة', age: 12, gender: 'girl'),
    ];
    final engine = FriendsChallengeEngine(players: players, questions: questions);

    final first = engine.next()!;
    expect(first.player.id, 'a');
    expect(first.question.minAge, 5);
    engine.answer(player: first.player, question: first.question, correct: true);

    final second = engine.next()!;
    expect(second.player.id, 'b');
    expect(second.question.minAge, 11);
    engine.answer(player: second.player, question: second.question, correct: false);

    expect(engine.scores['a'], 1);
    expect(engine.scores['b'], 0);
    expect(engine.isFinished, isFalse);
  });

  test('supports one player and uses that player age', () {
    const player = PlayerProfile(id: 'solo', nickname: 'ليان', age: 12, gender: 'girl');
    final engine = FriendsChallengeEngine(players: const [player], questions: questions);
    final next = engine.next();
    expect(next, isNotNull);
    expect(next!.player.id, 'solo');
    expect(next.question.question, 'سؤال كبير');
  });

  test('supports three players and rotates turns', () {
    const players = [
      PlayerProfile(id: 'a', nickname: 'آدم', age: 6, gender: 'boy'),
      PlayerProfile(id: 'b', nickname: 'سارة', age: 8, gender: 'girl'),
      PlayerProfile(id: 'c', nickname: 'يوسف', age: 12, gender: 'boy'),
    ];
    final engine = FriendsChallengeEngine(players: players, questions: questions);

    final first = engine.next()!;
    expect(first.player.id, 'a');
    expect(first.question.minAge, 5);
    engine.answer(player: first.player, question: first.question, correct: true);

    final second = engine.next()!;
    expect(second.player.id, 'b');
    expect(second.question.minAge, 8);
    engine.answer(player: second.player, question: second.question, correct: true);

    final third = engine.next()!;
    expect(third.player.id, 'c');
    expect(third.question.minAge, 11);
    engine.answer(player: third.player, question: third.question, correct: true);

    expect(engine.scores['a'], 1);
    expect(engine.scores['b'], 1);
    expect(engine.scores['c'], 1);
    expect(engine.isFinished, isTrue);
  });
}
