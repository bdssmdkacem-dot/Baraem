import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/audio_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/purchase_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: si tu gardes google_mobile_ads, initialise-le ici :
  // await MobileAds.instance.initialize();

  final progressProvider = ProgressProvider();
  await progressProvider.load();

  // Branche le flow d'achat sur la progression : dès qu'un achat est
  // confirmé (ou restauré), on débloque tout le contenu premium.
  final purchaseProvider = PurchaseProvider()
    ..onPremiumChanged = (isPremium) => progressProvider.setPremium(isPremium);
  unawaited(purchaseProvider.init());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: progressProvider),
        ChangeNotifierProvider.value(value: purchaseProvider),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const BaraemApp(),
    ),
  );
}
