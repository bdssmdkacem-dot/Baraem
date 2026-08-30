import '../models/story_item.dart';

/// Offline story catalogue. Stories are content-driven so the same engine can
/// be reused for every prophet and adapted to the child's age.
final List<StoryItem> stories = [
  const StoryItem(
    id: 'story_nuh',
    title: 'قصة سيدنا نوح عليه السلام',
    coverAsset: 'assets/images/stories/nuh_cover.jpg',
    minAge: 2,
    pages: [
      StoryPage(text: 'كان نوح عليه السلام نبيًا يدعو قومه إلى عبادة الله وحده وترك عبادة ما لا ينفع ولا يضر.', imageAsset: 'assets/images/stories/nuh/nuh_1_01.png', audioAsset: 'audio/stories/nuh_01.mp3'),
      StoryPage(text: 'ظل نوح عليه السلام يدعو قومه بصبر، وكان يدعوهم إلى الإيمان بالله وطاعته.', imageAsset: 'assets/images/stories/nuh/nuh_2_01.png', audioAsset: 'audio/stories/nuh_02.mp3'),
      StoryPage(text: 'وأوحى الله إلى نوح عليه السلام أن يصنع السفينة بأمر الله وتحت عنايته.', imageAsset: 'assets/images/stories/nuh/nuh_3_01.png', audioAsset: 'audio/stories/nuh_03.mp3'),
      StoryPage(text: 'وبدأ نوح عليه السلام يصنع السفينة، وكان قومه يمرون به ويسخرون منه.', imageAsset: 'assets/images/stories/nuh/nuh_4_01.png', audioAsset: 'audio/stories/nuh_04.mp3'),
      StoryPage(text: 'ثم جاء أمر الله، وبدأ الماء بالهطول. وركب نوح عليه السلام ومن آمن معه في السفينة.', imageAsset: 'assets/images/stories/nuh/nuh_5_01.png', audioAsset: 'audio/stories/nuh_05.mp3'),
      StoryPage(text: 'وحملت السفينة من كل نوع زوجين، ونجّى الله نوحًا والذين آمنوا معه برحمته.', imageAsset: 'assets/images/stories/nuh/nuh_6_01.png', audioAsset: 'audio/stories/nuh_06.mp3'),
      StoryPage(text: 'وكان من أهل نوح من لم يؤمن، فدعاه نوح إلى الركوب، لكنه لم يستجب، وكان من المغرقين.', imageAsset: null, audioAsset: 'audio/stories/nuh_07.mp3'),
      StoryPage(text: 'وانتهى الطوفان، واستوت السفينة على الجودي، ونجّى الله المؤمنين. ومن القصة نتعلم الصبر والطاعة والثبات على الخير.', imageAsset: null, audioAsset: 'audio/stories/nuh_08.mp3'),
    ],
    quiz: [
      QuizQuestion(question: 'من نبي هذه القصة؟', options: ['نوح عليه السلام', 'موسى عليه السلام', 'يوسف عليه السلام'], correctIndex: 0, minAge: 2, explanation: 'نبي القصة هو نوح عليه السلام.'),
      QuizQuestion(question: 'ماذا بنى نوح عليه السلام؟', options: ['سفينة 🚢', 'قصرًا 🏰', 'سيارة 🚗'], correctIndex: 0, minAge: 2, hint: 'تذكّر الشيء الكبير الذي صنعه نوح بأمر الله.', explanation: 'بنى نوح عليه السلام السفينة بأمر الله.'),
      QuizQuestion(question: 'ماذا نرى في قصة نوح؟', options: ['سفينة 🚢', 'طائرة ✈️', 'قطار 🚆'], correctIndex: 0, minAge: 2, explanation: 'السفينة من أهم مشاهد القصة.'),
      QuizQuestion(question: 'هل كان نوح عليه السلام صبورًا؟', options: ['نعم', 'لا'], correctIndex: 0, minAge: 2, kind: QuizKind.trueFalse, explanation: 'نتعلم من قصة نوح عليه السلام الصبر والثبات.'),
      QuizQuestion(question: 'ماذا كان نوح عليه السلام يدعو قومه؟', options: ['إلى عبادة الله وحده', 'إلى اللعب فقط', 'إلى جمع المال'], correctIndex: 0, minAge: 5, explanation: 'كان يدعوهم إلى عبادة الله وحده وطاعته.'),
      QuizQuestion(question: 'ماذا فعل نوح عليه السلام عندما أمره الله ببناء السفينة؟', options: ['بدأ ببنائها', 'ترك الأمر', 'ذهب بعيدًا'], correctIndex: 0, minAge: 5, explanation: 'استجاب نوح عليه السلام لأمر الله وبدأ ببناء السفينة.'),
      QuizQuestion(question: 'من ركب السفينة مع نوح عليه السلام؟', options: ['من آمن معه', 'كل قومه', 'لا أحد'], correctIndex: 0, minAge: 5, explanation: 'ركب نوح عليه السلام ومن آمن معه في السفينة.'),
      QuizQuestion(question: 'ما الصفة الجميلة التي نتعلمها من نوح عليه السلام؟', options: ['الصبر', 'الكسل', 'اليأس'], correctIndex: 0, minAge: 5, explanation: 'نتعلم الصبر والثبات على الخير.'),
      QuizQuestion(question: 'لماذا كان بناء السفينة طاعةً لله؟', options: ['لأن الله أمر نوحًا بذلك', 'لأنها لعبة', 'لأن قومه طلبوا منه ذلك'], correctIndex: 0, minAge: 8, explanation: 'كان نوح عليه السلام ينفذ أمر الله بثقة وطاعة.'),
      QuizQuestion(question: 'أي موقف يعبّر عن الصبر في القصة؟', options: ['الاستمرار في الدعوة رغم الصعوبات', 'ترك الخير سريعًا', 'السخرية من الآخرين'], correctIndex: 0, minAge: 8, explanation: 'الصبر يظهر في الاستمرار في الخير رغم المشقة.'),
      QuizQuestion(question: 'ما الذي حدث للمؤمنين عندما جاء الطوفان؟', options: ['نجّاهم الله في السفينة', 'تركوا السفينة', 'اختفوا من القصة'], correctIndex: 0, minAge: 8, explanation: 'نجّى الله نوحًا والذين آمنوا معه برحمته.'),
      QuizQuestion(question: 'ما الفكرة الأساسية التي نتعلمها من نهاية القصة؟', options: ['الطاعة والصبر والثبات على الخير', 'جمع المال', 'الاستسلام عند الصعوبة'], correctIndex: 0, minAge: 8, explanation: 'من أهم دروس القصة الطاعة والصبر والثبات على الخير.'),
      QuizQuestion(question: 'ماذا نتعلم من استمرار نوح عليه السلام في الدعوة رغم رفض كثير من قومه؟', options: ['الثبات والصبر وعدم اليأس', 'ترك الخير عند أول صعوبة', 'اتباع رأي الناس دائمًا'], correctIndex: 0, minAge: 11, kind: QuizKind.reflection, explanation: 'الثبات على الحق مع الصبر من أبرز الدروس التربوية في القصة.'),
      QuizQuestion(question: 'ما العلاقة بين الإيمان والعمل في قصة السفينة؟', options: ['الإيمان يظهر في طاعة أمر الله والعمل به', 'الإيمان لا يحتاج إلى عمل', 'العمل أهم من الطاعة'], correctIndex: 0, minAge: 11, kind: QuizKind.reflection, explanation: 'نوح عليه السلام آمن بأمر الله واستجاب له بالعمل.'),
      QuizQuestion(question: 'كيف يمكن للطالب أن يطبق درس الصبر في حياته؟', options: ['يصبر على التعلم وفعل الخير', 'يستسلم عند أول خطأ', 'يترك العمل إذا صعب'], correctIndex: 0, minAge: 11, kind: QuizKind.reflection, explanation: 'نحوّل معنى الصبر والثبات إلى سلوك عملي في الدراسة والخير.'),
      QuizQuestion(question: 'لماذا لا نقيس نجاح العمل فقط بسرعة استجابة الآخرين؟', options: ['لأن علينا القيام بالخير والصبر، والنتائج بيد الله', 'لأن العمل غير مهم', 'لأن رأي الناس هو المقياس الوحيد'], correctIndex: 0, minAge: 11, kind: QuizKind.reflection, explanation: 'تعلّمنا قصة نوح عليه السلام الصبر والثبات وعدم اليأس بسبب قلة المستجيبين.'),
    ],
    games: [
      StoryGame(id: 'nuh_memory', title: 'اختبر ذاكرتك', kind: StoryGameKind.choose, items: ['سفينة 🚢', 'قصر 🏰', 'سيارة 🚗'], correctOrder: [0], minAge: 2),
      StoryGame(id: 'nuh_order', title: 'رتّب أحداث القصة', kind: StoryGameKind.order, items: ['الدعوة إلى الله', 'بناء السفينة', 'ركوب المؤمنين', 'النجاة'], correctOrder: [0, 1, 2, 3], minAge: 5),
      StoryGame(id: 'nuh_choose', title: 'ماذا نتعلم؟', kind: StoryGameKind.choose, items: ['الصبر والثبات', 'الكسل', 'اليأس'], correctOrder: [0], minAge: 8),
    ],
  ),
  const StoryItem(id: 'story_yunus', title: 'قصة سيدنا يونس عليه السلام', coverAsset: 'assets/images/stories/yunus_cover.jpg', minAge: 4, isPremium: true, pages: [StoryPage(text: '', imageAsset: 'assets/images/stories/yunus_1.jpg', audioAsset: 'audio/stories/yunus_1.mp3')], quiz: [QuizQuestion(question: 'من التقمه الحوت؟', options: ['الأسد', 'الحوت', 'الذئب'], correctIndex: 1)]),
  const StoryItem(id: 'story_ibrahim', title: 'قصة سيدنا إبراهيم عليه السلام', coverAsset: 'assets/images/stories/ibrahim_cover.jpg', minAge: 2, pages: [StoryPage(text: '', audioAsset: 'audio/stories/ibrahim_1.mp3'), StoryPage(text: '', imageAsset: 'assets/images/stories/ibrahim_2.jpg', audioAsset: 'audio/stories/ibrahim_2.mp3')], quiz: [QuizQuestion(question: 'بم أمر الله النار؟', options: ['أن تحرق', 'أن تكون بردًا وسلامًا', 'أن تختفي'], correctIndex: 1)]),
  const StoryItem(id: 'story_yusuf', title: 'قصة سيدنا يوسف عليه السلام', coverAsset: 'assets/images/stories/yusuf_cover.jpg', minAge: 4, isPremium: true, pages: [StoryPage(text: '', audioAsset: 'audio/stories/yusuf_1.mp3'), StoryPage(text: '', audioAsset: 'audio/stories/yusuf_2.mp3')], quiz: [QuizQuestion(question: 'ما الصفة التي اشتهر بها يوسف؟', options: ['الأمانة', 'الكسل', 'الكذب'], correctIndex: 0)]),
];
