// Smoke test for the real initial route after profile initialization.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      SharedPreferences.setMockInitialValues({
        'baraem_profile_completed': true,
        'baraem_child_nickname': 'براعم',
        'baraem_child_age': 6,
        'baraem_child_gender': 'male',
      });

      final appStateProvider = AppStateProvider();
      final progressProvider = ProgressProvider();
      await progressProvider.load();
      final characterProvider = CharacterProvider()..onAppOpened();
      final purchaseProvider = PurchaseProvider();
      final activityProvider = ActivityProvider(
        progress: progressProvider,
        character: characterProvider,
      );

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

      expect(find.byType(ErrorWidget), findsNothing);
      expect(find.text('أذكاري'), findsOneWidget);
      expect(find.text('قصص الأنبياء'), findsOneWidget);
      expect(find.text('آدابي'), findsOneWidget);
    },
  );
}
