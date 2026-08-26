import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../data/adab_scenarios_data.dart';
import '../models/adab_scenario.dart';
import '../providers/progress_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/premium_sheet.dart';

class AdabScreen extends StatefulWidget {
  const AdabScreen({super.key});

  @override
  State<AdabScreen> createState() => _AdabScreenState();
}

class _AdabScreenState extends State<AdabScreen> {
  int _currentIndex = 0;
  AdabChoice? _selectedChoice;

  AdabScenario get _current => adabScenarios[_currentIndex];

  void _selectChoice(AdabChoice choice) async {
    setState(() => _selectedChoice = choice);
    if (choice.isCorrect) {
      await context.read<ProgressProvider>().markCompleted(_current.id);
    }
  }

  void _nextScenario() {
    setState(() {
      _selectedChoice = null;
      _currentIndex = (_currentIndex + 1) % adabScenarios.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final locked = _current.isPremium && !progress.isPremium;

    return Directionality(
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
    );
  }
}
