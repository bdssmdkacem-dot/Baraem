import 'package:flutter/material.dart';

import '../core/app_scale.dart';
import '../theme/app_colors.dart';

class EncouragementCard extends StatelessWidget {
  const EncouragementCard({super.key, required this.completed, this.goal = 3});

  final int completed;
  final int goal;

  String get message {
    if (completed >= goal) return 'رائع! أنجزت هدف اليوم 🌟';
    if (completed == 0) return 'هيا يا بطل! لنبدأ بخطوة صغيرة 💛';
    if (completed == 1) return 'أحسنت! نجمة أولى، هل نكمل؟ ⭐';
    return 'ممتاز! أنت قريب جدًا من هدف اليوم 🚀';
  }

  @override
  Widget build(BuildContext context) {
    final scale = AppScale.fontScale(context);
    return Semantics(
      container: true,
      label: message,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.surfaceAlt),
        ),
        child: Row(
          children: [
            const Text('🌱', style: TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15 * scale,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
