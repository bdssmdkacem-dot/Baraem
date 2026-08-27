import '../models/story_item.dart';

/// Story content used by the offline Baraem story reader.
/// Narration text is intentionally hidden in the UI; audio and illustrations
/// carry the story experience.
final List<StoryItem> stories = [
  const StoryItem(
    id: 'story_nuh',
    title: 'قصة سيدنا نوح عليه السلام',
    coverAsset: 'assets/images/stories/nuh_cover.jpg',
    minAge: 2,
    pages: [
      StoryPage(
        text: '',
        imageAsset: 'assets/images/stories/nuh_1_01.jpg',
        audioAsset: 'audio/stories/nuh_1.mp3',
      ),
      StoryPage(
        text: '',
        imageAsset: 'assets/images/stories/nuh_2.jpg',
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
    coverAsset: 'assets/images/stories/yunus_cover.jpg',
    minAge: 4,
    isPremium: true,
    pages: [
      StoryPage(text: '', imageAsset: 'assets/images/stories/yunus_1.jpg', audioAsset: 'audio/stories/yunus_1.mp3'),
    ],
    quiz: [
      QuizQuestion(question: 'من التقم سيدنا يونس؟', options: ['الأسد', 'الحوت', 'الذئب'], correctIndex: 1),
    ],
  ),
  const StoryItem(
    id: 'story_ibrahim',
    title: 'قصة سيدنا إبراهيم عليه السلام',
    coverAsset: 'assets/images/stories/ibrahim_cover.jpg',
    minAge: 2,
    pages: [
      StoryPage(text: '', audioAsset: 'audio/stories/ibrahim_1.mp3'),
      StoryPage(text: '', imageAsset: 'assets/images/stories/ibrahim_2.jpg', audioAsset: 'audio/stories/ibrahim_2.mp3'),
    ],
    quiz: [
      QuizQuestion(question: 'بم أمر الله النار؟', options: ['أن تحرق', 'أن تكون بردًا وسلامًا', 'أن تختفي'], correctIndex: 1),
    ],
  ),
  const StoryItem(
    id: 'story_yusuf',
    title: 'قصة سيدنا يوسف عليه السلام',
    coverAsset: 'assets/images/stories/yusuf_cover.jpg',
    minAge: 4,
    isPremium: true,
    pages: [
      StoryPage(text: '', audioAsset: 'audio/stories/yusuf_1.mp3'),
      StoryPage(text: '', audioAsset: 'audio/stories/yusuf_2.mp3'),
      StoryPage(text: '', audioAsset: 'audio/stories/yusuf_3.mp3'),
    ],
    quiz: [
      QuizQuestion(question: 'ماذا فعل سيدنا يوسف مع إخوته؟', options: ['غضب منهم', 'سامحهم', 'ابتعد عنهم'], correctIndex: 1),
    ],
  ),
];
