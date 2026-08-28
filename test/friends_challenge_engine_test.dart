import 'package:flutter_test/flutter_test.dart';
import 'package:baraem/models/player_profile.dart';
import 'package:baraem/models/story_item.dart';
import 'package:baraem/services/friends_challenge_engine.dart';

void main() {
  test('alternates players and scores correct answers', () {
    const players = [
      PlayerProfile(id: 'a', nickname: 'آدم', age: 6, gender: 'boy'),
      PlayerProfile(id: 'b', nickname: 'سارة', age: 12, gender: 'girl'),
    ];
    const questions = [
      QuizQuestion(question: 'سؤال صغير', options: ['نعم', 'لا'], correctIndex: 0, minAge: 5),
      QuizQuestion(question: 'سؤال كبير', options: ['نعم', 'لا'], correctIndex: 0, minAge: 11),
    ];
    final engine = FriendsChallengeEngine(players: players, questions: questions);

    final first = engine.next()!;
    expect(first.player.id, 'a');
    engine.answer(player: first.player, question: first.question, correct: true);

    final second = engine.next()!;
    expect(second.player.id, 'b');
    engine.answer(player: second.player, question: second.question, correct: false);

    expect(engine.scores['a'], 1);
    expect(engine.scores['b'], 0);
    expect(engine.isFinished, isTrue);
  });
}
