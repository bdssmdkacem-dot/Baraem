import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gère la boucle "addictive" saine : étoiles, streak quotidien,
/// contenu débloqué. Pas de minuteur agressif ni de notif culpabilisante -
/// juste un renforcement positif adapté à un public 2-6 ans.
class ProgressProvider extends ChangeNotifier {
  static const _kStars = 'baraem_stars';
  static const _kStreak = 'baraem_streak';
  static const _kLastActiveDay = 'baraem_last_active_day';
  static const _kCompletedIds = 'baraem_completed_ids';
  static const _kIsPremium = 'baraem_is_premium';

  int stars = 0;
  int streakDays = 0;
  DateTime? lastActiveDay;
  Set<String> completedIds = {};
  bool isPremium = false;

  late SharedPreferences _prefs;
  bool _loaded = false;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    stars = _prefs.getInt(_kStars) ?? 0;
    streakDays = _prefs.getInt(_kStreak) ?? 0;
    isPremium = _prefs.getBool(_kIsPremium) ?? false;

    final lastActiveStr = _prefs.getString(_kLastActiveDay);
    lastActiveDay = lastActiveStr != null ? DateTime.tryParse(lastActiveStr) : null;

    final completedRaw = _prefs.getString(_kCompletedIds);
    if (completedRaw != null) {
      completedIds = Set<String>.from(jsonDecode(completedRaw) as List);
    }

    _loaded = true;
    _updateStreakOnOpen();
    notifyListeners();
  }

  /// Appelé à l'ouverture de l'app : incrémente le streak si c'est un
  /// nouveau jour consécutif, le remet à zéro si un jour a été sauté.
  void _updateStreakOnOpen() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastActiveDay == null) {
      streakDays = 1;
    } else {
      final last = DateTime(
        lastActiveDay!.year,
        lastActiveDay!.month,
        lastActiveDay!.day,
      );
      final diff = today.difference(last).inDays;
      if (diff == 0) {
        // déjà compté aujourd'hui
      } else if (diff == 1) {
        streakDays += 1;
      } else if (diff > 1) {
        streakDays = 1;
      }
    }

    lastActiveDay = today;
    _prefs.setInt(_kStreak, streakDays);
    _prefs.setString(_kLastActiveDay, today.toIso8601String());
  }

  Future<void> markCompleted(String itemId, {int starsAwarded = 1}) async {
    if (completedIds.contains(itemId)) return;
    completedIds.add(itemId);
    stars += starsAwarded;
    await _prefs.setInt(_kStars, stars);
    await _prefs.setString(_kCompletedIds, jsonEncode(completedIds.toList()));
    notifyListeners();
  }

  bool isCompleted(String itemId) => completedIds.contains(itemId);

  Future<void> setPremium(bool value) async {
    isPremium = value;
    await _prefs.setBool(_kIsPremium, value);
    notifyListeners();
  }
}
