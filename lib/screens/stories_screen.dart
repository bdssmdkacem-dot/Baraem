import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../data/stories_data.dart';
import '../providers/progress_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/premium_sheet.dart';
import 'story_detail_screen.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('قصص الأنبياء')),
        body: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.85,
          ),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            final locked = story.isPremium && !progress.isPremium;
            final done = progress.isCompleted(story.id);
            return GestureDetector(
              onTap: () {
                if (locked) { PremiumSheet.show(context); return; }
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoryDetailScreen(story: story)));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 10)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(opacity: locked ? 0.35 : 1.0, child: SvgPicture.asset(story.coverAsset, fit: BoxFit.cover)),
                      Positioned(
                        left: 0, right: 0, bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54]),
                          ),
                          child: Text(story.title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ),
                      if (locked) const Positioned(top: 10, left: 10, child: Icon(Icons.lock_rounded, color: Colors.white, size: 22)),
                      if (done) const Positioned(top: 10, left: 10, child: Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
