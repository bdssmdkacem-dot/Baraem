import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool get _isLastPage => _currentPage == widget.story.pages.length - 1;

  void _next() {
    if (_currentPage < widget.story.pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else if (widget.story.quiz.isEmpty) {
      _finishStory();
    }
  }

  void _finishStory() async {
    await context.read<ProgressProvider>().markCompleted(widget.story.id, starsAwarded: 2);
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StarRewardOverlay(onDone: () { Navigator.of(context).pop(); Navigator.of(context).pop(); }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final audio = context.watch<AudioProvider>();
    return Directionality(
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
                              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(24)),
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_rounded, size: 64, color: AppColors.locked),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(page.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, height: 1.5)),
                          if (page.audioAsset != null) ...[
                            const SizedBox(height: 12),
                            IconButton.filled(
                              onPressed: () => audio.playAsset(page.audioAsset!),
                              icon: Icon(audio.isPlaying ? Icons.pause : Icons.volume_up_rounded),
                              style: IconButton.styleFrom(backgroundColor: AppColors.primaryCoral),
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
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCoral),
                  child: Text(_isLastPage ? (story.quiz.isEmpty ? 'إنهاء' : 'أجب على السؤال') : 'التالي'),
                ),
              ),
            ],
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
          Text(q.question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          ...List.generate(q.options.length, (i) {
            final selected = _selectedQuizOption == i;
            final isCorrect = i == q.correctIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _selectedQuizOption = i);
                  if (isCorrect) Future.delayed(const Duration(milliseconds: 400), _finishStory);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: selected ? (isCorrect ? AppColors.success : AppColors.primaryCoral.withValues(alpha: 0.2)) : null,
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
