import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local progress and the child's profile used to personalize learning.
class ProgressProvider extends ChangeNotifier {
  static const _kStars = 'baraem_stars';
  static const _kStreak = 'baraem_streak';
  static const _kLastActiveDay = 'baraem_last_active_day';
  static const _kCompletedIds = 'baraem_completed_ids';
  static const _kCompletedTodayIds = 'baraem_completed_today_ids';
  static const _kCompletedTodayDate = 'baraem_completed_today_date';
  static const _kIsPremium = 'baraem_is_premium';
  static const _kChildAge = 'baraem_child_age';
  static const _kChildNickname = 'baraem_child_nickname';
  static const _kChildGender = 'baraem_child_gender';
  static const _kProfileCompleted = 'baraem_profile_completed';

  int stars = 0;
  int streakDays = 0;
  int childAge = 6;
  String childNickname = '';
  String? childGender;
  bool profileCompleted = false;
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
    childAge = (_prefs.getInt(_kChildAge) ?? 6).clamp(2, 13);
    childNickname = _prefs.getString(_kChildNickname) ?? '';
    childGender = _prefs.getString(_kChildGender);
    profileCompleted = _prefs.getBool(_kProfileCompleted) ?? false;
    final lastActiveStr = _prefs.getString(_kLastActiveDay);
    lastActiveDay = lastActiveStr != null ? DateTime.tryParse(lastActiveStr) : null;
    final completedRaw = _prefs.getString(_kCompletedIds);
    if (completedRaw != null && completedRaw.isNotEmpty) {
      try {
        final decoded = jsonDecode(completedRaw);
        completedIds = decoded is List ? decoded.whereType<String>().toSet() : {};
      } catch (_) {
        completedIds = {};
      }
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
      completedTodayIds = decoded is List ? decoded.whereType<String>().toSet() : {};
    } catch (_) {
      completedTodayIds = {};
    }
  }

  String _dayKey(DateTime date) => '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  void _updateStreakOnOpen() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (lastActiveDay == null) {
      streakDays = 1;
    } else {
      final last = DateTime(lastActiveDay!.year, lastActiveDay!.month, lastActiveDay!.day);
      final diff = today.difference(last).inDays;
      if (diff == 1) {
        streakDays += 1;
      }
      if (diff > 1) {
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
    stars += starsAwarded.clamp(0, 5);
    await _prefs.setInt(_kStars, stars);
    await _prefs.setString(_kCompletedIds, jsonEncode(completedIds.toList()));
    await _prefs.setString(_kCompletedTodayDate, _dayKey(DateTime.now()));
    await _prefs.setString(_kCompletedTodayIds, jsonEncode(completedTodayIds.toList()));
    notifyListeners();
  }

  bool isCompleted(String itemId) => completedIds.contains(itemId);
  int get dailyCompletedCount => completedTodayIds.length;

  Future<void> setChildProfile({required String nickname, required int age, required String gender}) async {
    childNickname = nickname.trim();
    childAge = age.clamp(2, 13);
    childGender = gender;
    profileCompleted = true;
    await _prefs.setString(_kChildNickname, childNickname);
    await _prefs.setInt(_kChildAge, childAge);
    await _prefs.setString(_kChildGender, childGender!);
    await _prefs.setBool(_kProfileCompleted, true);
    notifyListeners();
  }

  Future<void> setChildAge(int age) async {
    childAge = age.clamp(2, 13);
    await _prefs.setInt(_kChildAge, childAge);
    notifyListeners();
  }

  Future<void> setPremium(bool value) async {
    isPremium = value;
    await _prefs.setBool(_kIsPremium, value);
    notifyListeners();
  }
}
