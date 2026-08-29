# Baraem — Character Image Specification

هذا الملف هو المرجع الرسمي لإنشاء صور شخصية Baraem وربطها لاحقًا بالتطبيق.

## المقاس الموحد

- **المقاس الأساسي:** 1024×1024 px
- **النسبة:** 1:1
- **الصيغة:** PNG
- **الخلفية:** شفافة (Transparent PNG)
- **الاستخدام:** avatar، بطاقة الشخصية، المشاركة، وحالات الشخصية داخل التطبيق.
- اترك هامشًا آمنًا حول الشخصية 10% تقريبًا حتى لا تُقص عند عرضها داخل الدائرة أو البطاقة.

## الهوية البصرية

2D high-quality children's illustration، نفس هوية Baraem: أشكال مستديرة، خطوط ناعمة، ألوان دافئة، إضاءة لطيفة، تفاصيل قليلة وواضحة، شخصية محببة للأطفال 2–13 سنة.

ممنوع: النصوص، الشعارات، العلامات المائية، الخلفيات المزدحمة، الأسلحة، العنف، الرعب، أو ملامح واقعية مخيفة.

## الشخصيات الأساسية

### 01 — الشخصية الرئيسية
**Filename:** `baraem_avatar_01.png`

**Prompt:**
> Baraem signature child character, friendly 2D high-quality children's illustration, age-appropriate young child, rounded face, cheerful gentle expression, simple modest colorful clothing, warm soft lighting, clean shapes, centered full-body character, transparent background, consistent Baraem visual identity, cute educational mobile app style, no text, no logo, no watermark, no photorealism, 1024x1024.

### 02 — الشخصية المرحة
**Filename:** `baraem_avatar_02.png`

**Prompt:**
> Baraem children's character, playful happy child, energetic but gentle pose, friendly smile, rounded soft shapes, modest colorful clothes, 2D premium storybook illustration, warm lighting, transparent background, centered full-body composition, consistent Baraem identity, suitable for ages 2–13, no text, no logo, no watermark, no photorealism, 1024x1024.

### 03 — شخصية التعلم
**Filename:** `baraem_avatar_03.png`

**Prompt:**
> Baraem children's learning character, curious young child holding a simple open book, calm encouraging expression, rounded proportions, modest colorful clothing, high-quality 2D children's illustration, soft warm light, transparent background, centered full-body pose, clean uncluttered design, consistent Baraem visual identity, no text, logo or watermark, 1024x1024.

### 04 — الشخصية المشجعة
**Filename:** `baraem_avatar_04.png`

**Prompt:**
> Baraem children's encouragement character, kind supportive young child giving a gentle thumbs-up gesture, warm reassuring smile, rounded shapes, modest colorful clothing, premium 2D children's illustration, soft warm lighting, transparent background, centered full-body composition, friendly educational mobile app style, no text, no logo, no watermark, 1024x1024.

### 05 — شخصية الاحتفال
**Filename:** `baraem_avatar_05.png`

**Prompt:**
> Baraem children's celebration character, joyful young child celebrating success with both hands raised gently, happy confident expression, subtle small star shapes around the character, rounded soft forms, modest colorful clothing, high-quality 2D children's illustration, warm lighting, transparent background, centered full-body character, consistent Baraem identity, no text, no logo, no watermark, 1024x1024.

## ربط الحالات بالكود

`lib/character/character_state.dart` يعرّف الحالات الحالية:

- `idle`
- `happy`
- `learning`
- `encourage`
- `celebrate`

لذلك يُفضّل أن تتوافق صور الحالات مع هذه الحالات بدل إنشاء أسماء عشوائية. الكود الحالي يغيّر الحالة عند فتح التطبيق، بدء النشاط، إكمال النشاط، الحصول على نجمة، وفوات النشاط. 

### أسماء حالة مقترحة

| الحالة | الملف |
|---|---|
| idle | `character_idle.png` |
| happy | `character_happy.png` |
| learning | `character_learning.png` |
| encourage | `character_encourage.png` |
| celebrate | `character_celebrate.png` |

**ملاحظة:** ملفات `character_*.png` هي الأسماء الأنسب للربط البرمجي المباشر مع `CharacterMood`. أما `baraem_avatar_01..05` فهي مجموعة اختيار avatar للمستخدم، ولا تُربط بالحالات الخمس إلا إذا قررنا ذلك في الكود.

## Checklist

- [ ] 1024×1024
- [ ] PNG
- [ ] Transparent background
- [ ] الشخصية في المنتصف
- [ ] هامش آمن 10%
- [ ] نفس الهوية البصرية لبراعم
- [ ] لا نص أو شعار أو watermark
- [ ] تعبير مناسب للأطفال
- [ ] لا عناصر مخيفة أو عنيفة
