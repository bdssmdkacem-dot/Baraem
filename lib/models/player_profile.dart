class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.nickname,
    required this.age,
    required this.gender,
    this.stars = 0,
    this.challengesPlayed = 0,
    this.challengesWon = 0,
    this.questionsAnswered = 0,
    this.correctAnswers = 0,
  });

  final String id;
  final String nickname;
  final int age;
  final String gender;
  final int stars;
  final int challengesPlayed;
  final int challengesWon;
  final int questionsAnswered;
  final int correctAnswers;

  PlayerProfile copyWith({
    int? stars,
    int? challengesPlayed,
    int? challengesWon,
    int? questionsAnswered,
    int? correctAnswers,
  }) => PlayerProfile(
    id: id,
    nickname: nickname,
    age: age,
    gender: gender,
    stars: stars ?? this.stars,
    challengesPlayed: challengesPlayed ?? this.challengesPlayed,
    challengesWon: challengesWon ?? this.challengesWon,
    questionsAnswered: questionsAnswered ?? this.questionsAnswered,
    correctAnswers: correctAnswers ?? this.correctAnswers,
  );
}
