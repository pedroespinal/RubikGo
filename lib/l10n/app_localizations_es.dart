// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'RubikGo';

  @override
  String get homeTitle => 'RubikGo';

  @override
  String get homeSubtitle =>
      'Resuelve tu cubo Rubik en los movimientos más rápidos';

  @override
  String get homeScanPhoto => 'Escanear con cámara';

  @override
  String get homeScanManual => 'Elegir colores manualmente';

  @override
  String get homePractice => 'Modo práctica';

  @override
  String get homeGuide => 'Guía de usuario';

  @override
  String get homeSettings => 'Ajustes';

  @override
  String get homeAbout => 'Acerca de';

  @override
  String get colorWhite => 'Blanco';

  @override
  String get colorYellow => 'Amarillo';

  @override
  String get colorRed => 'Rojo';

  @override
  String get colorOrange => 'Naranja';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorGreen => 'Verde';

  @override
  String get faceUp => 'Arriba';

  @override
  String get faceDown => 'Abajo';

  @override
  String get faceFront => 'Frente';

  @override
  String get faceBack => 'Atrás';

  @override
  String get faceLeft => 'Izquierda';

  @override
  String get faceRight => 'Derecha';

  @override
  String cameraTitle(String face) {
    return 'Foto de la cara: $face';
  }

  @override
  String get cameraInstructions =>
      'Alinea la cara del cubo dentro de la cuadrícula y toma la foto. Repite para las 6 caras.';

  @override
  String get cameraAnyOrderHint =>
      'No importa qué cara es cuál ni en qué orden las fotografíes: solo gira el cubo y muéstrale a la cámara una cara que no hayas fotografiado todavía.';

  @override
  String get cameraCapture => 'Capturar';

  @override
  String get cameraRetake => 'Repetir foto';

  @override
  String get cameraUsePhoto => 'Usar foto';

  @override
  String get cameraReviewInstructions =>
      'Revisa que los 9 colores se vean bien alineados dentro del recuadro antes de continuar.';

  @override
  String get cameraPermissionDenied =>
      'Se necesita permiso de cámara para escanear el cubo.';

  @override
  String cameraFaceProgress(int current) {
    return 'Cara $current de 6';
  }

  @override
  String get correctionTitle => 'Revisa los colores detectados';

  @override
  String get correctionInstructions =>
      'Toca cualquier sticker para corregirlo si la detección automática se equivocó.';

  @override
  String get correctionContinue => 'Continuar';

  @override
  String get manualPickerTitle => 'Elige los colores de tu cubo';

  @override
  String get manualPickerInstructions =>
      'Toca un color de la paleta y luego toca cada sticker para pintarlo. Completa las 6 caras.';

  @override
  String get manualPickerReset => 'Reiniciar';

  @override
  String get manualPickerSolve => 'Resolver';

  @override
  String get validationTitle => 'Estado del cubo inválido';

  @override
  String validationColorCount(String colors) {
    return 'Cada color debe aparecer exactamente 9 veces. Revisa: $colors.';
  }

  @override
  String get validationDuplicateCenters =>
      'Las 6 caras centrales deben tener colores distintos.';

  @override
  String get validationUnsolvable =>
      'Esta combinación de colores no corresponde a un cubo físico real. Revisa que cada sticker coincida con tu cubo y vuelve a intentar.';

  @override
  String get validationOk => 'Entendido';

  @override
  String get solutionTitle => 'Solución';

  @override
  String solutionStepOf(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String solutionMoveCount(int count) {
    return '$count movimientos';
  }

  @override
  String get solutionNext => 'Siguiente';

  @override
  String get solutionPrevious => 'Anterior';

  @override
  String get solutionRestart => 'Reiniciar solución';

  @override
  String get solutionSolved => '¡Cubo resuelto! 🎉';

  @override
  String get solutionAlreadySolved => 'Tu cubo ya está resuelto.';

  @override
  String get practiceTitle => 'Modo práctica';

  @override
  String get practiceScramble => 'Nuevo scramble';

  @override
  String get practiceStart => 'Iniciar cronómetro';

  @override
  String get practiceStop => 'Detener';

  @override
  String practiceBestTime(String time) {
    return 'Mejor tiempo: $time';
  }

  @override
  String practiceLastTime(String time) {
    return 'Último tiempo: $time';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeSystem => 'Automático (sistema)';

  @override
  String get settingsColorblind => 'Modo daltónico (letras sobre los colores)';

  @override
  String get settingsCheckUpdate => 'Buscar actualizaciones';

  @override
  String get settingsCheckingUpdate => 'Buscando...';

  @override
  String get settingsUpToDate => 'Ya tienes la última versión.';

  @override
  String settingsUpdateAvailable(String version) {
    return 'Nueva versión disponible: $version';
  }

  @override
  String get settingsUpdateError =>
      'No se pudo comprobar actualizaciones. Revisa tu conexión.';

  @override
  String get aboutTitle => 'Acerca de RubikGo';

  @override
  String aboutVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get aboutCreationDate => 'Aplicación creada el 05/08/2026';

  @override
  String get aboutSignature => 'Firma digital de compilación';

  @override
  String get aboutSignatureExplain =>
      'Huella criptográfica única de esta compilación (versión + autor + fecha de creación). No puede editarse ni eliminarse desde la aplicación.';

  @override
  String get aboutFooter =>
      '© Creado por Pedro Espinal — Todos los derechos reservados 2026';

  @override
  String get aboutSourceLink => 'Ver código fuente en GitHub';

  @override
  String updateBannerTitle(String version) {
    return 'Nueva versión disponible: $version';
  }

  @override
  String get updateBannerAction => 'Ver en GitHub';

  @override
  String get updateBannerDismiss => 'Ahora no';

  @override
  String get guideTitle => 'Guía de usuario';

  @override
  String get guideIntroTitle => '¿Qué es RubikGo?';

  @override
  String get guideIntroBody =>
      'RubikGo lee el estado de tu cubo Rubik 3x3 (por foto o eligiendo colores a mano) y calcula la solución con el menor número de movimientos posible, usando el algoritmo de dos fases de Kociemba — el mismo tipo de algoritmo que usan los solvers más rápidos del mundo.';

  @override
  String get guideScanTitle => 'Cómo escanear tu cubo con la cámara';

  @override
  String get guideScanBody =>
      '1. Toca \"Escanear con cámara\" en la pantalla principal.\n2. Sostén el cubo con buena luz y alinea la cara que te quede de frente dentro de la cuadrícula guía.\n3. Toma la foto, revisa que se vea bien alineada y confirma con \"Usar foto\". No importa qué cara es cuál ni en qué orden las muestres: solo gira el cubo hacia cualquier lado que no hayas fotografiado y repite hasta completar las 6. La franja de miniaturas de abajo te muestra tu progreso y te deja tocar cualquiera para repetirla.\n4. En la pantalla de corrección, revisa los colores detectados y ajusta cualquier sticker mal identificado antes de continuar.';

  @override
  String get guideManualTitle => 'Cómo elegir los colores manualmente';

  @override
  String get guideManualBody =>
      '1. Toca \"Elegir colores manualmente\".\n2. Selecciona un color de la paleta inferior.\n3. Toca cada sticker de las 6 caras para pintarlo con ese color, mirando tu cubo físico como referencia.\n4. Cuando las 6 caras estén completas, toca \"Resolver\".';

  @override
  String get guideStepsTitle => 'Cómo leer los pasos de solución';

  @override
  String get guideStepsBody =>
      'Cada paso muestra un movimiento en notación estándar de Rubik. Usa los botones \"Anterior\"/\"Siguiente\" para avanzar a tu ritmo, y el dibujo del cubo se actualiza para mostrar cómo debe quedar después de cada movimiento.';

  @override
  String get guideNotationTitle => 'Notación de movimientos';

  @override
  String get guideNotationBody =>
      'U = Arriba, D = Abajo, F = Frente, B = Atrás, L = Izquierda, R = Derecha. Una letra sola gira esa cara 90° en sentido horario. Un apóstrofe (\') gira en sentido antihorario. Un 2 gira 180°. Ejemplo: R\' significa girar la cara derecha 90° en sentido antihorario.';

  @override
  String get guideFaqTitle => 'Preguntas frecuentes';

  @override
  String get guideFaqBody =>
      '¿Por qué necesito fotografiar las 6 caras? Porque para calcular una solución hace falta conocer la posición de las 54 piezas del cubo, no solo de una cara.\n\n¿Qué hago si dice \"estado inválido\"? Revisa que cada color aparezca exactamente 9 veces y que ningún sticker esté mal asignado; vuelve a escanear o corrige manualmente.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonClose => 'Cerrar';
}
