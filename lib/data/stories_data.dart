import '../models/story_item.dart';

/// Story content used by the offline Baraem story reader.
final List<StoryItem> stories = [
  const StoryItem(
    id: 'story_nuh',
    title: 'قصة سيدنا نوح عليه السلام',
    coverAsset: 'assets/images/stories/nuh_cover.jpg',
    minAge: 2,
    pages: [
      StoryPage(
        text:
            'منذ زمن بعيد، كان هناك نبي كريم اسمه نوح عليه السلام.\n\n'
            'اختاره الله ليهدي قومه، ويدعوهم إلى عبادة الله وحده، وأن يتركوا عبادة الأصنام.\n\n'
            'كان سيدنا نوح عليه السلام يحب الخير لقومه، وكان يدعوهم برفق وصبر.\n\n'
            'كان يقول لهم إن الله هو الخالق، وهو الذي أنعم عليهم ورزقهم، ولذلك ينبغي أن يعبدوه وحده.\n\n'
            'لكن كثيرًا من قومه لم يستجيبوا لدعوته.\n\n'
            'ومع ذلك، لم ييأس سيدنا نوح عليه السلام، بل استمر في دعوته، وصبر طويلًا، وكان يرجو أن يهدي الله قومه.\n\n'
            'وكان هذا يعلمنا درسًا جميلًا: أن الإنسان لا يستسلم عندما يفعل الخير، بل يصبر ويستمر.\n\n'
            'وبعد سنوات طويلة، أوحى الله إلى سيدنا نوح عليه السلام أن يصنع سفينة كبيرة، استعدادًا لأمر عظيم سيحدث. وهنا بدأت قصة السفينة والطوفان...',
        imageAsset: 'assets/images/stories/nuh_1_01.jpg',
        audioAsset: 'audio/stories/nuh_1.mp3',
      ),
      StoryPage(
        text: 'بنى سيدنا نوح سفينة كبيرة بأمر الله، وحمل فيها من كل نوع.',
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
      StoryPage(
        text: 'التقم الحوت سيدنا يونس، وظل يذكر الله في بطنه.',
        imageAsset: 'assets/images/stories/yunus_1.jpg',
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
    coverAsset: 'assets/images/stories/ibrahim_cover.jpg',
    minAge: 2,
    pages: [
      StoryPage(
        text: 'كان سيدنا إبراهيم نبيًا شجاعًا، آمن بالله وحده ولم يعبد الأصنام.',
        audioAsset: 'audio/stories/ibrahim_1.mp3',
      ),
      StoryPage(
        text: 'أراد قومه أن يؤذوه بسبب إيمانه، فجعل الله النار بردًا وسلامًا عليه.',
        imageAsset: 'assets/images/stories/ibrahim_2.jpg',
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
    coverAsset: 'assets/images/stories/yusuf_cover.jpg',
    minAge: 4,
    isPremium: true,
    pages: [
      StoryPage(
        text: 'كان سيدنا يوسف طفلاً صالحًا، ورأى رؤيا جميلة فأخبر بها أباه.',
        audioAsset: 'audio/stories/yusuf_1.mp3',
      ),
      StoryPage(
        text: 'مرّ سيدنا يوسف بابتلاءات كثيرة، لكنه صبر وتوكل على الله دائمًا.',
        audioAsset: 'audio/stories/yusuf_2.mp3',
      ),
      StoryPage(
        text: 'بعد سنوات، سامح إخوته وعفا عنهم، لأن القلب الطيب يحب العفو.',
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
