import '../models/adab_scenario.dart';

/// ⚠️ Données d'exemple à étoffer.
final List<AdabScenario> adabScenarios = [
  const AdabScenario(
    id: 'adab_eating',
    situation: 'حان وقت الأكل، ماذا نقول قبل أن نبدأ؟',
    imageAsset: 'assets/images/adab/eating.svg',
    choices: [
      AdabChoice(
        label: 'بِسْمِ اللَّهِ',
        isCorrect: true,
        feedback: 'أحسنت! هكذا نبدأ الأكل دائمًا 🌟',
      ),
      AdabChoice(
        label: 'لا شيء',
        isCorrect: false,
        feedback: 'هيا نتذكر: نقول بسم الله قبل الأكل 😊',
      ),
    ],
  ),
  const AdabScenario(
    id: 'adab_greeting',
    situation: 'قابلت صديقك في الحديقة، ماذا تقول له؟',
    imageAsset: 'assets/images/adab/greeting.svg',
    choices: [
      AdabChoice(
        label: 'السَّلَامُ عَلَيْكُمْ',
        isCorrect: true,
        feedback: 'رائع! هذا هو السلام الجميل 🌸',
      ),
      AdabChoice(
        label: 'مرحبا فقط',
        isCorrect: false,
        feedback: 'يمكننا أن نبدأ بالسلام عليكم، إنه أجمل 😊',
      ),
    ],
  ),
  const AdabScenario(
    id: 'adab_sleep',
    situation: 'حان وقت النوم، ماذا نقول قبل أن ننام؟',
    imageAsset: 'assets/images/adab/sleep.svg',
    choices: [
      AdabChoice(
        label: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        isCorrect: true,
        feedback: 'أحسنت! هكذا ننام بأمان واطمئنان 🌙',
      ),
      AdabChoice(
        label: 'لا شيء',
        isCorrect: false,
        feedback: 'هيا نتذكر هذا الذكر الجميل قبل النوم 😊',
      ),
    ],
  ),
  const AdabScenario(
    id: 'adab_sneeze',
    situation: 'عطس صديقك وقال الحمد لله، ماذا تقول له؟',
    imageAsset: 'assets/images/adab/sneeze.svg',
    choices: [
      AdabChoice(
        label: 'يَرْحَمُكَ اللهُ',
        isCorrect: true,
        feedback: 'رائع! هكذا ندعو لصديقنا 🤲',
      ),
      AdabChoice(
        label: 'لا شيء',
        isCorrect: false,
        feedback: 'نقول له "يرحمك الله"، إنه جميل 😊',
      ),
    ],
  ),
  const AdabScenario(
    id: 'adab_helping',
    situation: 'طلبت منك أمك المساعدة في ترتيب الألعاب، ماذا تفعل؟',
    imageAsset: 'assets/images/adab/helping.svg',
    choices: [
      AdabChoice(
        label: 'أساعدها بفرح',
        isCorrect: true,
        feedback: 'أحسنت! مساعدة الوالدين تفرح قلبهما 💛',
      ),
      AdabChoice(
        label: 'أرفض المساعدة',
        isCorrect: false,
        feedback: 'هيا نساعد أمنا بفرح، هذا يسعدها 😊',
      ),
    ],
  ),
  const AdabScenario(
    id: 'adab_sharing',
    situation: 'صديقك ليس لديه لعبة يلعب بها، ماذا تفعل؟',
    imageAsset: 'assets/images/adab/sharing.svg',
    choices: [
      AdabChoice(
        label: 'أشاركه لعبتي',
        isCorrect: true,
        feedback: 'رائع! المشاركة تجعلنا أصدقاء أكثر 🤝',
      ),
      AdabChoice(
        label: 'أحتفظ بها لنفسي',
        isCorrect: false,
        feedback: 'يمكننا أن نشارك أصدقاءنا، هذا أجمل 😊',
      ),
    ],
  ),
  const AdabScenario(
    id: 'adab_honesty',
    situation: 'كسرت شيئًا بالخطأ، ماذا تفعل؟',
    imageAsset: 'assets/images/adab/honesty.svg',
    choices: [
      AdabChoice(
        label: 'أخبر أهلي بالحقيقة',
        isCorrect: true,
        feedback: 'أحسنت! الصدق دائمًا هو الأفضل ✨',
      ),
      AdabChoice(
        label: 'أخفي الأمر',
        isCorrect: false,
        feedback: 'من الأفضل أن نقول الحقيقة دائمًا 😊',
      ),
    ],
  ),
];
