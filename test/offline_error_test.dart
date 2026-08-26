import 'package:flutter_test/flutter_test.dart';

import 'package:baraem/core/offline_guard.dart';

void main() {
  group('OfflineGuard', () {
    test('local operations work without network access', () async {
      final result = await OfflineGuard.local(() => 'Baraem');
      expect(result, 'Baraem');
    });

    test('failed optional operation does not crash the app', () async {
      final result = await OfflineGuard.run<String>(() async {
        throw StateError('simulated offline failure');
      });
      expect(result, isNull);
    });
  });
}
