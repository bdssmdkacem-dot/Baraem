import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../activities/activity_definitions.dart';
import '../activities/activity_provider.dart';
import '../activities/next_activity_selector.dart';
import '../data/adab_scenarios_data.dart';
import '../models/adab_scenario.dart';
import '../providers/progress_provider.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/premium_sheet.dart';
import '../widgets/star_reward_overlay.dart';

class AdabScreen extends StatefulWidget {
  final String? initialScenarioId;

  const AdabScreen({super.key, this.initialScenarioId});

  @override
  State<AdabScreen> createState() => _AdabScreenState();
}

class _AdabScreenState extends State<AdabScreen> {
  int _currentIndex = 0;
  AdabChoice? _selectedChoice;
  bool _completedActivity = false;
  bool _activityStarted = false;

  AdabScenario get _current => adabScenarios[_currentIndex];

  @override
  void initState() {
    super.initState();
    final initialId = widget.initialScenarioId;
    if (initialId != null) {
      final index = adabScenarios.indexWhere((scenario) => scenario.id == initialId);
      if (index >= 0) _currentIndex = index;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_activityStarted) return;
    _activityStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ActivityProvider>().start(
        mannersActivity(_current.id, _current.situation),
      );
    });
  }

  Future<void> _selectChoice(AdabChoice choice) async {
    setState(() => _selectedChoice = choice);
    if (!choice.isCorrect) return;

    final result = await context.read<ActivityProvider>().complete(
      mannersActivity(_current.id, _current.situation),
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
    Navigator.of(context).pop();
    _nextScenario();
  }

  void _nextScenario() {
    final progress = context.read<ProgressProvider>();
    final activities = adabScenarios
        .map((scenario) => mannersActivity(scenario.id, scenario.situation))
        .toList(growable: false);
    final next = const NextActivitySelector().select(
      activities: activities,
      completedIds: progress.completedIds,
      currentActivityId: _current.id,
    );

    if (next == null) return;

    final nextIndex = adabScenarios.indexWhere((scenario) => scenario.id == next.id);
    if (nextIndex < 0) return;

    setState(() {
      _currentIndex = nextIndex;
      _selectedChoice = null;
      _completedActivity = false;
    });
    context.read<ActivityProvider>().start(
      mannersActivity(_current.id, _current.situation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final locked = _current.isPremium && !progress.isPremium;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) {
        if (!_completedActivity && !locked && _selectedChoice != null) {
          context.read<ActivityProvider>().miss(
            mannersActivity(_current.id, _current.situation),
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('آدابي')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 160,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SvgPicture.asset(
                      _current.imageAsset,
                      fit: BoxFit.cover,
                      placeholderBuilder: (_) => const Center(
                        child: Icon(Icons.image_rounded, size: 56, color: AppColors.locked),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MascotWidget(
                    message: _current.situation,
                    imageAsset: 'assets/images/mascot/mascot_lion.svg',
                  ),
                  const SizedBox(height: 20),
                  if (locked)
                    Column(
                      children: [
                        const Text(
                          '🔒 هذا السيناريو ضمن المحتوى المميز',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => PremiumSheet.show(context),
                          child: const Text('فتح المحتوى المميز'),
                        ),
                      ],
                    )
                  else
                    ..._current.choices.map((choice) {
                      final isSelected = _selectedChoice == choice;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ElevatedButton(
                          onPressed: _selectedChoice == null ? () => _selectChoice(choice) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? (choice.isCorrect ? AppColors.success : AppColors.primaryCoral)
                                : AppColors.primarySky,
                          ),
                          child: Text(choice.label),
                        ),
                      );
                    }),
                  if (_selectedChoice != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _selectedChoice!.feedback,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _nextScenario,
                      child: const Text('التالي ⟵'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
