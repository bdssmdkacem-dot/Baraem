class StoryPage {
  final String text;
  final String imageAsset;
  final String? audioAsset;

  const StoryPage({
    required this.text,
    required this.imageAsset,
    this.audioAsset,
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class StoryItem {
  final String id;
  final String title; // ex: "قصة سيدنا نوح"
  final String coverAsset;
  final List<StoryPage> pages;
  final List<QuizQuestion> quiz;
  final bool isPremium;
  final int minAge; // 2 ou 4, pour adapter la complexité affichée

  const StoryItem({
    required this.id,
    required this.title,
    required this.coverAsset,
    required this.pages,
    this.quiz = const [],
    this.isPremium = false,
    this.minAge = 2,
  });
}
