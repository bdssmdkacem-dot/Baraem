import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Petite célébration à afficher (via showDialog ou overlay) quand
/// l'enfant termine un dhikr / une histoire / un scénario adab.
/// Volontairement courte et non-intrusive : pas d'écran plein, pas
/// de minuteur, pas de pression - juste un feedback positif rapide.
class StarRewardOverlay extends StatefulWidget {
  final VoidCallback onDone;

  const StarRewardOverlay({super.key, required this.onDone});

  @override
  State<StarRewardOverlay> createState() => _StarRewardOverlayState();
}

class _StarRewardOverlayState extends State<StarRewardOverlay> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(milliseconds: 900));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: -pi / 2,
          numberOfParticles: 18,
          maxBlastForce: 12,
          minBlastForce: 6,
          colors: const [
            AppColors.primaryGold,
            AppColors.primaryMint,
            AppColors.primaryCoral,
            AppColors.primarySky,
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: AppColors.primaryGold, size: 64),
              const SizedBox(height: 8),
              const Text(
                'أحسنت! 🎉',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onDone,
                child: const Text('متابعة'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
