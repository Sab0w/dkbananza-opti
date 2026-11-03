# DKBananza Opti : source et compilation

`DKBananza Opti/DKBananzaOpti.exe` est compilé à partir de :

1. [Selevet Eglantine](https://github.com/sylvieistaken/selevet-eglantine), commit `bce3c8373973c11fc8de853c5b208fd9703b6d0d` (tag `selevet-eglantine-performance-2`) ;
2. **avec `dkbananza-opti.patch` appliqué** (37 fichiers), qui contient :
   - les changements de Selevet performance-3 et performance-4 ;
   - le format NUP d'Eglantine (commits `31b901b93b`, `b8d2c08d6e` et `926e7ac6af` de [Djihads80/Eglantine](https://github.com/Djihads80/Eglantine), sans les tests ni `eden-cli`) ;
   - le correctif des alias de textures (`EDEN_NX2_ALIAS_WATERMARK`) ;
   - l'arrêt de la capture des shaders au saut invalide (`EDEN_NX2_CAPTURE_STOP`) ;
   - le renommage en DKBananza Opti ;
   - les sources `src/audio_core/out/`, absentes du dépôt Selevet (son `.gitignore` exclut les dossiers `out/`) et reprises d'Eglantine build 31.

## Compiler

Outils (versions utilisées) :
- LLVM 23.1.4 (`clang-cl`, `lld-link`, `llvm-lib`) ;
- Visual Studio 2026 Build Tools (MSVC 14.51 et Windows SDK), requis par le Qt 6.11 téléchargé par le projet ;
- CMake et Ninja (fournis avec Visual Studio) ;
- Python 3, Vulkan SDK, Git (avec `patch`).

```bash
git clone https://github.com/sylvieistaken/selevet-eglantine selevet
cd selevet
git checkout bce3c8373973c11fc8de853c5b208fd9703b6d0d
git apply ../source/dkbananza-opti.patch
```

Mets ensuite le dossier `selevet` à côté de `build-selevet.bat` (le script s'attend à `<dossier du script>\selevet`), copie `use-cache.cmake` et `bananza.profdata` dans un même dossier, et adapte les chemins `D:/BuildTools/...` des fichiers `.cmake` et du `.bat` à ta machine. Puis lance :

```bat
build-selevet.bat build-use <chemin>\use-cache.cmake
```

L'exécutable est produit dans `selevet\build-use\bin\DKBananzaOpti.exe`.

## Profil PGO

`bananza.profdata` est fusionné avec `llvm-profdata merge` à partir de :
- `tuned/eglantine.profdata` de Selevet (Mario Kart World), poids 1 ;
- une session Donkey Kong Bananza sur la build actuelle, poids 3 ;
- une session Bananza plus ancienne, poids 1.

Pour entraîner ton propre profil, compile avec `gen-cache.cmake` et lance l'exécutable avec `LLVM_PROFILE_FILE=<dossier>\bananza-%p.profraw`. Le profil est écrit toutes les 30 secondes. Joue, puis fusionne :

```bash
llvm-profdata merge -o bananza-current.profdata <dossier>/bananza-*.profraw
llvm-profdata merge -o bananza.profdata selevet/tuned/eglantine.profdata -weighted-input=3,bananza-current.profdata
```

## Licence

GPL-3.0-or-later. Les modifications ont été écrites avec l'aide de Claude (Anthropic).
