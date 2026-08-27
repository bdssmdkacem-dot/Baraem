class StoryPage {
  final String text;
  // Nullable à dessein : toutes les pages n'ont pas encore d'illustration
  // dédiée. story_detail_screen.dart doit vérifier != null avant d'appeler
  // Image.asset, sinon Flutter lève une exception au chargement d'un asset
  // déclaré mais inexistant (même classe de bug que le crash HomeScreen).
  final String? imageAsset;
  final String? audioAsset;

  const StoryPage({
    required this.text,
    this.imageAsset,
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
