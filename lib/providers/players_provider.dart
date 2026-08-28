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

  Future<void> _save() async {
    await _prefs.setString(_key, jsonEncode(players.map((p) => {
      'id': p.id,
      'nickname': p.nickname,
      'age': p.age,
      'gender': p.gender,
    }).toList()));
  }
}
