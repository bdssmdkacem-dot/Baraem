enum QuizKind { choice, trueFalse, pictureChoice, reflection }

enum StoryGameKind { choose, order, memory }

class StoryPage {
  final String text;
  final String? imageAsset;
  final String? audioAsset;

  const StoryPage({required this.text, this.imageAsset, this.audioAsset});
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final int minAge;
  final QuizKind kind;
  final String? hint;
  final String? explanation;
  final String? audioAsset;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.minAge = 2,
    this.kind = QuizKind.choice,
    this.hint,
    this.explanation,
    this.audioAsset,
  });
}

class StoryGame {
  final String id;
  final String title;
  final StoryGameKind kind;
  final List<String> items;
  final List<int> correctOrder;
  final int minAge;

  const StoryGame({
    required this.id,
    required this.title,
    required this.kind,
    required this.items,
    this.correctOrder = const [],
    this.minAge = 2,
  });
}

class StoryItem {
  final String id;
  final String title;
  final String coverAsset;
  final List<StoryPage> pages;
  final List<QuizQuestion> quiz;
  final List<StoryGame> games;
  final bool isPremium;
  final int minAge;

  const StoryItem({
    required this.id,
    required this.title,
    required this.coverAsset,
    required this.pages,
    this.quiz = const [],
    this.games = const [],
    this.isPremium = false,
    this.minAge = 2,
  });
}
