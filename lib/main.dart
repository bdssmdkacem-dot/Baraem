import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'activities/activity_provider.dart';
import 'core/app_error_handler.dart';
import 'providers/app_state_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/character_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/purchase_provider.dart';

Future<void> main() async {
  debugPrint('[STARTUP] main entered');
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[STARTUP] Flutter binding ready');
  AppErrorHandler.install();

  runGuardedApp(() {
    try {
      final appStateProvider = AppStateProvider();
      final progressProvider = ProgressProvider();
      final characterProvider = CharacterProvider()..onAppOpened();

      final purchaseProvider = PurchaseProvider()
        ..onPremiumChanged =
            (isPremium) => progressProvider.setPremium(isPremium);

      final activityProvider = ActivityProvider(
        progress: progressProvider,
        character: characterProvider,
      );
      debugPrint('[STARTUP] providers created');

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: appStateProvider),
            ChangeNotifierProvider.value(value: progressProvider),
            ChangeNotifierProvider.value(value: characterProvider),
            ChangeNotifierProvider.value(value: purchaseProvider),
            ChangeNotifierProvider.value(value: activityProvider),
            ChangeNotifierProvider(create: (_) => AudioProvider()),
          ],
          child: const BaraemApp(),
        ),
      );
      debugPrint('[STARTUP] runApp');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('[STARTUP] first frame');
      });

      // Startup services are optional and isolated from the first UI frame.
      unawaited(_loadAppState(appStateProvider));
      unawaited(_loadProgress(progressProvider));
      unawaited(_initBilling(purchaseProvider));
    } catch (error, stackTrace) {
      debugPrint('Baraem synchronous startup failure: $error\n$stackTrace');
      runApp(_StartupFailureApp(error: error, stackTrace: stackTrace));
    }
  });
}

Future<void> _loadAppState(AppStateProvider provider) async {
  try {
    await provider.load();
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('Baraem AppState startup load failed: $error\n$stackTrace');
    }
  }
}

Future<void> _loadProgress(ProgressProvider provider) async {
  try {
    await provider.load();
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('Baraem progress startup load failed: $error\n$stackTrace');
    }
  }
}

Future<void> _initBilling(PurchaseProvider provider) async {
  try {
    await provider.init();
  } catch (error, stackTrace) {
    if (kDebugMode) {
      debugPrint('Baraem billing startup failed: $error\n$stackTrace');
    }
  }
}

class _StartupFailureApp extends StatelessWidget {
  const _StartupFailureApp({required this.error, required this.stackTrace});

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 64),
                      const SizedBox(height: 16),
                      const Text(
                        'تعذر تشغيل براعم',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'حدث خطأ أثناء بدء التطبيق. أرسل صورة هذه الشاشة للتشخيص.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SelectableText(
                        error.toString(),
                        textAlign: TextAlign.center,
                      ),
                      if (kDebugMode) ...[
                        const SizedBox(height: 20),
                        SelectableText(
                          stackTrace.toString(),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
