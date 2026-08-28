import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/stories_data.dart';
import '../models/player_profile.dart';
import '../providers/audio_provider.dart';
import '../providers/players_provider.dart';
import '../services/friends_challenge_engine.dart';

class FriendsChallengeScreen extends StatefulWidget {
  const FriendsChallengeScreen({super.key});
  @override State<FriendsChallengeScreen> createState() => _FriendsChallengeScreenState();
}

class _FriendsChallengeScreenState extends State<FriendsChallengeScreen> {
  FriendsChallengeEngine? _engine;
  ChallengeQuestion? _current;
  int _round = 0;
  bool _answered = false;
  int? _selected;
  bool _resultsSaved = false;
  final Map<String, int> _scores = {};
  final Set<String> _selectedPlayerIds = {};
  AudioProvider? _audioProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _audioProvider ??= context.read<AudioProvider>();
  }

  void _start() {
    final allPlayers = context.read<PlayersProvider>().players;
    final players = allPlayers.where((p) => _selectedPlayerIds.contains(p.id)).toList();
    if (players.isEmpty) return;
    final questions = stories.firstWhere((s) => s.id == 'story_nuh').quiz;
    setState(() {
      _engine = FriendsChallengeEngine(players: players, questions: questions);
      _scores..clear()..addEntries(players.map((p) => MapEntry(p.id, 0)));
      _round = 0; _current = null; _answered = false; _selected = null; _resultsSaved = false;
    });
    _nextQuestion();
  }

  void _nextQuestion() {
    final next = _engine?.next();
    setState(() { _current = next; _answered = false; _selected = null; });
    final asset = next?.question.audioAsset;
    if (asset != null && asset.trim().isNotEmpty) {
      _audioProvider?.playAsset(asset);
    }
  }

  Future<void> _answer(int index) async {
    final current = _current;
    final engine = _engine;
    if (current == null || engine == null || _answered) return;
    final correct = index == current.question.correctIndex;
    engine.answer(player: current.player, question: current.question, correct: correct);
    if (correct) {
      _scores[current.player.id] = (_scores[current.player.id] ?? 0) + 1;
    }
    await context.read<PlayersProvider>().recordQuestionResult(playerId: current.player.id, correct: correct);
    if (!mounted) return;
    await _audioProvider?.playAsset(correct ? 'audio/ui/correct.mp3' : 'audio/ui/try_again.mp3');
    if (!mounted) return;
    setState(() { _answered = true; _selected = index; _round++; });
  }

  Future<void> _addPlayer() async {
    final nicknameController = TextEditingController();
    final ageController = TextEditingController(text: '6');
    var gender = 'boy';
    final result = await showDialog<PlayerProfile>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة لاعب'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nicknameController, autofocus: true, decoration: const InputDecoration(labelText: 'الاسم المستعار')),
            TextField(controller: ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'العمر (2–13)')),
            DropdownButtonFormField<String>(initialValue: gender, decoration: const InputDecoration(labelText: 'الجنس'), items: const [DropdownMenuItem(value: 'boy', child: Text('ولد')), DropdownMenuItem(value: 'girl', child: Text('بنت'))], onChanged: (v) => setDialogState(() => gender = v ?? 'boy')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')),
            FilledButton(onPressed: () {
              final nickname = nicknameController.text.trim();
              final age = int.tryParse(ageController.text.trim());
              if (nickname.isEmpty || age == null || age < 2 || age > 13) return;
              Navigator.pop(dialogContext, PlayerProfile(id: 'player_${DateTime.now().microsecondsSinceEpoch}', nickname: nickname, age: age, gender: gender));
            }, child: const Text('حفظ')),
          ],
        ),
      ),
    );
    nicknameController.dispose();
    ageController.dispose();
    if (result == null || !mounted) return;
    final provider = context.read<PlayersProvider>();
    await provider.add(result);
    if (!mounted) return;
    setState(() => _selectedPlayerIds.add(result.id));
  }

  @override
  void dispose() {
    _audioProvider?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = _current;
    return Scaffold(appBar: AppBar(title: const Text('🏆 تحدّي الأصدقاء')), body: Padding(padding: const EdgeInsets.all(20), child: _engine == null ? _setup(context) : current == null ? _finishChallenge(context) : _question(current)));
  }

  Widget _setup(BuildContext context) {
    final players = context.watch<PlayersProvider>().players;
    final selectedCount = _selectedPlayerIds.length;
    return Column(children: [
      const SizedBox(height: 20), const Text('تحدّي قصة نوح عليه السلام', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
      const SizedBox(height: 12), Text('اختر من 1 إلى 3 لاعبين • $selectedCount/3', style: const TextStyle(fontSize: 18)), const SizedBox(height: 12),
      Expanded(child: players.isEmpty ? const Center(child: Text('أضف أول لاعب ليبدأ التحدّي')) : ListView(children: players.map((p) => Card(child: CheckboxListTile(value: _selectedPlayerIds.contains(p.id), onChanged: selectedCount >= 3 && !_selectedPlayerIds.contains(p.id) ? null : (value) => setState(() => value == true ? _selectedPlayerIds.add(p.id) : _selectedPlayerIds.remove(p.id)), title: Text(p.nickname), subtitle: Text('${p.age} سنة • ⭐ ${p.stars}')))).toList())),
      OutlinedButton.icon(onPressed: players.length < 4 ? _addPlayer : null, icon: const Icon(Icons.person_add_alt_1), label: const Text('إضافة لاعب')),
      const SizedBox(height: 8), FilledButton.icon(onPressed: selectedCount >= 1 && selectedCount <= 3 ? _start : null, icon: const Icon(Icons.play_arrow), label: Text(selectedCount == 1 ? 'ابدأ التحدي الفردي' : 'ابدأ التحدّي')),
    ]);
  }

  Widget _question(ChallengeQuestion current) {
    final q = current.question;
    final correct = _selected == q.correctIndex;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('دور ${current.player.nickname}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), Text('العمر ${current.player.age} سنة • الجولة ${_round + 1} • ⭐ ${current.player.stars + (_scores[current.player.id] ?? 0)}', textAlign: TextAlign.center), const SizedBox(height: 24), Text(q.question, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), if (q.audioAsset != null) IconButton(onPressed: () => _audioProvider?.playAsset(q.audioAsset!), icon: const Icon(Icons.volume_up_rounded)), const SizedBox(height: 12), ...List.generate(q.options.length, (i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: FilledButton(onPressed: _answered ? null : () => _answer(i), child: Text(q.options[i])))), if (_answered) ...[const SizedBox(height: 14), Text(correct ? 'أحسنت! ⭐' : 'حاول مرة أخرى 🌱', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 12), FilledButton(onPressed: _nextQuestion, child: const Text('السؤال التالي'))]]);
  }

  Widget _finishChallenge(BuildContext context) {
    final players = _engine?.players ?? const <PlayerProfile>[];
    final ranked = List<PlayerProfile>.from(players)..sort((a, b) => (_scores[b.id] ?? 0).compareTo(_scores[a.id] ?? 0));
    if (_round > 0) WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_resultsSaved) {
        _resultsSaved = true;
        context.read<PlayersProvider>().recordChallengeResult(scores: _scores);
      }
    });
    return Column(children: [const SizedBox(height: 20), const Text('🏆 انتهى التحدّي!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 24), Expanded(child: ListView.builder(itemCount: ranked.length, itemBuilder: (_, i) => Card(child: ListTile(leading: Text(i == 0 ? '🥇' : i == 1 ? '🥈' : '⭐', style: const TextStyle(fontSize: 26)), title: Text(ranked[i].nickname), subtitle: Text('⭐ ${ranked[i].stars} • فاز ${ranked[i].challengesWon} مرة'), trailing: Text('${_scores[ranked[i].id] ?? 0} نقاط'))))), FilledButton.icon(onPressed: _start, icon: const Icon(Icons.replay), label: const Text('جولة جديدة'))]);
  }
}
