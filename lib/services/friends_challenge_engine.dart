import '../models/player_profile.dart';
import '../models/story_item.dart';
import 'adaptive_quiz_engine.dart';

class ChallengeQuestion {
  const ChallengeQuestion({required this.player, required this.question});

  final PlayerProfile player;
  final QuizQuestion question;
}

class FriendsChallengeEngine {
  FriendsChallengeEngine({required this.players, required List<QuizQuestion> questions})
      : _remaining = List<QuizQuestion>.from(questions) {
    for (final player in players) {
      scores[player.id] = 0;
    }
  }

  final List<PlayerProfile> players;
  final List<QuizQuestion> _remaining;
  final Map<String, int> scores = {};
  final AdaptiveQuizEngine _quizEngine = const AdaptiveQuizEngine();
  int _turn = 0;

  bool get isFinished => _remaining.isEmpty;

  ChallengeQuestion? next() {
    if (players.isEmpty || _remaining.isEmpty) return null;

    final player = players[_turn % players.length];
    var selected = _quizEngine.select(
      questions: _remaining,
      age: player.age,
      stars: scores[player.id] ?? 0,
      completedIds: const <String>{},
      storyId: 'friends_nuh',
    );

    // A shared-phone challenge must keep rotating even when the remaining
    // pool has no exact age-band match. Use the nearest available question
    // rather than ending the whole session for that player.
    if (selected.isEmpty) {
      final sorted = List<QuizQuestion>.from(_remaining)
        ..sort((a, b) => (a.minAge - player.age).abs().compareTo((b.minAge - player.age).abs()));
      selected = sorted.take(1).toList(growable: false);
    }

    if (selected.isEmpty) return null;
    return ChallengeQuestion(player: player, question: selected.first);
  }

  void answer({required PlayerProfile player, required QuizQuestion question, required bool correct}) {
    _remaining.remove(question);
    if (correct) {
      scores[player.id] = (scores[player.id] ?? 0) + 1;
    } else {
      scores.putIfAbsent(player.id, () => 0);
    }
    _turn++;
  }
}
