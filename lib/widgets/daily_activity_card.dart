import 'package:flutter/material.dart';

import '../core/app_scale.dart';
import '../theme/app_colors.dart';

class DailyActivityCard extends StatelessWidget {
  const DailyActivityCard({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.fontScale(context);
    return Semantics(
      container: true,
      label: 'نشاط اليوم: تعلم ذكرًا جميلًا',
      child: Material(
        color: AppColors.primaryMint,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onStart,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryMint, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نشاط اليوم',
                        style: TextStyle(fontSize: 13 * scale, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'هيا نتعلم ذكرًا جميلًا',
                        style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_back_rounded, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
