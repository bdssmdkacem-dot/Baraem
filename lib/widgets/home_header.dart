import 'package:flutter/material.dart';

import '../core/app_scale.dart';
import 'star_counter.dart';

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
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        StarCounter(stars: stars),
      ],
    );
  }
}
