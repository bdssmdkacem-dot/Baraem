import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player_profile.dart';
import '../providers/players_provider.dart';

class FriendsChallengeScreen extends StatelessWidget {
  const FriendsChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final players = context.watch<PlayersProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('تحدّي الأصدقاء')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('أضف إخوتك أو أصدقاءك واختبروا معلوماتكم الدينية!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: players.players.length,
                itemBuilder: (_, index) {
                  final p = players.players[index];
                  return Card(child: ListTile(title: Text(p.nickname), subtitle: Text('${p.age} سنة • ${p.gender == 'girl' ? 'بنت' : 'ولد'}'), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => players.remove(p.id))));
                },
              ),
            ),
            if (players.players.length < 4)
              FilledButton.icon(
                onPressed: () => _addPlayer(context),
                icon: const Icon(Icons.person_add_alt_1),
                label: Text('إضافة لاعب (${players.players.length}/4)'),
              ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: players.players.length >= 2 ? () => _startChallenge(context) : null,
              icon: const Icon(Icons.emoji_events_rounded),
              label: const Text('ابدأ التحدّي'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPlayer(BuildContext context) async {
    final name = TextEditingController();
    var age = 8;
    var gender = 'boy';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(builder: (_, setState) => AlertDialog(
        title: const Text('إضافة لاعب'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: name, autofocus: true, decoration: const InputDecoration(labelText: 'اسم مستعار')),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(value: age, decoration: const InputDecoration(labelText: 'العمر'), items: [for (var i = 2; i <= 13; i++) DropdownMenuItem(value: i, child: Text('$i سنة'))], onChanged: (v) => setState(() => age = v ?? 8)),
          DropdownButtonFormField<String>(value: gender, decoration: const InputDecoration(labelText: 'الجنس'), items: const [DropdownMenuItem(value: 'boy', child: Text('ولد')), DropdownMenuItem(value: 'girl', child: Text('بنت'))], onChanged: (v) => setState(() => gender = v ?? 'boy')),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إلغاء')), FilledButton(onPressed: () { if (name.text.trim().isEmpty) return; context.read<PlayersProvider>().add(PlayerProfile(id: DateTime.now().microsecondsSinceEpoch.toString(), nickname: name.text.trim(), age: age, gender: gender)); Navigator.pop(dialogContext); }, child: const Text('إضافة'))],
      )),
    );
  }

  void _startChallenge(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('التحدّي جاهز — سنربطه بمحرك الأسئلة المتكيف في الخطوة التالية.')));
  }
}
