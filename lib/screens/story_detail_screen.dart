import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../activities/activity_definitions.dart';
import '../activities/activity_provider.dart';
import '../activities/next_activity_selector.dart';
import '../data/stories_data.dart';
import '../models/story_item.dart';
import '../providers/audio_provider.dart';
import '../providers/progress_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/star_reward_overlay.dart';

class StoryDetailScreen extends StatefulWidget {
  final StoryItem story;
  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int? _selectedQuizOption;
  bool _completedActivity = false;
  bool _activityStarted = false;

  bool get _isLastPage => _currentPage == widget.story.pages.length - 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_activityStarted) return;
    _activityStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ActivityProvider>().start(
        storyActivity(widget.story.id, widget.story.title),
      );
    });
  }

  Future<void> _next() async {
    if (_currentPage < widget.story.pages.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else if (widget.story.quiz.isEmpty) {
      await _finishStory();
    }
  }

  Future<void> _finishStory() async {
    if (_completedActivity) return;

    final result = await context.read<ActivityProvider>().complete(
      storyActivity(widget.story.id, widget.story.title),
    );
    if (!mounted || !result.completed) return;

    setState(() => _completedActivity = true);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StarRewardOverlay(
        onDone: _continueToNextActivity,
      ),
    );
  }

  void _continueToNextActivity() {
    if (!mounted) return;
    final progress = context.read<ProgressProvider>();
    final eligibleStories = stories
        .where((story) => !story.isPremium || progress.isPremium)
        .toList(growable: false);
    final activities = eligibleStories
        .map((story) => storyActivity(story.id, story.title))
        .toList(growable: false);
    final next = const NextActivitySelector().select(
      activities: activities,
      completedIds: progress.completedIds,
      currentActivityId: widget.story.id,
    );

    Navigator.of(context).pop();
    if (next == null) {
      Navigator.of(context).pop();
      return;
    }

    final nextStory = eligibleStories.firstWhere(
      (story) => story.id == next.id,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => StoryDetailScreen(story: nextStory)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final audio = context.watch<AudioProvider>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) {
        if (!_completedActivity) {
          context.read<ActivityProvider>().miss(
            storyActivity(story.id, story.title),
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text(story.title)),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: story.pages.length,
                    itemBuilder: (context, index) {
                      final page = story.pages[index];
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceAlt,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_rounded,
                                  size: 64,
                                  color: AppColors.locked,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              page.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18, height: 1.5),
                            ),
                            if (page.audioAsset != null) ...[
                              const SizedBox(height: 12),
                              IconButton.filled(
                                onPressed: () => audio.playAsset(page.audioAsset!),
                                icon: Icon(
                                  audio.isPlaying ? Icons.pause : Icons.volume_up_rounded,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primaryCoral,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (_isLastPage && story.quiz.isNotEmpty) _buildQuiz(story),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: _isLastPage && story.quiz.isNotEmpty ? null : _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCoral,
                    ),
                    child: Text(
                      _isLastPage
                          ? (story.quiz.isEmpty ? 'إنهاء' : 'أجب على السؤال')
                          : 'التالي',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuiz(StoryItem story) {
    final q = story.quiz.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            q.question,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...List.generate(q.options.length, (i) {
            final selected = _selectedQuizOption == i;
            final isCorrect = i == q.correctIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: OutlinedButton(
                onPressed: _selectedQuizOption == null
                    ? () {
                        setState(() => _selectedQuizOption = i);
                        if (isCorrect) {
                          Future.delayed(
                            const Duration(milliseconds: 400),
                            _finishStory,
                          );
                        }
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  backgroundColor: selected
                      ? (isCorrect
                          ? AppColors.success
                          : AppColors.primaryCoral.withValues(alpha: 0.2))
                      : null,
                ),
                child: Text(q.options[i]),
              ),
            );
          }),
        ],
      ),
    );
  }
}
