import '../models/story_item.dart';

/// ⚠️ Données d'exemple. Remplace les textes et images par ton contenu
/// définitif (idéalement validé par une personne qualifiée en tarbiya).
final List<StoryItem> stories = [
  const StoryItem(
    id: 'story_nuh',
    title: 'قصة سيدنا نوح عليه السلام',
    coverAsset: 'assets/images/stories/nuh_cover.svg',
    minAge: 2,
    pages: [
      StoryPage(
        text: 'كان سيدنا نوح نبيًا صالحًا، يدعو قومه لعبادة الله وحده.',
        imageAsset: 'assets/images/stories/nuh_1.png',
        audioAsset: 'audio/stories/nuh_1.mp3',
      ),
      StoryPage(
        text: 'بنى سيدنا نوح سفينة كبيرة بأمر الله، وحمل فيها من كل نوع.',
        imageAsset: 'assets/images/stories/nuh_2.png',
        audioAsset: 'audio/stories/nuh_2.mp3',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'ماذا بنى سيدنا نوح؟',
        options: ['بيتًا', 'سفينة', 'قصرًا'],
        correctIndex: 1,
      ),
    ],
  ),
  const StoryItem(
    id: 'story_yunus',
    title: 'قصة سيدنا يونس عليه السلام',
    coverAsset: 'assets/images/stories/yunus_cover.svg',
    minAge: 4,
    isPremium: true,
    pages: [
      StoryPage(
        text: 'التقم الحوت سيدنا يونس، وظل يذكر الله في بطنه.',
        imageAsset: 'assets/images/stories/yunus_1.png',
        audioAsset: 'audio/stories/yunus_1.mp3',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'من التقم سيدنا يونس؟',
        options: ['الأسد', 'الحوت', 'الذئب'],
        correctIndex: 1,
      ),
    ],
  ),
  const StoryItem(
    id: 'story_ibrahim',
    title: 'قصة سيدنا إبراهيم عليه السلام',
    coverAsset: 'assets/images/stories/ibrahim_cover.svg',
    minAge: 2,
    pages: [
      StoryPage(
        text: 'كان سيدنا إبراهيم نبيًا شجاعًا، آمن بالله وحده ولم يعبد الأصنام.',
        imageAsset: 'assets/images/stories/ibrahim_1.png',
        audioAsset: 'audio/stories/ibrahim_1.mp3',
      ),
      StoryPage(
        text: 'أراد قومه أن يؤذوه بسبب إيمانه، فجعل الله النار بردًا وسلامًا عليه.',
        imageAsset: 'assets/images/stories/ibrahim_2.png',
        audioAsset: 'audio/stories/ibrahim_2.mp3',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'بم أمر الله النار؟',
        options: ['أن تحرق', 'أن تكون بردًا وسلامًا', 'أن تختفي'],
        correctIndex: 1,
      ),
    ],
  ),
  const StoryItem(
    id: 'story_yusuf',
    title: 'قصة سيدنا يوسف عليه السلام',
    coverAsset: 'assets/images/stories/yusuf_cover.svg',
    minAge: 4,
    isPremium: true,
    pages: [
      StoryPage(
        text: 'كان سيدنا يوسف طفلاً صالحًا، ورأى رؤيا جميلة فأخبر بها أباه.',
        imageAsset: 'assets/images/stories/yusuf_1.png',
        audioAsset: 'audio/stories/yusuf_1.mp3',
      ),
      StoryPage(
        text: 'مرّ سيدنا يوسف بابتلاءات كثيرة، لكنه صبر وتوكل على الله دائمًا.',
        imageAsset: 'assets/images/stories/yusuf_2.png',
        audioAsset: 'audio/stories/yusuf_2.mp3',
      ),
      StoryPage(
        text: 'بعد سنوات، سامح إخوته وعفا عنهم، لأن القلب الطيب يحب العفو.',
        imageAsset: 'assets/images/stories/yusuf_3.png',
        audioAsset: 'audio/stories/yusuf_3.mp3',
      ),
    ],
    quiz: [
      QuizQuestion(
        question: 'ماذا فعل سيدنا يوسف مع إخوته؟',
        options: ['غضب منهم', 'سامحهم', 'ابتعد عنهم'],
        correctIndex: 1,
      ),
    ],
  ),
];
