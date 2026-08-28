import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/app_routes.dart';
import 'providers/progress_provider.dart';
import 'screens/adab_screen.dart';
import 'screens/adkar_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/stories_screen.dart';
import 'theme/app_theme.dart';

class BaraemApp extends StatelessWidget {
  const BaraemApp({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProgressProvider>();
    return MaterialApp(
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
        '/profile-setup': (_) => const ProfileSetupScreen(),
      },
      initialRoute: profile.profileCompleted ? AppRoutes.home : '/profile-setup',
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
