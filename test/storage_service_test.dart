import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:baraem/core/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('storage keeps typed values and defaults', () async {
    final storage = await StorageService.getInstance();

    expect(storage.getBool('missing'), isFalse);
    expect(storage.getInt('missing-int'), 0);
    expect(storage.getStringList('missing-list'), isEmpty);

    await storage.setBool('enabled', true);
    await storage.setInt('stars', 7);
    await storage.setStringList('badges', ['first_star', 'kind']);

    expect(storage.getBool('enabled'), isTrue);
    expect(storage.getInt('stars'), 7);
    expect(storage.getStringList('badges'), ['first_star', 'kind']);
  });

  test('storage returns null instead of crashing on invalid JSON', () async {
    final storage = await StorageService.getInstance();
    await storage.setString('broken', '{not-valid-json');

    final value = storage.getJson<Object?>('broken', (json) => json);

    expect(value, isNull);
  });

  test('storage schema is initialized and migrated', () async {
    final storage = await StorageService.getInstance();
    await storage.migrateIfNeeded();

    expect(storage.schemaVersion, StorageService.currentSchemaVersion);
  });
}
