# RubikGo

Escanea tu cubo Rubik 3x3 (por foto o eligiendo colores manualmente) y obtén
la solución con el menor número de movimientos posible, usando el algoritmo
de dos fases de Kociemba. Bilingüe (ES/EN), con modo claro/oscuro y modo
práctica con scramble + cronómetro.

Scan your 3x3 Rubik's Cube (by photo or by manually choosing colors) and get
the solution in the fewest possible moves, using Kociemba's two-phase
algorithm. Bilingual (ES/EN), with light/dark mode and a practice mode with
scramble + timer.

## Desarrollo / Development

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

## Compilar una versión de release / Building a release

```bash
powershell -File scripts/build_release.ps1
```

Este script corre `flutter analyze` y `flutter test` como condición
obligatoria antes de incrementar la versión y compilar el APK — nunca se
publica una versión con errores o tests fallando.

This script runs `flutter analyze` and `flutter test` as a mandatory gate
before bumping the version and building the APK — a version is never
published with failing checks.

---

© Creado por Pedro Espinal — Todos los derechos reservados 2026
