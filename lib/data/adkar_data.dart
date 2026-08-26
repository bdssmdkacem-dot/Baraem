import '../models/adkar_item.dart';

/// ⚠️ Données d'exemple pour valider le scaffold.
/// À remplacer/compléter avec ta collection complète d'adkar
/// (idéalement relue par quelqu'un qualifié avant publication).
final List<AdkarItem> morningAdkar = [
  const AdkarItem(
    id: 'morning_01',
    category: 'أذكار الصباح',
    arabicText: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
    time: AdkarTime.morning,
    audioAsset: 'audio/adkar/morning_01.mp3',
    mascotHint: 'هيا نقول هذا الذكر مع بعض! 🌞',
  ),
  const AdkarItem(
    id: 'morning_02',
    category: 'أذكار الصباح',
    arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    time: AdkarTime.morning,
    audioAsset: 'audio/adkar/morning_02.mp3',
    mascotHint: 'ذكر جميل نردده كل صباح ✨',
  ),
  const AdkarItem(
    id: 'morning_03',
    category: 'أذكار الصباح',
    arabicText: 'الْحَمْدُ لِلَّهِ',
    time: AdkarTime.morning,
    audioAsset: 'audio/adkar/morning_03.mp3',
    mascotHint: 'نشكر الله على كل شيء 🌸',
  ),
  const AdkarItem(
    id: 'morning_04',
    category: 'أذكار الصباح',
    arabicText: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ',
    time: AdkarTime.morning,
    audioAsset: 'audio/adkar/morning_04.mp3',
    mascotHint: 'نتوكل على الله في كل أمورنا 💫',
  ),
  const AdkarItem(
    id: 'morning_05',
    category: 'أذكار الصباح',
    arabicText: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ نَبِيًّا',
    time: AdkarTime.morning,
    audioAsset: 'audio/adkar/morning_05.mp3',
    mascotHint: 'ذكر جميل يرضي القلب 🌟',
    isPremium: true,
  ),
];

final List<AdkarItem> eveningAdkar = [
  const AdkarItem(
    id: 'evening_01',
    category: 'أذكار المساء',
    arabicText: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
    time: AdkarTime.evening,
    audioAsset: 'audio/adkar/evening_01.mp3',
    mascotHint: 'قبل النوم، نقول هذا الذكر 🌙',
  ),
  const AdkarItem(
    id: 'evening_02',
    category: 'أذكار المساء',
    arabicText: 'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا',
    time: AdkarTime.evening,
    audioAsset: 'audio/adkar/evening_02.mp3',
    mascotHint: 'ذكر آخر جميل للمساء 🌟',
    isPremium: true,
  ),
  const AdkarItem(
    id: 'evening_03',
    category: 'أذكار المساء',
    arabicText: 'أَسْتَغْفِرُ اللهَ',
    time: AdkarTime.evening,
    audioAsset: 'audio/adkar/evening_03.mp3',
    mascotHint: 'نطلب من الله المغفرة 🤲',
  ),
  const AdkarItem(
    id: 'evening_04',
    category: 'أذكار المساء',
    arabicText: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ',
    time: AdkarTime.evening,
    audioAsset: 'audio/adkar/evening_04.mp3',
    mascotHint: 'ذكر الحماية قبل النوم 🛡️',
    isPremium: true,
  ),
];

List<AdkarItem> get allAdkar => [...morningAdkar, ...eveningAdkar];
