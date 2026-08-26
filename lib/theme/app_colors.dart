import 'package:flutter/material.dart';

/// Palette douce et ludique pour un public 2-6 ans.
/// Contraste avec Aqim (vert foncé/or, registre "adulte") :
/// ici on reste sur des teintes pastel vives, très lisibles pour un enfant.
class AppColors {
  AppColors._();

  // Couleurs de marque
  static const Color primaryMint = Color(0xFF3DC9A0); // module أذكار
  static const Color primaryCoral = Color(0xFFFF8A65); // module قصص الأنبياء
  static const Color primarySky = Color(0xFF4FB3E8); // module آداب
  static const Color primaryGold = Color(0xFFFFC94A); // étoiles / récompenses

  // Fond
  static const Color background = Color(0xFFFFF8EE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFFF1DC);

  // Texte
  static const Color textDark = Color(0xFF3A2E2A);
  static const Color textMuted = Color(0xFF8A7B74);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // États
  static const Color locked = Color(0xFFC9C1BB);
  static const Color success = Color(0xFF4CAF7D);
  static const Color streakActive = Color(0xFFFFC94A);
  static const Color streakInactive = Color(0xFFEDE6DD);

  static const List<Color> mascotGradient = [
    Color(0xFF3DC9A0),
    Color(0xFF4FB3E8),
  ];
}
