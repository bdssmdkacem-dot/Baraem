import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Single entry point for Baraem's local persistence.
/// Keeps storage keys and serialization out of UI code.
class StorageService {
  StorageService._(this._prefs);

  static const int currentSchemaVersion = 1;
  static const String _schemaVersionKey = 'baraem_storage_schema_version';

  final SharedPreferences _prefs;
  static StorageService? _instance;

  static Future<StorageService> getInstance() async {
    return _instance ??= StorageService._(
      await SharedPreferences.getInstance(),
    );
  }

  @visibleForTesting
  static void resetForTesting() {
    _instance = null;
  }

  int get schemaVersion =>
      _prefs.getInt(_schemaVersionKey) ?? currentSchemaVersion;

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  int getInt(String key, {int defaultValue = 0}) =>
      _prefs.getInt(key) ?? defaultValue;

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  List<String> getStringList(String key) =>
      _prefs.getStringList(key) ?? const [];

  Future<bool> setJson(String key, Object value) =>
      _prefs.setString(key, jsonEncode(value));

  T? getJson<T>(String key, T Function(Object? json) decoder) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;

    try {
      return decoder(jsonDecode(raw));
    } catch (_) {
      // Corrupt or incompatible local data must never crash the app.
      return null;
    }
  }

  Future<bool> remove(String key) => _prefs.remove(key);

  Future<bool> clear() => _prefs.clear();

  Future<void> migrateIfNeeded() async {
    final stored = _prefs.getInt(_schemaVersionKey);
    if (stored == null || stored < currentSchemaVersion) {
      await _prefs.setInt(_schemaVersionKey, currentSchemaVersion);
    }
  }
}
