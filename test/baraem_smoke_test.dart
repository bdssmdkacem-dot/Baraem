// Ce test remplace un ancien placeholder (`expect(true, isTrue)`) qui ne
// vérifiait rien du tout. Il pompe HomeScreen — la route initiale, donc le
// tout premier écran vu par l'utilisateur — avec exactement le même
// MultiProvider que main.dart.
//
// Contexte : un bug (context.watch<CharacterState>() alors que seul
// CharacterProvider est enregistré) faisait planter HomeScreen à CHAQUE
// lancement réel de l'app, alors que `flutter analyze` et tous les autres
// tests passaient — car aucun d'eux ne construisait HomeScreen. Ce test
// comble exactement ce trou.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:baraem/activities/activity_provider.dart';
import 'package:baraem/app.dart';
import 'package:baraem/providers/app_state_provider.dart';
import 'package:baraem/providers/audio_provider.dart';
import 'package:baraem/providers/character_provider.dart';
import 'package:baraem/providers/progress_provider.dart';
import 'package:baraem/providers/purchase_provider.dart';

void main() {
  testWidgets(
    'HomeScreen (route initiale) construit sans ProviderNotFoundException ni ErrorWidget',
    (tester) async {
      final appStateProvider = AppStateProvider();
      final progressProvider = ProgressProvider();
      final characterProvider = CharacterProvider()..onAppOpened();
      final purchaseProvider = PurchaseProvider();
      final activityProvider = ActivityProvider(
        progress: progressProvider,
        character: characterProvider,
      );

      // Sciemment SANS appeler load()/init() : ce sont des Future async
      // (SharedPreferences, billing) qui touchent des platform channels
      // absents en environnement de test. Le vrai premier frame de
      // production ne les attend pas non plus (voir main.dart, `unawaited`) —
      // il se contente des valeurs par défaut des providers.
      await tester.pumpWidget(
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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Le check qui compte réellement : aucun widget d'erreur nulle part
      // dans l'arbre (c'est précisément ce qui serait apparu à la place de
      // BaraemCharacter avec le bug d'origine).
      expect(find.byType(ErrorWidget), findsNothing);

      // Et une confirmation positive que l'écran a bien rendu ses 3 modules.
      expect(find.text('أذكاري'), findsOneWidget);
      expect(find.text('قصص الأنبياء'), findsOneWidget);
      expect(find.text('آدابي'), findsOneWidget);
    },
  );
}
