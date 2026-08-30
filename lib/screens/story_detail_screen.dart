import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../activities/activity_definitions.dart';
import '../activities/activity_provider.dart';
import '../activities/next_activity_selector.dart';
import '../data/stories_data.dart';
import '../models/story_item.dart';
import '../providers/audio_provider.dart';
import '../providers/progress_provider.dart';
import '../services/adaptive_quiz_engine.dart';
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
  final AdaptiveQuizEngine _quizEngine = const AdaptiveQuizEngine();
  int _currentPage = 0;
  int _quizIndex = 0;
  int _quizCorrect = 0;
  int? _selectedQuizOption;
  bool _quizFinished = false;
  bool _gameFinished = false;
  bool _completedActivity = false;
  bool _activityStarted = false;
  List<int> _gameOrder = [];
  List<QuizQuestion>? _adaptiveQuestions;

  bool get _isLastPage => _currentPage == widget.story.pages.length - 1;

  List<QuizQuestion> _questionsForChild(ProgressProvider progress) {
    _adaptiveQuestions ??= _quizEngine.select(
      questions: widget.story.quiz,
      age: progress.childAge,
      stars: progress.stars,
      completedIds: progress.completedIds,
      storyId: widget.story.id,
    );
    return _adaptiveQuestions!;
  }

  List<StoryGame> _gamesForAge(int age) => widget.story.games.where((g) => g.minAge <= age).toList(growable: false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_activityStarted) return;
    _activityStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ActivityProvider>().start(storyActivity(widget.story.id, widget.story.title));
    });
  }

  Future<void> _next() async {
    if (_currentPage < widget.story.pages.length - 1) {
      await _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      setState(() => _quizFinished = true);
    }
  }

  Future<void> _finishStory() async {
    if (_completedActivity || !_quizFinished || !_gameFinished) return;
    final progress = context.read<ProgressProvider>();
    final questions = _questionsForChild(progress);
    final accuracy = questions.isEmpty ? 1.0 : _quizCorrect / questions.length;
    var stars = 1;
    if (accuracy >= 0.66) stars++;
    if (accuracy >= 1.0) stars++;
    if (_gameFinished) stars++;
    final result = await context.read<ActivityProvider>().complete(
      storyActivity(widget.story.id, widget.story.title),
      starsAwarded: stars,
    );
    if (!mounted || !result.completed) return;
    setState(() => _completedActivity = true);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StarRewardOverlay(onDone: _continueToNextActivity),
    );
  }

  void _continueToNextActivity() {
    if (!mounted) return;
    final progress = context.read<ProgressProvider>();
    final eligibleStories = stories.where((story) => !story.isPremium || progress.isPremium).toList(growable: false);
    final activities = eligibleStories.map((story) => storyActivity(story.id, story.title)).toList(growable: false);
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
    final nextStory = eligibleStories.firstWhere((story) => story.id == next.id);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StoryDetailScreen(story: nextStory)));
  }

  Widget _storyImage(StoryPage page) {
    final asset = page.imageAsset;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: const BoxDecoration(color: AppColors.surfaceAlt),
        alignment: Alignment.center,
        child: asset == null
            ? const Icon(Icons.image_rounded, size: 64, color: AppColors.locked)
            : Image.asset(
                asset,
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_rounded, size: 64, color: AppColors.locked),
              ),
      ),
    );
  }

  Widget _quranPanel(StoryPage page, AudioProvider audio) {
    final quranAsset = page.quranAsset;
    if (quranAsset == null || page.quranText == null || audio.currentSequenceAsset != quranAsset) {
      return const SizedBox.shrink();
    }

    final reference = [
      if (page.quranJuz != null) 'الجزء ${page.quranJuz}',
      if (page.quranSurah != null) 'سورة ${page.quranSurah}',
      if (page.quranAyah != null) 'الآية ${page.quranAyah}',
    ].join(' • ');

    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 0,
      color: AppColors.surfaceAlt,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('📖 القرآن الكريم', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
            if (reference.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(reference, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
            const SizedBox(height: 12),
            Text(
              page.quranText!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 19, height: 1.8, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final audio = context.watch<AudioProvider>();
    final progress = context.watch<ProgressProvider>();
    final questions = _questionsForChild(progress);
    final games = _gamesForAge(progress.childAge);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) {
        if (!_completedActivity) context.read<ActivityProvider>().miss(storyActivity(story.id, story.title));
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(story.title),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(child: Text('⭐ ${progress.stars}', style: const TextStyle(fontWeight: FontWeight.w700))),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                if (!_quizFinished)
                  Expanded(child: _buildStoryPages(story, audio))
                else
                  Expanded(child: _buildLearningStage(progress, questions, games)),
                if (!_quizFinished)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCoral),
                      child: Text(_isLastPage ? 'ابدأ الأسئلة ⭐' : 'التالي'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryPages(StoryItem story, AudioProvider audio) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (i) => setState(() => _currentPage = i),
      itemCount: story.pages.length,
      itemBuilder: (context, index) {
        final page = story.pages[index];
        final isCurrentAudio = page.audioAsset != null && audio.currentAsset == page.audioAsset;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _storyImage(page)),
              if (page.text.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(page.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, height: 1.5)),
              ],
              _quranPanel(page, audio),
              if (page.audioAsset != null) ...[
                const SizedBox(height: 12),
                IconButton.filled(
                  onPressed: () => audio.playAsset(page.audioAsset!),
                  icon: Icon(isCurrentAudio && audio.isPlaying ? Icons.pause : Icons.volume_up_rounded),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primaryCoral),
                ),
                if (isCurrentAudio && audio.duration > Duration.zero)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(
                      value: (audio.position.inMilliseconds / audio.duration.inMilliseconds).clamp(0.0, 1.0),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLearningStage(ProgressProvider progress, List<QuizQuestion> questions, List<StoryGame> games) {
    if (!_quizFinished) return const SizedBox.shrink();
    if (_quizIndex < questions.length) return _buildQuizQuestion(questions[_quizIndex], progress.childGender, questions.length);
    if (!_gameFinished && games.isNotEmpty) return _buildGame(games.first);
    if (!_gameFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _gameFinished = true);
      });
      return const Center(child: CircularProgressIndicator());
    }
    return _buildCompletion(progress.childAge, progress.childGender);
  }

  Widget _buildQuizQuestion(QuizQuestion q, String? gender, int total) {
    final isLast = _quizIndex == total - 1;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('🧠 سؤال ${_quizIndex + 1} من $total', style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        Text(q.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        if (q.audioAsset != null)
          IconButton(onPressed: () => context.read<AudioProvider>().playAsset(q.audioAsset!), icon: const Icon(Icons.volume_up_rounded)),
        const SizedBox(height: 20),
        ...List.generate(q.options.length, (i) {
          final selected = _selectedQuizOption == i;
          final correct = i == q.correctIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: OutlinedButton(
              onPressed: _selectedQuizOption == null ? () => _answerQuiz(q, i) : null,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: selected ? (correct ? AppColors.success : AppColors.primaryCoral.withValues(alpha: 0.18)) : null,
              ),
              child: Text(q.options[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            ),
          );
        }),
        if (_selectedQuizOption != null) ...[
          const SizedBox(height: 12),
          Text(
            _quizEngine.encouragement(gender, _selectedQuizOption == q.correctIndex),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          if (q.explanation != null) ...[
            const SizedBox(height: 8),
            Text(q.explanation!, textAlign: TextAlign.center),
          ],
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => _advanceQuiz(total),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCoral),
            child: Text(isLast ? 'إلى اللعبة 🎮' : _quizEngine.nextLabel(gender)),
          ),
        ],
      ],
    );
  }

  void _answerQuiz(QuizQuestion q, int index) {
    setState(() {
      _selectedQuizOption = index;
      if (index == q.correctIndex) _quizCorrect++;
    });
  }

  void _advanceQuiz(int total) {
    setState(() {
      if (_quizIndex + 1 >= total) {
        _quizFinished = true;
        _quizIndex = total;
      } else {
        _quizIndex++;
        _selectedQuizOption = null;
      }
    });
  }

  Widget _buildGame(StoryGame game) {
    if (_gameOrder.isEmpty) _gameOrder = List<int>.generate(game.items.length, (i) => i);
    final isOrder = game.kind == StoryGameKind.order;
    final isChoose = game.kind == StoryGameKind.choose;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('🎮 لعبة القصة', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Text(game.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Text(isOrder ? 'رتّب الأحداث من البداية إلى النهاية.' : 'اختر الإجابة الصحيحة.', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        if (isOrder)
          ...List.generate(_gameOrder.length, (position) {
            final itemIndex = _gameOrder[position];
            return Card(
              child: ListTile(
                title: Text(game.items[itemIndex]),
                leading: CircleAvatar(child: Text('${position + 1}')),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(onPressed: position == 0 ? null : () => _moveGame(position, -1), icon: const Icon(Icons.arrow_upward)),
                  IconButton(onPressed: position == _gameOrder.length - 1 ? null : () => _moveGame(position, 1), icon: const Icon(Icons.arrow_downward)),
                ]),
              ),
            );
          })
        else
          ...List.generate(game.items.length, (i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: OutlinedButton(
              onPressed: () => _answerGame(game, i),
              child: Padding(padding: const EdgeInsets.all(14), child: Text(game.items[i], style: const TextStyle(fontSize: 18))),
            ),
          )),
        if (isOrder) ...[
          const SizedBox(height: 14),
          ElevatedButton(onPressed: () => _checkOrderGame(game), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCoral), child: const Text('تحقق ⭐')),
        ],
        if (!isChoose && !isOrder) const SizedBox.shrink(),
      ],
    );
  }

  void _moveGame(int position, int delta) {
    setState(() {
      final other = position + delta;
      final value = _gameOrder.removeAt(position);
      _gameOrder.insert(other, value);
    });
  }

  void _checkOrderGame(StoryGame game) {
    if (_gameOrder.length == game.correctOrder.length && List.generate(_gameOrder.length, (i) => _gameOrder[i]).asMap().entries.every((e) => e.value == game.correctOrder[e.key])) {
      setState(() => _gameFinished = true);
      _finishStory();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اقتربت! جرّب ترتيبًا آخر 🌱')));
    }
  }

  void _answerGame(StoryGame game, int index) {
    final correct = game.correctOrder.contains(index);
    if (correct) {
      setState(() => _gameFinished = true);
      _finishStory();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ليس هذا الاختيار. حاول مرة أخرى 🌱')));
    }
  }

  Widget _buildCompletion(int age, String? gender) {
    final message = gender == 'female'
        ? (age <= 7 ? 'رائعة يا بطلة! استمري في التعلّم.' : 'رائع! استمري في التعلّم وفعل الخير.')
        : (age <= 7 ? 'رائع يا بطل! استمر في التعلّم.' : 'رائع! استمر في التعلّم وفعل الخير.');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🌟', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          const Text('أكملت رحلة قصة نوح!', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: age <= 7 ? 20 : 18)),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
