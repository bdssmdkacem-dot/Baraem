import 'package:flutter/material.dart';

import '../core/app_scale.dart';
import '../theme/app_colors.dart';

class DailyProgressCard extends StatelessWidget {
  const DailyProgressCard({
    super.key,
    required this.completed,
    this.goal = 3,
  });

  final int completed;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.fontScale(context);
    final safeGoal = goal < 1 ? 1 : goal;
    final safeCompleted = completed.clamp(0, safeGoal);
    final progress = safeCompleted / safeGoal;
    final done = safeCompleted >= safeGoal;

    return Semantics(
      container: true,
      label: 'تقدم اليوم: $safeCompleted من $safeGoal',
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.flag_rounded, color: AppColors.primaryGold, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    done ? 'أكملت هدف اليوم! 🎉' : 'تقدم اليوم',
                    style: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  '$safeCompleted/$safeGoal',
                  style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: AppColors.streakInactive,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              done ? 'رائع! أنت جاهز لنشاط جديد.' : 'خطوة صغيرة كل يوم تصنع فرقًا جميلًا.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13 * scale, color: AppColors.textMuted, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
