# Baraem — Asset Specification

مرجع تنفيذي موحد لإنشاء وإضافة الأصول البصرية والصوتية في Baraem.

## 1. Story Images

| Asset | Size | Ratio | Format | Naming |
|---|---:|---:|---|---|
| Story scene | 1024×576 | 16:9 | JPG | `nuh_1_01.jpg` |
| Story scene | 1024×576 | 16:9 | JPG | `nuh_1_02.jpg` |
| Story cover | 1024×576 | 16:9 | JPG | `<story>_cover.jpg` |

**قاعدة:** 1024×576 هو المقاس القياسي، وليس 1024×190.

## 2. Audio Icon

- Master: **512×512 px**
- App/UI: **256×256 px** أو SVG
- PNG transparent عند الحاجة
- Filename: `assets/images/ui/audio_icon.png`
- بدون نص داخل الأيقونة.
- تصميم مستدير، لطيف، واضح للأطفال، ومتوافق مع هوية Baraem.

## 3. Baraem App Icon

- Master: **1024×1024 px**
- Android source: **512×512 px** على الأقل
- Adaptive icon foreground: **1024×1024 px**
- Adaptive icon background: **1024×1024 px**
- Filename: `assets/images/branding/baraem_icon.png`
- Keep the important logo content inside the central safe area.

## 4. Full-Screen Splash

- Primary master: **1080×1920 px**
- High-resolution master: **1440×2560 px**
- Ratio: **9:16**
- Filename: `assets/images/branding/baraem_splash.png`
- Important content stays centered and inside the safe area.
- No modern UI elements inside the artwork.

## 5. Five Avatars

Five selectable child-friendly characters are reserved for profile/avatar selection and sharing gameplay achievements.

| Avatar | Master | App | File |
|---|---:|---:|---|
| 01 | 1024×1024 | 512×512 | `avatar_01.png` |
| 02 | 1024×1024 | 512×512 | `avatar_02.png` |
| 03 | 1024×1024 | 512×512 | `avatar_03.png` |
| 04 | 1024×1024 | 512×512 | `avatar_04.png` |
| 05 | 1024×1024 | 512×512 | `avatar_05.png` |

Path:

`assets/images/avatars/`

Requirements:
- PNG transparent.
- Same 2D Baraem visual identity across all five.
- Rounded, friendly, high-quality forms.
- Suitable for ages 2–13.
- No text, watermark, or logo inside the avatar artwork.
- Consistent lighting, proportions, line quality, and rendering.

## 6. Story Visual Identity

All prophet-story images must use one consistent 2D children's illustration language. For Prophet Nuh (peace be upon him), represent him respectfully from behind or as a distant figure and **never show his face or facial features**.

Story scenes:
- no text in image
- no watermark
- no modern clothes or tools
- no frightening or violent imagery
- warm, coherent lighting
- consistent palette and rounded forms
- 16:9 / 1024×576

## 7. Asset Paths

```text
assets/
├── images/
│   ├── stories/
│   │   ├── nuh_1_01.jpg
│   │   ├── nuh_1_02.jpg
│   │   └── ...
│   ├── avatars/
│   │   ├── avatar_01.png
│   │   ├── avatar_02.png
│   │   ├── avatar_03.png
│   │   ├── avatar_04.png
│   │   └── avatar_05.png
│   ├── branding/
│   │   ├── baraem_icon.png
│   │   └── baraem_splash.png
│   └── ui/
│       └── audio_icon.png
└── audio/
    ├── adkar/
    └── stories/
```

## 8. Integration Checklist

An asset is considered integrated only when all of the following are true:

- [ ] File exists in the specified directory.
- [ ] Filename exactly matches the Dart reference.
- [ ] Correct dimensions and format.
- [ ] Asset directory is declared in `pubspec.yaml` where required.
- [ ] No duplicate/old filename is accidentally used.
- [ ] UI has a graceful fallback if the asset is missing.
- [ ] `flutter analyze` passes.
- [ ] Tests pass.
- [ ] Release/debug APK can launch on a physical Android device.

## 9. Creation Order

Recommended order for the current visual update:

1. `audio_icon.png`
2. `baraem_icon.png`
3. `baraem_splash.png`
4. `avatar_01.png` → `avatar_05.png`
5. Story scenes `nuh_1_01.jpg` → remaining scenes
6. Add/verify all paths in `pubspec.yaml` and Dart data files.

This file is a specification/reference; creating a README does not itself create binary image/audio assets. The actual PNG/JPG/MP3 files must be committed separately and then linked from the app code.
