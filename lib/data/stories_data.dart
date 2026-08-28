import '../models/story_item.dart';

/// Offline story catalogue. The same story is adapted by age through quiz
/// minAge values; the story engine can therefore be reused for every prophet.
final List<StoryItem> stories = [
  const StoryItem(
    id: 'story_nuh',
    title: 'قصة سيدنا نوح عليه السلام',
    coverAsset: 'assets/images/stories/nuh_cover.jpg',
    minAge: 2,
    pages: [
      StoryPage(
        text: 'كان نوح عليه السلام نبيًا يدعو قومه إلى عبادة الله وحده.',
        imageAsset: 'assets/images/stories/nuh_1_01.jpg',
        audioAsset: 'audio/stories/nuh_1.mp3',
      ),
      StoryPage(
        text: 'أمر الله نوحًا أن يصنع السفينة، ثم جاءت رحمة الله ونجا المؤمنون.',
        imageAsset: 'assets/images/stories/nuh_2.jpg',
        audioAsset: 'audio/stories/nuh_2.mp3',
      ),
    ],
    quiz: [
      // 2–4: recognition and simple memory.
      QuizQuestion(
        question: 'ماذا بنى سيدنا نوح عليه السلام؟',
        options: ['سفينة 🚢', 'قصرًا 🏰', 'سيارة 🚗'],
        correctIndex: 0,
        minAge: 2,
        hint: 'تذكّر الشيء الذي صنعه نوح بأمر الله.',
        explanation: 'بنى نوح عليه السلام السفينة بأمر الله.',
      ),
      QuizQuestion(
        question: 'ماذا نرى في قصة نوح؟',
        options: ['سفينة 🚢', 'طائرة ✈️', 'قطار 🚆'],
        correctIndex: 0,
        minAge: 2,
        explanation: 'السفينة من أهم أحداث القصة.',
      ),
      QuizQuestion(
        question: 'هل استمر نوح عليه السلام في دعوة قومه؟',
        options: ['نعم', 'لا'],
        correctIndex: 0,
        minAge: 2,
        kind: QuizKind.trueFalse,
        explanation: 'نتعلم من القصة الصبر والاستمرار في الخير.',
      ),

      // 5–7: sequence and basic understanding.
      QuizQuestion(
        question: 'ماذا فعل نوح عليه السلام بعد أن أمره الله؟',
        options: ['صنع السفينة', 'ترك الدعوة', 'بنى قصرًا'],
        correctIndex: 0,
        minAge: 5,
        explanation: 'بدأ نوح عليه السلام ببناء السفينة كما أمره الله.',
      ),
      QuizQuestion(
        question: 'ما الصفة الجميلة التي نتعلمها من نوح عليه السلام؟',
        options: ['الصبر', 'الكسل', 'الغضب'],
        correctIndex: 0,
        minAge: 5,
        explanation: 'من دروس القصة الصبر والثبات على الخير.',
      ),
      QuizQuestion(
        question: 'ماذا حدث بعد اكتمال السفينة؟',
        options: ['جاء أمر الله وركب المؤمنون', 'ذهب نوح للنوم', 'اختفت السفينة'],
        correctIndex: 0,
        minAge: 5,
        explanation: 'كانت السفينة سببًا للنجاة للمؤمنين بأمر الله.',
      ),

      // 8–10: comprehension.
      QuizQuestion(
        question: 'لماذا كان بناء السفينة طاعةً لله؟',
        options: ['لأن الله أمر نوحًا بذلك', 'لأنها لعبة', 'لأن قومه طلبوا منه ذلك'],
        correctIndex: 0,
        minAge: 8,
        explanation: 'كان نوح عليه السلام ينفذ أمر الله بثقة وطاعة.',
      ),
      QuizQuestion(
        question: 'أي موقف يعبّر عن الصبر في القصة؟',
        options: ['الاستمرار في الدعوة رغم الصعوبات', 'ترك العمل سريعًا', 'السخرية من الآخرين'],
        correctIndex: 0,
        minAge: 8,
        explanation: 'الصبر يظهر في الاستمرار في الخير رغم المشقة.',
      ),
      QuizQuestion(
        question: 'ما الفكرة الأساسية في نهاية القصة؟',
        options: ['النجاة بطاعة الله', 'أهمية جمع المال', 'بناء أكبر سفينة للمتعة'],
        correctIndex: 0,
        minAge: 8,
        explanation: 'تعلّمنا القصة أن طاعة الله والثبات على الحق من أسباب النجاة.',
      ),

      // 11–13: reflection and deeper understanding.
      QuizQuestion(
        question: 'ماذا نتعلم من استمرار نوح عليه السلام في الدعوة رغم رفض كثير من قومه؟',
        options: ['الثبات والصبر وعدم اليأس', 'ترك الخير عند أول صعوبة', 'اتباع رأي الناس دائمًا'],
        correctIndex: 0,
        minAge: 11,
        kind: QuizKind.reflection,
        explanation: 'الثبات على الحق مع الصبر من أبرز الدروس التربوية في القصة.',
      ),
      QuizQuestion(
        question: 'ما العلاقة بين الإيمان والعمل في قصة السفينة؟',
        options: ['الإيمان يظهر في طاعة أمر الله والعمل به', 'الإيمان لا يحتاج إلى عمل', 'العمل أهم من الطاعة'],
        correctIndex: 0,
        minAge: 11,
        kind: QuizKind.reflection,
        explanation: 'نوح عليه السلام آمن بأمر الله واستجاب له بالعمل.',
      ),
      QuizQuestion(
        question: 'أي درس يمكن تطبيقه في حياة الطالب اليوم؟',
        options: ['الصبر على التعلم وفعل الخير', 'الاستسلام عند أول خطأ', 'ترك النصيحة دائمًا'],
        correctIndex: 0,
        minAge: 11,
        kind: QuizKind.reflection,
        explanation: 'نحوّل معنى الصبر والثبات إلى سلوك عملي في الدراسة والخير.',
      ),
    ],
    games: [
      StoryGame(
        id: 'nuh_order',
        title: 'رتّب أحداث القصة',
        kind: StoryGameKind.order,
        items: ['الدعوة إلى الله', 'بناء السفينة', 'ركوب المؤمنين', 'النجاة'],
        correctOrder: [0, 1, 2, 3],
        minAge: 5,
      ),
      StoryGame(
        id: 'nuh_choose',
        title: 'ماذا نتعلم؟',
        kind: StoryGameKind.choose,
        items: ['الصبر والثبات', 'الكسل', 'اليأس'],
        correctOrder: [0],
        minAge: 8,
      ),
      StoryGame(
        id: 'nuh_memory',
        title: 'ذاكرة القصة',
        kind: StoryGameKind.memory,
        items: ['سفينة', 'ماء', 'حيوانات', 'نجاة'],
        minAge: 2,
      ),
    ],
  ),
  const StoryItem(
    id: 'story_yunus',
    title: 'قصة سيدنا يونس عليه السلام',
    coverAsset: 'assets/images/stories/yunus_cover.jpg',
    minAge: 4,
    isPremium: true,
    pages: [StoryPage(text: '', imageAsset: 'assets/images/stories/yunus_1.jpg', audioAsset: 'audio/stories/yunus_1.mp3')],
    quiz: [QuizQuestion(question: 'من التقمه الحوت؟', options: ['الأسد', 'الحوت', 'الذئب'], correctIndex: 1)],
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
    quiz: [QuizQuestion(question: 'بم أمر الله النار؟', options: ['أن تحرق', 'أن تكون بردًا وسلامًا', 'أن تختفي'], correctIndex: 1)],
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
    quiz: [QuizQuestion(question: 'ماذا فعل سيدنا يوسف مع إخوته؟', options: ['غضب منهم', 'سامحهم', 'ابتعد عنهم'], correctIndex: 1)],
  ),
];
