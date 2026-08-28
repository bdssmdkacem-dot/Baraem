import '../models/player_profile.dart';
import '../models/story_item.dart';
import 'adaptive_quiz_engine.dart';

class ChallengeQuestion {
  const ChallengeQuestion({required this.player, required this.question});
  final PlayerProfile player;
  final QuizQuestion question;
}

class FriendsChallengeEngine {
  FriendsChallengeEngine({required this.players, required this.questions}) : _remaining = List<QuizQuestion>.from(questions);

  final List<PlayerProfile> players;
  final List<QuizQuestion> _remaining;
  final Map<String, int> scores = {};
  int _turn = 0;

  bool get isFinished => _remaining.isEmpty;

  ChallengeQuestion? next() {
    if (players.length < 2 || _remaining.isEmpty) return null;
    final player = players[_turn % players.length];
    final adaptive = AdaptiveQuizEngine.selectQuestions(age: player.age, gender: player.gender, stars: scores[player.id] ?? 0, completedCount: 0, questions: _remaining);
    if (adaptive.isEmpty) return null;
    return ChallengeQuestion(player: player, question: adaptive.first);
  }

  void answer({required PlayerProfile player, required QuizQuestion question, required bool correct}) {
    _remaining.remove(question);
    if (correct) scores[player.id] = (scores[player.id] ?? 0) + 1;
    _turn++;
  }
}
