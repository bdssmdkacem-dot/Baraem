import 'package:flutter/material.dart';

import '../core/app_scale.dart';
import '../theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.fontScale(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحبًا يا بطل! 🌟',
                style: TextStyle(fontSize: 22 * scale, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'ماذا سنتعلم اليوم؟',
                style: TextStyle(
                  fontSize: 14 * scale,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Semantics(
          label: '$stars نجمة',
          container: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: AppColors.primaryGold),
                const SizedBox(width: 4),
                Text('$stars', style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
