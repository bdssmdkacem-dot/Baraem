class AdabChoice {
  final String label;
  final bool isCorrect;
  final String feedback; // phrase du mascot après le choix

  const AdabChoice({
    required this.label,
    required this.isCorrect,
    required this.feedback,
  });
}

class AdabScenario {
  final String id;
  final String situation; // ex: "حان وقت الأكل، ماذا نقول؟"
  final String imageAsset;
  final List<AdabChoice> choices;
  final bool isPremium;

  const AdabScenario({
    required this.id,
    required this.situation,
    required this.imageAsset,
    required this.choices,
    this.isPremium = false,
  });
}
