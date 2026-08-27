import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_routes.dart';
import 'screens/adab_screen.dart';
import 'screens/adkar_screen.dart';
import 'screens/home_screen.dart';
import 'screens/stories_screen.dart';
import 'theme/app_theme.dart';

class BaraemApp extends StatelessWidget {
  const BaraemApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[STARTUP] BaraemApp build');

    final app = MaterialApp(
      title: 'براعم',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateTitle: (context) => 'براعم',
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.adhkar: (_) => const AdkarScreen(),
        AppRoutes.manners: (_) => const AdabScreen(),
        AppRoutes.stories: (_) => const StoriesScreen(),
      },
      initialRoute: AppRoutes.home,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    debugPrint('[STARTUP] MaterialApp created');
    return app;
  }
}
