import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Installs process-wide Flutter error handling without exposing technical
/// details to children. Errors are logged in debug mode and the UI falls back
/// to a friendly Arabic error screen when a build error reaches ErrorWidget.
class AppErrorHandler {
  AppErrorHandler._();

  static void install() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kReleaseMode) {
        debugPrint('Baraem Flutter error: ${details.exception}');
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('Baraem uncaught error: $error');
      return true;
    };

    ErrorWidget.builder = (_) => const _FriendlyErrorWidget();
  }
}

class _FriendlyErrorWidget extends StatelessWidget {
  const _FriendlyErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.sentiment_dissatisfied_rounded, size: 56),
                SizedBox(height: 12),
                Text(
                  'حدث خطأ بسيط، حاول مرة أخرى',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void runGuardedApp(FutureOr<void> Function() action) {
  runZonedGuarded(action, (error, stack) {
    debugPrint('Baraem zone error: $error');
  });
}
