# DKBananza Opti (expérimental)

Build expérimentale et non officielle de l'émulateur Switch 2 **Eglantine**, optimisée pour **Donkey Kong Bananza** (version 458752) sur PC Windows x64.

Elle est basée sur [Selevet Eglantine](https://github.com/sylvieistaken/selevet-eglantine) (performance-2, commit `bce3c83`, avec les changements des performances 3 et 4), elle-même dérivée d'[Eglantine](https://github.com/Djihads80/Eglantine), d'Eden et de yuzu. Tout le mérite de l'émulateur revient à ces projets. **Merci de ne pas leur signaler les problèmes de cette build.**

**Aucun jeu, aucune clé, aucun firmware n'est inclus.** Utilise tes propres dumps légaux.

## Utilisation

1. Copie le dossier `DKBananza Opti` où tu veux.
2. Lance `DKBananzaOpti.exe`, ou `Lancer DKBananza Opti.bat` pour démarrer en priorité haute.
3. Ajoute tes clés et ton firmware, configure ta manette, puis ouvre le jeu.

Il faut un processeur avec AVX2 et le dernier [runtime Visual C++ x64](https://aka.ms/vs/17/release/vc_redist.x64.exe).

La build partage sa configuration avec les autres builds Eden/Eglantine (`%APPDATA%\eden`). Sauvegarde ce dossier si tu en utilises d'autres. Pour avoir une configuration séparée, crée un dossier vide nommé `user` à côté de `DKBananzaOpti.exe` et place-y tes clés et ton firmware.

Réglages testés (dans l'émulateur) :
- mode TV (« Docked ») ;
- résolution 1x ;
- précision GPU Low, DMA Unsafe, CPU Unsafe ;
- shaders et présentation asynchrones activés.

## Ce qui change par rapport à Selevet performance-2

- **Profil d'optimisation (PGO) entraîné sur Donkey Kong Bananza**, fusionné avec le profil Mario Kart World de Selevet. Le profil de Selevet n'était entraîné que sur Mario Kart World.
- **Vérification des alias de textures en temps constant** (`EDEN_NX2_ALIAS_WATERMARK`). C'était la boucle la plus exécutée du thread GPU dans Bananza.
- **Shaders natifs avec des données après leur fin** : ils ne sont plus rejetés en bloc (`EDEN_NX2_CAPTURE_STOP`). La capture s'arrête au saut invalide et le traducteur juge le reste.
- **Écran lavande/bleu après une téléportation corrigé.** C'est le correctif de l'upscaler de secours de Selevet performance-3, intégré ici.
- **Saut des dessins dont le pipeline est en construction** (Selevet performance-4) et AVX-512 désactivé dans le traducteur CPU (performance-3).
- **Format NUP (paquet non chiffré)** repris d'Eglantine : chargement des jeux `.nup` et « Convertir en NUP » dans la liste des jeux.
- **Compilation** : Clang 23.1.4, ThinLTO, `-march=x86-64-v3 -mtune=znver4`.
- **Nom de la build** : DKBananza Opti, exécutable `DKBananzaOpti.exe`.

## Mesures (une seule machine)

Ryzen 9 7950X3D, RTX 4080, mode TV, 1x. Même endroit (zone de la cascade, face au bloc violet) :

| Build | fps |
|---|---|
| Selevet performance-2 officielle | ~42 |
| DKBananza Opti | ~52-55 |

Sur les très grandes vues, le jeu envoie environ 8 000 dessins par image. Ils sont tous préparés sur un seul thread de l'émulateur, ce qui peut faire descendre vers 40 fps. **Ce n'est pas du 60 fps verrouillé.**

## Réglages (`nx2_switches.txt`)

- `EDEN_NX2_UNSAFE_PREEMPTIVE_READS=1` est activé. C'est un raccourci « unsafe » : supprime la ligne si tu vois des glitches graphiques.
- `EDEN_NX2_QMD_ACQUIRE_SKIP` est **désactivé** : il a provoqué un gel complet (un canal GPU attendait un sémaphore déjà réinitialisé).
- `EDEN_NX2_UBOREUSE` est désactivé : mesuré plus lent (42 fps contre 53).
- `EDEN_NX2_SHADOW_SKIP` est désactivé : environ 11 % plus rapide, mais les ombres tremblent.

## Problèmes connus

- Build expérimentale, testée sur une seule machine et un seul jeu.
- Le raccourci « Changer de mode Docked » peut faire passer en mode portable en cours de partie. Clique sur « HANDHELD » dans la barre d'état pour revenir en « DOCKED ».
- Les messages d'interface affichent encore « Eglantine » à certains endroits.

## Code source et licence

GPL-3.0-or-later, comme les projets d'origine (voir `LICENSE.txt`). Le code source correspondant est dans le dossier `source/` du dépôt : un patch à appliquer sur Selevet `bce3c83`, la recette de compilation et le profil PGO.

Les modifications ont été écrites avec l'aide de Claude (Anthropic), puis testées en jeu. Elles n'ont pas été relues par les développeurs d'Eglantine ou de Selevet.
