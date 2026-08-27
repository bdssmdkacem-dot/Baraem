enum AdkarTime { morning, evening, anytime }

class AdkarItem {
  final String id;
  final String arabicText;
  final String category; // ex: "أذكار الصباح"
  final AdkarTime time;
  final String audioAsset; // ex: assets/audio/adkar/morning_01.mp3
  final String mascotHint; // petite phrase du mascot pour introduire le dhikr
  final bool isPremium;

  const AdkarItem({
    required this.id,
    required this.arabicText,
    required this.category,
    required this.time,
    required this.audioAsset,
    required this.mascotHint,
    this.isPremium = false,
  });
}
