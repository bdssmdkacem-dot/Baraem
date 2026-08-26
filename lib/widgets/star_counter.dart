import 'package:flutter/material.dart';

import '../core/app_scale.dart';
import '../theme/app_colors.dart';

/// A child-friendly, accessible display of the stars earned in Baraem.
class StarCounter extends StatelessWidget {
  const StarCounter({super.key, required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.fontScale(context);
    final label = stars == 1 ? 'نجمة واحدة' : '$stars نجوم';

    return Semantics(
      container: true,
      label: label,
      value: '$stars',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12 * scale,
          vertical: 8 * scale,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.22)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              size: 24 * scale,
              color: AppColors.primaryGold,
            ),
            SizedBox(width: 5 * scale),
            Text(
              '$stars',
              style: TextStyle(
                fontSize: 16 * scale,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
