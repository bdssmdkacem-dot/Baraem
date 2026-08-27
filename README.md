# براعم (Baraem)

Jeu éducatif freemium pour enfants 2-6 ans autour des valeurs islamiques :
أذكار (dhikr), قصص الأنبياء (histoires des prophètes), آداب (bonnes manières).

## 🐛 Bug corrigé (session du 27/08) — l'app ne s'ouvrait pas sur téléphone

**Cause** : `lib/widgets/baraem_character.dart` appelait
`context.watch<CharacterState>()`, mais seul `CharacterProvider` (qui
encapsule `CharacterState` en interne, sans jamais l'exposer au widget tree)
était enregistré dans `main.dart`. Résultat : une `ProviderNotFoundException`
à **chaque** construction de `HomeScreen` — soit dès le tout premier écran
de l'app.

**Pourquoi `flutter analyze` et `flutter test` passaient quand même** :
c'est un type mismatch détecté seulement à l'exécution (Provider ne fait pas
de vérification statique), et **aucun test existant ne construisait
`HomeScreen`** — donc rien ne pouvait le détecter en CI. `test/baraem_smoke_test.dart`
pompe maintenant `HomeScreen` avec exactement le même `MultiProvider` que
`main.dart` et vérifie qu'aucun `ErrorWidget` n'apparaît, pour que ce type de
régression soit détecté avant le prochain push, pas après installation sur
un téléphone.

**Autres correctifs de la même session** :
- `google_mobile_ads`, `google_fonts`, `lottie`, `flutter_svg` retirés du
  `pubspec.yaml` : aucun n'était utilisé côté Dart. `google_mobile_ads` en
  particulier peut planter au démarrage nativement (avant même que Dart ne
  s'exécute) si le meta-data `com.google.android.gms.ads.APPLICATION_ID`
  manque dans le manifeste — risque gratuit pour zéro bénéfice tant que les
  pubs ne sont pas réellement implémentées.
- `generate: true` retiré (config l10n morte, aucun fichier `.arb`).
- Permission `INTERNET` ajoutée à `android/app/src/main/AndroidManifest.xml`
  (le manifeste de debug l'ajoutait déjà automatiquement, pas celui de release).
- Version Flutter du workflow CI mise à jour vers `3.44.7` (version stable
  vérifiée au moment de cette session).

## 🎨 Illustrations

Les 18 images fournies (personnages, couvertures d'histoires, mascotte, bannière
d'accueil) étaient en pleine résolution "fond d'écran" (768×1376, 11,2 Mo au
total). Elles ont été redimensionnées/compressées pour un usage réel en app
(~1,3 Mo au total) et intégrées :

- `assets/images/adab/*.jpg` — les 7 scénarios آداب
- `assets/images/stories/*_cover.jpg` — couvertures des 4 histoires
- `assets/images/stories/{nuh_1,nuh_2,yunus_1,ibrahim_2}.jpg` — illustrations
  de pages intérieures (partiel, voir ⏳ ci-dessous)
- `assets/images/mascot/mascot_girl.jpg` — recadrée en avatar carré (visage +
  main levée) depuis `mascot.png`, utilisée dans `BaraemCharacter` (accueil)
  et `MascotWidget` (écran آداب)
- `assets/images/home/home_illustration.jpg` — bannière écran d'accueil
- `docs/logo-baraem.png` — logo avec texte intégré, pour le README/store
  listing uniquement (pas bundlé dans l'app, le texte ferait doublon avec l'UI)

Toutes les images (`Image.asset`) ont un `errorBuilder` de repli : un asset
manquant ou mal orthographié affiche une icône placeholder au lieu de planter
— même classe de défense que le fix du bug principal.

⏳ **Encore à faire** :
- Illustrations manquantes : page 1 de إبراهيم, 3 pages de يوسف
  (`lib/data/stories_data.dart` — `imageAsset` reste `null` là où le fichier
  n'existe pas, `story_detail_screen.dart` gère déjà ce cas proprement)
- `assets/audio/adkar/*.mp3` et `assets/audio/stories/*.mp3` — aucun fichier
  audio n'existe encore. `AudioProvider.playAsset()` est déjà protégé par
  try/catch (pas de crash, juste un `lastError` silencieux), mais le bouton
  lecture ne fait donc rien tant que les fichiers ne sont pas ajoutés.
- Police custom (`BalooArabic`) référencée dans `app_theme.dart` mais jamais
  embarquée — l'app utilise donc la police système par défaut, sans crash.

## 📦 Récupérer l'APK

Le workflow `.github/workflows/build.yml` compile un **APK debug** (adapté
pour tester sur ton téléphone, pas pour publier sur le Play Store) à chaque
push sur `main` :

1. Pousse ce zip dans ton repo GitHub `Baraem` (remplace tout le contenu).
2. Onglet **Actions** du repo → attends que le workflow se termine (~5-10 min).
3. Ouvre le run terminé → section **Artifacts** en bas de page → télécharge
   `baraem-debug-apk`.
4. Décompresse, transfère `app-debug.apk` sur ton téléphone, installe
   (autorise les sources inconnues si demandé).

Le workflow génère aussi automatiquement `android/` et `ios/` au premier run
(via `flutter create`) et les commit dans le repo — normal de voir un commit
`android: add Flutter Android project` apparaître après coup.

Pour un **APK/AAB signé pour le Play Store**, il faudra ajouter une étape de
signing (keystore + `key.properties`) au workflow — pas fait ici, ce n'était
pas le besoin immédiat (test sur téléphone).

## Contenu à compléter avant publication

- `lib/data/adkar_data.dart`, `lib/data/stories_data.dart` — contenu
  religieux d'exemple, à étoffer et **faire relire par quelqu'un de qualifié**
  avant toute publication.
- IAP (`purchase_provider.dart`) : produit `baraem_premium_unlock` à créer
  dans Play Console, et validation serveur du reçu recommandée avant prod
  (actuellement le déblocage fait confiance au statut local du store).

## Architecture (état actuel)

- `core/` — `AppErrorHandler` (capture les erreurs Flutter/zone, affiche un
  écran de repli au lieu de crasher), `StorageService` (wrapper
  SharedPreferences), `AppScale` (paddings/tailles responsives), `AppRoutes`.
- `providers/` + `activities/` — `AppStateProvider`, `ProgressProvider`,
  `CharacterProvider` (encapsule `CharacterState`, humeur du personnage),
  `PurchaseProvider`, `ActivityProvider` (orchestre les activités du jour).
- `screens/` — `HomeScreen` (route initiale), `AdkarScreen`, `StoriesScreen`
  + `StoryDetailScreen`, `AdabScreen`.
- `test/` — 8 fichiers, dont `baraem_smoke_test.dart` (voir bug ci-dessus).
