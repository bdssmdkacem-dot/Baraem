import '../models/story_item.dart';

/// Selects and adapts story questions from the child's age, gender and progress.
/// Gender changes the friendly wording, while educational difficulty is driven
/// primarily by age and demonstrated progress so boys and girls receive the
/// same learning opportunity.
class AdaptiveQuizEngine {
  const AdaptiveQuizEngine();

  int ageBand(int age) {
    if (age <= 4) return 2;
    if (age <= 7) return 5;
    if (age <= 10) return 8;
    return 11;
  }

  List<QuizQuestion> select({
    required List<QuizQuestion> questions,
    required int age,
    required int stars,
    required Set<String> completedIds,
    required String storyId,
  }) {
    if (questions.isEmpty) return const [];

    final band = ageBand(age);
    final candidates = questions.where((q) => q.minAge == band).toList();
    if (candidates.isEmpty) {
      final fallback = questions.where((q) => q.minAge <= age).toList();
      candidates.addAll(fallback);
    }

    // As the child demonstrates progress, introduce the older-band questions
    // gradually instead of suddenly making the whole quiz harder.
    if (stars >= 10 && band < 11) {
      final nextBand = band == 2 ? 5 : (band == 5 ? 8 : 11);
      final advanced = questions.where((q) => q.minAge == nextBand).toList();
      if (advanced.isNotEmpty) {
        candidates.addAll(advanced.take(1));
      }
    }

    // Keep the quiz short for young children and slightly richer for older ones.
    final limit = age <= 4 ? 4 : (age <= 7 ? 5 : (age <= 10 ? 6 : 7));
    final seed = storyId.codeUnits.fold<int>(0, (sum, c) => sum + c) + stars + completedIds.length;
    candidates.sort((a, b) => _stableScore(a, seed).compareTo(_stableScore(b, seed)));
    return candidates.take(limit).toList(growable: false);
  }

  String encouragement(String? gender, bool correct) {
    if (correct) {
      return gender == 'female' ? 'أحسنتِ يا بطلة! ⭐' : 'أحسنت يا بطل! ⭐';
    }
    return gender == 'female' ? 'لا بأس يا بطلة، حاولي مرة أخرى 🌱' : 'لا بأس يا بطل، حاول مرة أخرى 🌱';
  }

  String nextLabel(String? gender) => gender == 'female' ? 'السؤال التالي' : 'السؤال التالي';

  int _stableScore(QuizQuestion q, int seed) {
    return q.question.codeUnits.fold<int>(seed, (sum, c) => (sum * 31 + c) & 0x7fffffff);
  }
}
