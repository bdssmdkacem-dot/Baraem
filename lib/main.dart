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
import 'providers/players_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/purchase_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppErrorHandler.install();
  runGuardedApp(() {
    try {
      final appStateProvider = AppStateProvider();
      final progressProvider = ProgressProvider();
      final playersProvider = PlayersProvider();
      final characterProvider = CharacterProvider()..onAppOpened();
      final purchaseProvider = PurchaseProvider()..onPremiumChanged = (isPremium) => progressProvider.setPremium(isPremium);
      final activityProvider = ActivityProvider(progress: progressProvider, character: characterProvider);
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appStateProvider),
          ChangeNotifierProvider.value(value: progressProvider),
          ChangeNotifierProvider.value(value: playersProvider),
          ChangeNotifierProvider.value(value: characterProvider),
          ChangeNotifierProvider.value(value: purchaseProvider),
          ChangeNotifierProvider.value(value: activityProvider),
          ChangeNotifierProvider(create: (_) => AudioProvider()),
        ],
        child: const BaraemApp(),
      ));
      unawaited(_loadAppState(appStateProvider));
      unawaited(_loadProgress(progressProvider));
      unawaited(playersProvider.load());
      unawaited(_initBilling(purchaseProvider));
    } catch (error, stackTrace) {
      debugPrint('Baraem synchronous startup failure: $error\n$stackTrace');
      runApp(_StartupFailureApp(error: error, stackTrace: stackTrace));
    }
  });
}
Future<void> _loadAppState(AppStateProvider provider) async { try { await provider.load(); } catch (e, s) { if (kDebugMode) debugPrint('AppState load failed: $e\n$s'); } }
Future<void> _loadProgress(ProgressProvider provider) async { try { await provider.load(); } catch (e, s) { if (kDebugMode) debugPrint('Progress load failed: $e\n$s'); } }
Future<void> _initBilling(PurchaseProvider provider) async { try { await provider.init(); } catch (e, s) { if (kDebugMode) debugPrint('Billing startup failed: $e\n$s'); } }
class _StartupFailureApp extends StatelessWidget {
  const _StartupFailureApp({required this.error, required this.stackTrace});
  final Object error; final StackTrace stackTrace;
  @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: SafeArea(child: Directionality(textDirection: TextDirection.rtl, child: Padding(padding: const EdgeInsets.all(24), child: Center(child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.error_outline_rounded, size: 64), const SizedBox(height: 16), const Text('تعذر تشغيل براعم', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 12), const Text('حدث خطأ أثناء بدء التطبيق. أرسل صورة هذه الشاشة للتشخيص.', textAlign: TextAlign.center), const SizedBox(height: 20), SelectableText(error.toString(), textAlign: TextAlign.center), if (kDebugMode) ...[const SizedBox(height: 20), SelectableText(stackTrace.toString(), style: TextStyle(fontSize: 11))]]))))))));
}
