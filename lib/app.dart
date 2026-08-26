import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

class BaraemApp extends StatelessWidget {
  const BaraemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'براعم',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        // Ajoute flutter_localizations si tu veux les widgets Material/Cupertino
        // localisés en arabe (dates, boutons système, etc.) :
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Force le RTL sur toute l'app, indépendamment de la langue système.
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomeScreen(),
    );
  }
}
