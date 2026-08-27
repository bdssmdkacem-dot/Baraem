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
  static const _kCompletedTodayIds = 'baraem_completed_today_ids';
  static const _kCompletedTodayDate = 'baraem_completed_today_date';
  static const _kIsPremium = 'baraem_is_premium';

  int stars = 0;
  int streakDays = 0;
  DateTime? lastActiveDay;
  Set<String> completedIds = {};
  Set<String> completedTodayIds = {};
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

    // Local storage may contain data written by an older version or become
    // corrupted. Never let malformed completed IDs prevent app startup.
    final completedRaw = _prefs.getString(_kCompletedIds);
    if (completedRaw != null && completedRaw.isNotEmpty) {
      try {
        final decoded = jsonDecode(completedRaw);
        completedIds = decoded is List
            ? decoded.whereType<String>().toSet()
            : {};
      } catch (_) {
        completedIds = {};
      }
    } else {
      completedIds = {};
    }

    _loadTodayCompletions();
    _loaded = true;
    _updateStreakOnOpen();
    notifyListeners();
  }

  void _loadTodayCompletions() {
    final storedDate = _prefs.getString(_kCompletedTodayDate);
    final today = _dayKey(DateTime.now());
    final raw = _prefs.getString(_kCompletedTodayIds);

    if (storedDate != today || raw == null) {
      completedTodayIds = {};
      _prefs.setString(_kCompletedTodayDate, today);
      _prefs.setString(_kCompletedTodayIds, jsonEncode(<String>[]));
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      completedTodayIds = decoded is List
          ? decoded.whereType<String>().toSet()
          : {};
    } catch (_) {
      completedTodayIds = {};
    }
  }

  String _dayKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

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
    completedTodayIds.add(itemId);
    stars += starsAwarded;
    await _prefs.setInt(_kStars, stars);
    await _prefs.setString(_kCompletedIds, jsonEncode(completedIds.toList()));
    await _prefs.setString(_kCompletedTodayDate, _dayKey(DateTime.now()));
    await _prefs.setString(_kCompletedTodayIds, jsonEncode(completedTodayIds.toList()));
    notifyListeners();
  }

  bool isCompleted(String itemId) => completedIds.contains(itemId);

  int get dailyCompletedCount => completedTodayIds.length;

  Future<void> setPremium(bool value) async {
    isPremium = value;
    await _prefs.setBool(_kIsPremium, value);
    notifyListeners();
  }
}
