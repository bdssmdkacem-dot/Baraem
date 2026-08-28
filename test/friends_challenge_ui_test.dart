import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baraem/models/player_profile.dart';
import 'package:baraem/providers/players_provider.dart';
import 'package:baraem/screens/friends_challenge_screen.dart';

void main() {
  testWidgets('friends challenge starts with two players and shows adaptive question', (tester) async {
    SharedPreferences.setMockInitialValues({
      'baraem_players_v1': '[{"id":"1","nickname":"آدم","age":6,"gender":"boy","stars":2},{"id":"2","nickname":"سارة","age":11,"gender":"girl","stars":5}]',
    });
    final players = PlayersProvider();
    await players.load();
    await tester.pumpWidget(ChangeNotifierProvider.value(value: players, child: const MaterialApp(home: FriendsChallengeScreen())));
    await tester.pumpAndSettle();
    expect(find.text('آدم'), findsOneWidget);
    expect(find.text('سارة'), findsOneWidget);
    await tester.tap(find.text('ابدأ التحدّي'));
    await tester.pumpAndSettle();
    expect(find.textContaining('دور'), findsOneWidget);
    expect(find.text('السؤال التالي'), findsNothing);
    expect(find.byType(FilledButton), findsWidgets);
  });

  test('player question result persists a star and progress', () async {
    SharedPreferences.setMockInitialValues({});
    final players = PlayersProvider();
    await players.load();
    await players.add(const PlayerProfile(id: '1', nickname: 'آدم', age: 6, gender: 'boy'));
    await players.recordQuestionResult(playerId: '1', correct: true);
    expect(players.getById('1')!.stars, 1);
    expect(players.getById('1')!.questionsAnswered, 1);
    expect(players.getById('1')!.correctAnswers, 1);
  });
}
