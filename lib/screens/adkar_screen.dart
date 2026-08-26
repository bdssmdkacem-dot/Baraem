import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../character/character_state.dart';
import '../data/adkar_data.dart';
import '../models/adkar_item.dart';
import '../providers/audio_provider.dart';
import '../providers/character_provider.dart';
import '../providers/progress_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/premium_sheet.dart';
import '../widgets/star_reward_overlay.dart';

class AdkarScreen extends StatefulWidget {
  const AdkarScreen({super.key});

  @override
  State<AdkarScreen> createState() => _AdkarScreenState();
}

class _AdkarScreenState extends State<AdkarScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _completedActivity = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete(BuildContext context, AdkarItem item) async {
    final progress = context.read<ProgressProvider>();
    if (progress.isCompleted(item.id)) return;

    final character = context.read<CharacterProvider>();
    character.onActivityCompleted();
    await progress.markCompleted(item.id);
    if (!context.mounted) return;

    setState(() => _completedActivity = true);
    character.onStarEarned();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StarRewardOverlay(
        onDone: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<bool> _handleExit() async {
    if (!_completedActivity && mounted) {
      context.read<CharacterProvider>().onActivityMissed();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) {
        if (!_completedActivity && mounted) {
          context.read<CharacterProvider>().onActivityMissed();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('أذكاري'),
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryMint,
              tabs: const [
                Tab(text: 'المساء'),
                Tab(text: 'الصباح'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _AdkarList(items: eveningAdkar, onComplete: _handleComplete),
              _AdkarList(items: morningAdkar, onComplete: _handleComplete),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdkarList extends StatelessWidget {
  final List<AdkarItem> items;
  final void Function(BuildContext, AdkarItem) onComplete;

  const _AdkarList({required this.items, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final audio = context.watch<AudioProvider>();

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = items[index];
        final locked = item.isPremium && !progress.isPremium;
        final done = progress.isCompleted(item.id);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item.arabicText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: locked ? AppColors.locked : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filled(
                      onPressed: locked ? null : () => audio.playAsset(item.audioAsset),
                      icon: Icon(audio.isPlaying ? Icons.pause : Icons.volume_up_rounded),
                      style: IconButton.styleFrom(backgroundColor: AppColors.primaryMint),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: locked ? null : () => onComplete(context, item),
                      icon: Icon(done ? Icons.check_circle_rounded : Icons.star_border_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: done ? AppColors.success : AppColors.primaryGold,
                      ),
                    ),
                  ],
                ),
                if (locked) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => PremiumSheet.show(context),
                    icon: const Icon(Icons.lock_rounded, size: 18),
                    label: const Text('محتوى مميز — اضغط للفتح'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
