import 'dart:async';

/// Runs a local operation without ever requiring network access.
/// Network-dependent features can opt into this guard later.
class OfflineGuard {
  OfflineGuard._();

  static Future<T?> run<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (_) {
      return null;
    }
  }

  static Future<T> local<T>(T Function() operation) async {
    return operation();
  }
}
