import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_profile.dart';

class PlayersProvider extends ChangeNotifier {
  static const _key = 'baraem_players_v1';
  final List<PlayerProfile> players = [];
  late SharedPreferences _prefs;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_key);
    if (raw != null) {
      try {
        final data = jsonDecode(raw);
        if (data is List) {
          players
            ..clear()
            ..addAll(data.whereType<Map>().map((item) => PlayerProfile(
              id: item['id']?.toString() ?? '',
              nickname: item['nickname']?.toString() ?? '',
              age: ((item['age'] as num?)?.toInt() ?? 6).clamp(2, 13),
              gender: item['gender']?.toString() ?? 'boy',
              stars: (item['stars'] as num?)?.toInt() ?? 0,
              challengesPlayed: (item['challengesPlayed'] as num?)?.toInt() ?? 0,
              challengesWon: (item['challengesWon'] as num?)?.toInt() ?? 0,
              questionsAnswered: (item['questionsAnswered'] as num?)?.toInt() ?? 0,
              correctAnswers: (item['correctAnswers'] as num?)?.toInt() ?? 0,
            )).where((p) => p.id.isNotEmpty && p.nickname.isNotEmpty));
        }
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> add(PlayerProfile player) async {
    if (players.length >= 4) return;
    players.add(player);
    await _save();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    players.removeWhere((p) => p.id == id);
    await _save();
    notifyListeners();
  }

  PlayerProfile? getById(String id) => players.cast<PlayerProfile?>().firstWhere((p) => p?.id == id, orElse: () => null);

  Future<void> recordQuestionResult({required String playerId, required bool correct}) async {
    final index = players.indexWhere((p) => p.id == playerId);
    if (index < 0) return;
    final player = players[index];
    players[index] = player.copyWith(
      stars: player.stars + (correct ? 1 : 0),
      questionsAnswered: player.questionsAnswered + 1,
      correctAnswers: player.correctAnswers + (correct ? 1 : 0),
    );
    await _save();
    notifyListeners();
  }

  Future<void> recordChallengeResult({required Map<String, int> scores}) async {
    if (scores.isEmpty) return;
    var best = -1;
    for (final score in scores.values) {
      if (score > best) best = score;
    }
    for (var i = 0; i < players.length; i++) {
      final player = players[i];
      final score = scores[player.id] ?? 0;
      final won = score == best && best > 0;
      players[i] = player.copyWith(
        stars: player.stars + score,
        challengesPlayed: player.challengesPlayed + 1,
        challengesWon: player.challengesWon + (won ? 1 : 0),
      );
    }
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs.setString(_key, jsonEncode(players.map((p) => {
      'id': p.id,
      'nickname': p.nickname,
      'age': p.age,
      'gender': p.gender,
      'stars': p.stars,
      'challengesPlayed': p.challengesPlayed,
      'challengesWon': p.challengesWon,
      'questionsAnswered': p.questionsAnswered,
      'correctAnswers': p.correctAnswers,
    }).toList()));
  }
}
