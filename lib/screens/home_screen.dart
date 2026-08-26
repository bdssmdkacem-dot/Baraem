import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/module_card.dart';
import '../widgets/streak_row.dart';
import 'adkar_screen.dart';
import 'stories_screen.dart';
import 'adab_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.primaryGold),
                        const SizedBox(width: 4),
                        Text(
                          '${progress.stars}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                      ],
                    ),
                    const Text(
                      'براعم',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryMint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const MascotWidget(
                  message: 'أهلاً بك! هيا نتعلم شيئًا جميلًا اليوم 🌟',
                  imageAsset: 'assets/images/mascot/mascot_lion.svg',
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Text(
                      'سلسلتك: ${progress.streakDays} ${progress.streakDays == 1 ? "يوم" : "أيام"}',
                      style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    StreakRow(streakDays: progress.streakDays),
                  ],
                ),
                const SizedBox(height: 28),
                ModuleCard(
                  title: 'أذكاري',
                  subtitle: 'أذكار الصباح والمساء',
                  icon: Icons.wb_sunny_rounded,
                  color: AppColors.primaryMint,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdkarScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                ModuleCard(
                  title: 'قصص الأنبياء',
                  subtitle: 'حكايات جميلة ومفيدة',
                  icon: Icons.auto_stories_rounded,
                  color: AppColors.primaryCoral,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StoriesScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                ModuleCard(
                  title: 'آدابي',
                  subtitle: 'كيف نتصرف بشكل جميل',
                  icon: Icons.favorite_rounded,
                  color: AppColors.primarySky,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdabScreen()),
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
