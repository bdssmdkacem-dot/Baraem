import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_routes.dart';
import '../providers/progress_provider.dart';
import '../theme/app_colors.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nicknameController = TextEditingController();
  int? _age;
  String? _gender;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty || _age == null || _gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أكمل الاسم المستعار والعمر والجنس أولًا 🌱')),
      );
      return;
    }
    await context.read<ProgressProvider>().setChildProfile(
      nickname: nickname,
      age: _age!,
      gender: _gender!,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            children: [
              const Text('🌱', textAlign: TextAlign.center, style: TextStyle(fontSize: 72)),
              const SizedBox(height: 8),
              const Text('أهلًا بك في براعم', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text('عرّفنا بك لنختار لك قصصًا وأسئلة مناسبة لعمرك.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 17, height: 1.5)),
              const SizedBox(height: 30),
              TextField(
                controller: _nicknameController,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'الاسم المستعار',
                  hintText: 'مثال: بطل براعم',
                  prefixIcon: Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _age,
                decoration: const InputDecoration(labelText: 'العمر', prefixIcon: Icon(Icons.cake_rounded)),
                items: [for (var age = 2; age <= 13; age++) DropdownMenuItem(value: age, child: Text('$age سنوات'))],
                onChanged: (value) => setState(() => _age = value),
              ),
              const SizedBox(height: 16),
              const Text('الجنس', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'male', label: Text('ولد'), icon: Icon(Icons.boy_rounded)),
                  ButtonSegment(value: 'female', label: Text('بنت'), icon: Icon(Icons.girl_rounded)),
                ],
                selected: _gender == null ? <String>{} : <String>{_gender!},
                emptySelectionAllowed: true,
                onSelectionChanged: (value) => setState(() => _gender = value.isEmpty ? null : value.first),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCoral),
                  child: const Text('ابدأ رحلة براعم ⭐', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
