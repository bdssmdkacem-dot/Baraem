import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Ligne de 7 cercles représentant les 7 derniers jours.
/// Simple, lisible pour un enfant, pas de logique de culpabilisation.
class StreakRow extends StatelessWidget {
  final int streakDays;

  const StreakRow({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final activeCount = streakDays.clamp(0, 7);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (i) {
        final isActive = i < activeCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.streakActive : AppColors.streakInactive,
            ),
            child: isActive
                ? const Icon(Icons.star_rounded, size: 16, color: Colors.white)
                : null,
          ),
        );
      }),
    );
  }
}
