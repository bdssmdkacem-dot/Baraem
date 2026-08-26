import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/app_error_handler.dart';
import 'providers/app_state_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/purchase_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppErrorHandler.install();

  runGuardedApp(() async {
    final appStateProvider = AppStateProvider();
    await appStateProvider.load();

    final progressProvider = ProgressProvider();
    await progressProvider.load();

    final purchaseProvider = PurchaseProvider()
      ..onPremiumChanged = (isPremium) => progressProvider.setPremium(isPremium);
    unawaited(purchaseProvider.init());

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appStateProvider),
          ChangeNotifierProvider.value(value: progressProvider),
          ChangeNotifierProvider.value(value: purchaseProvider),
          ChangeNotifierProvider(create: (_) => AudioProvider()),
        ],
        child: const BaraemApp(),
      ),
    );
  });
}
