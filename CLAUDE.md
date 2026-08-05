# RubikGo — reglas del proyecto

- **No compilar hasta arreglar todos los errores/bugs**: `flutter analyze` y
  `flutter test` deben pasar limpios antes de cualquier build de release.
  `scripts/build_release.ps1` ya obliga esto.
- **La versión debe incrementar en cada build de release**, y el APK
  siempre debe llevar la versión en el nombre del archivo
  (`RubikGo-v<version>-b<build>.apk`), nunca solo el nombre genérico de
  Flutter.
- **Siempre publicar después de compilar**: cada vez que
  `scripts/build_release.ps1` termine exitosamente, seguir de inmediato con
  `scripts/publish_release.ps1` (commit + push + GitHub Release con el APK
  adjunto) sin pedir confirmación adicional — el usuario ya autorizó este
  flujo de forma permanente.
- El footer de copyright (`© Creado por Pedro Espinal — Todos los derechos
  reservados 2026`) y la firma digital de compilación son inmutables: no
  agregar ninguna forma de editarlos/ocultarlos desde la UI.
