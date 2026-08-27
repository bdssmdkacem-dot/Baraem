import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../character/character_state.dart';
import '../core/app_scale.dart';
import '../providers/character_provider.dart';
import '../theme/app_colors.dart';

class BaraemCharacter extends StatelessWidget {
  const BaraemCharacter({super.key, this.onTap});

  final VoidCallback? onTap;

  static const _labels = {
    CharacterMood.idle: 'براعم تستقبلك',
    CharacterMood.happy: 'براعم سعيدة بإنجازك',
    CharacterMood.learning: 'براعم تتعلم معك',
    CharacterMood.encourage: 'براعم تشجعك على المحاولة',
    CharacterMood.celebrate: 'براعم تحتفل بنجاحك',
  };

  static const _icons = {
    CharacterMood.idle: Icons.eco_rounded,
    CharacterMood.happy: Icons.sentiment_very_satisfied_rounded,
    CharacterMood.learning: Icons.menu_book_rounded,
    CharacterMood.encourage: Icons.favorite_rounded,
    CharacterMood.celebrate: Icons.celebration_rounded,
  };

  @override
  Widget build(BuildContext context) {
    // Bug fixé : seul CharacterProvider est enregistré dans main.dart
    // (CharacterState est encapsulé à l'intérieur, jamais exposé au
    // widget tree). Demander CharacterState ici levait une
    // ProviderNotFoundException à CHAQUE ouverture de l'app, dès que
    // HomeScreen construisait ce widget — d'où l'écran d'accueil cassé
    // sur le téléphone alors que `flutter test`/`analyze` passaient
    // (aucun test ne pompait HomeScreen).
    final mood = context.watch<CharacterProvider>().mood;
    final scale = AppScale.fontScale(context);

    return Semantics(
      button: onTap != null,
      label: _labels[mood],
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: Container(
            key: ValueKey(mood),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/mascot/mascot_girl.jpg',
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => CircleAvatar(
                          radius: 38,
                          backgroundColor: AppColors.primaryMint,
                          child: Icon(_icons[mood], size: 38, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryMint,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(BorderSide(color: AppColors.surface, width: 2)),
                        ),
                        child: Icon(_icons[mood], size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _labels[mood]!,
                    style: TextStyle(fontSize: 17 * scale, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
