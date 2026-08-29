# قصص الأنبياء — Baraem

الترتيب المعتمد في المشروع من آدم عليه السلام إلى محمد ﷺ، مع مجلد مستقل لكل قصة عند تجهيز الصور والأصوات.

## الترتيب

1. Adam — `adam`
2. Idris — `idris`
3. Nuh — `nuh`
4. Hud — `hud`
5. Salih — `salih`
6. Ibrahim — `ibrahim`
7. Lut — `lut`
8. Ismail — `ismail`
9. Ishaq — `ishaq`
10. Yaqub — `yaqub`
11. Yusuf — `yusuf`
12. Ayyub — `ayyub`
13. Shuayb — `shuayb`
14. Musa — `musa`
15. Harun — `harun`
16. Dhul-Kifl — `dhul_kifl`
17. Dawud — `dawud`
18. Sulayman — `sulayman`
19. Ilyas — `ilyas`
20. Al-Yasa — `al_yasa`
21. Yunus — `yunus`
22. Zakariya — `zakariya`
23. Yahya — `yahya`
24. Isa — `isa`
25. Muhammad ﷺ — `muhammad`

## مسارات الأصول النهائية

الصور: `assets/images/stories/<slug>/`
الأصوات: `assets/audio/stories/<slug>/`

## قاعدة التسمية

لكل مشهد صورة: `<slug>_N_01.png`، مقاس 1920×1080 (16:9)، ويمكن استخدام 1024×576 عند الحاجة.

لكل مشهد صوت: `<slug>_N_a.mp3` للراوي قبل التلاوة، `<slug>_quran_0N.mp3` للتلاوة المستقلة، و`<slug>_N_b.mp3` للراوي بعد التلاوة.

لا تُدمج التلاوة داخل صوت الراوي. `AudioProvider` في Baraem يدعم تشغيل تسلسل مستقل، والـ`StoryPage.audioAsset` هو نقطة الربط التي تستخدمها شاشة القصة. 

## الهوية البصرية

2D عالية الجودة، مناسبة للأطفال 2–13 سنة، أشكال مستديرة، إضاءة دافئة، ألوان متناسقة، بيئات تاريخية محترمة، بدون نص أو شعارات أو علامات مائية أو عناصر حديثة. لا تُظهر وجوه الأنبياء ولا تُجسّد الله تعالى بأي شكل، وتجنب العنف والرعب.

## ملاحظة المحتوى

القصص تُكتب لاحقًا مشهدًا بمشهد اعتمادًا على القرآن الكريم والمصادر الإسلامية الموثوقة. ملفات القرآن تكون تلاوة مستقلة من مصدر مرخّص؛ لا تُنتج آيات القرآن عبر ElevenLabs.

## الربط مع الكود

عند إضافة أي قصة إلى `lib/data/stories_data.dart`، يجب أن تكون `imageAsset` بالشكل:
`assets/images/stories/<slug>/<slug>_N_01.png`

و`audioAsset` بالشكل:
`audio/stories/<slug>/<slug>_N.mp3`

ثم يربط `AudioProvider` الاسم المنطقي بتسلسل `a → quran → b`، كما هو مطبق حاليًا في قصة نوح. لا تغيّر مسار نوح الحالي أثناء إضافة القصص الجديدة.
