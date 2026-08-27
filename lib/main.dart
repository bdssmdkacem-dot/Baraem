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
  WidgetsFlutterBinding.ensureInitialized();
  AppErrorHandler.install();

  runGuardedApp(() {
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

    // Start the UI immediately. Local storage and Google Play Billing are
    // optional startup work and must never prevent Baraem from reaching Home.
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

    // Load persisted state after the first frame. Each operation is isolated
    // so one broken/unsupported local service cannot block the whole app.
    unawaited(_loadAppState(appStateProvider));
    unawaited(_loadProgress(progressProvider));
    unawaited(_initBilling(purchaseProvider));
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
    // Billing is optional. PurchaseProvider already handles normal failures;
    // this final boundary protects startup from unexpected plugin errors.
    if (kDebugMode) {
      debugPrint('Baraem billing startup failed: $error\n$stackTrace');
    }
  }
}
