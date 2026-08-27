import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../activities/activity_definitions.dart';
import '../activities/activity_models.dart';
import '../activities/activity_provider.dart';
import '../core/app_scale.dart';
import '../providers/progress_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/baraem_character.dart';
import '../widgets/daily_activity_card.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/encouragement_card.dart';
import '../widgets/home_header.dart';
import '../widgets/module_card.dart';
import '../widgets/streak_row.dart';
import 'adab_screen.dart';
import 'adkar_screen.dart';
import 'stories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openActivity(BuildContext context, ActivityDefinition activity, Widget screen) {
    context.read<ActivityProvider>().start(activity);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[STARTUP] HomeScreen build');

    final progress = context.watch<ProgressProvider>();
    final width = AppScale.width(context);
    // Match the reference phone layout while keeping the existing
    // responsive behavior on smaller phones and tablets.
    final horizontalPadding = (width * 0.055).clamp(20.0, 48.0);
    final imageHeight = (width * 0.42).clamp(150.0, 290.0);
    final scale = AppScale.fontScale(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppScale.contentMaxWidth(context)),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeHeader(stars: progress.stars),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/images/home/home_illustration.jpg',
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const BaraemCharacter(),
                  const SizedBox(height: 18),
                  DailyProgressCard(completed: progress.dailyCompletedCount),
                  const SizedBox(height: 14),
                  EncouragementCard(completed: progress.dailyCompletedCount),
                  const SizedBox(height: 18),
                  Semantics(
                    container: true,
                    label: 'سلسلتك ${progress.streakDays} ${progress.streakDays == 1 ? "يوم" : "أيام"}',
                    child: Column(
                      children: [
                        Text(
                          'سلسلتك: ${progress.streakDays} ${progress.streakDays == 1 ? "يوم" : "أيام"}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 9),
                        StreakRow(streakDays: progress.streakDays),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  DailyActivityCard(
                    onStart: () => _openActivity(
                      context,
                      adhkarActivity('daily_adhkar', 'ذكر اليوم'),
                      const AdkarScreen(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'اكتشف وتعلّم',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 24 * scale,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ModuleCard(
                    title: 'أذكاري',
                    subtitle: 'أذكار الصباح والمساء',
                    icon: Icons.wb_sunny_rounded,
                    color: AppColors.primaryMint,
                    onTap: () => _openActivity(
                      context,
                      adhkarActivity('adhkar', 'أذكاري'),
                      const AdkarScreen(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ModuleCard(
                    title: 'قصص الأنبياء',
                    subtitle: 'حكايات جميلة ومفيدة',
                    icon: Icons.auto_stories_rounded,
                    color: AppColors.primaryCoral,
                    onTap: () => _openActivity(
                      context,
                      storyActivity('stories', 'قصص الأنبياء'),
                      const StoriesScreen(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ModuleCard(
                    title: 'آدابي',
                    subtitle: 'كيف نتصرف بشكل جميل',
                    icon: Icons.favorite_rounded,
                    color: AppColors.primarySky,
                    onTap: () => _openActivity(
                      context,
                      mannersActivity('manners', 'آدابي'),
                      const AdabScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
