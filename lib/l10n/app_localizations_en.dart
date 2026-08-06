// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RubikGo';

  @override
  String get homeTitle => 'RubikGo';

  @override
  String get homeSubtitle => 'Solve your Rubik\'s Cube in the fastest moves';

  @override
  String get homeScanPhoto => 'Scan with camera';

  @override
  String get homeScanManual => 'Choose colors manually';

  @override
  String get homePractice => 'Practice mode';

  @override
  String get homeGuide => 'User guide';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeAbout => 'About';

  @override
  String get colorWhite => 'White';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorRed => 'Red';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorGreen => 'Green';

  @override
  String get faceUp => 'Up';

  @override
  String get faceDown => 'Down';

  @override
  String get faceFront => 'Front';

  @override
  String get faceBack => 'Back';

  @override
  String get faceLeft => 'Left';

  @override
  String get faceRight => 'Right';

  @override
  String cameraTitle(String face) {
    return 'Photo of face: $face';
  }

  @override
  String get cameraInstructions =>
      'Align the cube face inside the grid and take the photo. Repeat for all 6 faces.';

  @override
  String get cameraAnyOrderHint =>
      'It doesn\'t matter which face is which or what order you photograph them in — just turn the cube and show the camera any face you haven\'t photographed yet.';

  @override
  String get cameraToggleFlash =>
      'Turn the flash on/off to improve color detection';

  @override
  String get cameraConfirmColorsInstructions =>
      'Check the colors detected for this face. Tap a palette color, then tap any sticker to fix it.';

  @override
  String get cameraConfirmColors => 'Confirm colors';

  @override
  String get cameraCapture => 'Capture';

  @override
  String get cameraRetake => 'Retake photo';

  @override
  String get cameraUsePhoto => 'Use photo';

  @override
  String get cameraReviewInstructions =>
      'Check that all 9 colors line up well inside the box before continuing.';

  @override
  String get cameraPermissionDenied =>
      'Camera permission is required to scan the cube.';

  @override
  String cameraFaceProgress(int current) {
    return 'Face $current of 6';
  }

  @override
  String get correctionTitle => 'Review detected colors';

  @override
  String get correctionInstructions =>
      'Tap any sticker to correct it if automatic detection got it wrong.';

  @override
  String get correctionContinue => 'Continue';

  @override
  String get manualPickerTitle => 'Choose your cube\'s colors';

  @override
  String get manualPickerInstructions =>
      'Tap a color in the palette, then tap each sticker to paint it. Complete all 6 faces.';

  @override
  String get manualPickerReset => 'Reset';

  @override
  String get manualPickerSolve => 'Solve';

  @override
  String get validationTitle => 'Invalid cube state';

  @override
  String get validationIncomplete =>
      'Some stickers haven\'t been painted yet. Complete all 6 faces before continuing.';

  @override
  String validationColorCount(String colors) {
    return 'Each color must appear exactly 9 times. Check: $colors.';
  }

  @override
  String get validationDuplicateCenters =>
      'The 6 center pieces must all be different colors.';

  @override
  String get validationUnsolvable =>
      'This color combination doesn\'t match a real physical cube. Check that every sticker matches your cube and try again.';

  @override
  String get validationTwistedPiece =>
      'A piece on an edge or corner looks rotated compared to your real cube (its colors are in the wrong order). Check the stickers where two or three faces meet.';

  @override
  String get validationProbableSwap =>
      'Two stickers are likely swapped between two different spots — it\'s common to mix up similar colors like white/yellow or red/orange. Check each sticker against your real cube, especially near the borders between faces.';

  @override
  String get validationRotationFixTitle => 'Looks like a face got rotated';

  @override
  String validationRotationFixMessage(String color) {
    return 'The face with the $color center looks like it was photographed rotated relative to the others — this is the most common mistake when taking the 6 photos, since it\'s easy to lose track of \"which way is up\" while turning the cube between shots. Want the app to rotate it automatically to fix it?';
  }

  @override
  String get validationRotationFixApply => 'Rotate automatically';

  @override
  String get validationOk => 'OK';

  @override
  String get solutionTitle => 'Solution';

  @override
  String solutionStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String solutionMoveCount(int count) {
    return '$count moves';
  }

  @override
  String get solutionNext => 'Next';

  @override
  String get solutionPrevious => 'Previous';

  @override
  String get solutionRestart => 'Restart solution';

  @override
  String get solutionSolved => 'Cube solved! 🎉';

  @override
  String get solutionAlreadySolved => 'Your cube is already solved.';

  @override
  String solutionTurnClockwise(String color) {
    return 'Turn the $color face 90° clockwise (facing it directly)';
  }

  @override
  String solutionTurnCounterClockwise(String color) {
    return 'Turn the $color face 90° counter-clockwise (facing it directly)';
  }

  @override
  String solutionTurnDouble(String color) {
    return 'Turn the $color face 180° (either direction)';
  }

  @override
  String get practiceTitle => 'Practice mode';

  @override
  String get practiceScramble => 'New scramble';

  @override
  String get practiceStart => 'Start timer';

  @override
  String get practiceStop => 'Stop';

  @override
  String practiceBestTime(String time) {
    return 'Best time: $time';
  }

  @override
  String practiceLastTime(String time) {
    return 'Last time: $time';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsColorblind => 'Colorblind mode (letters over colors)';

  @override
  String get settingsCheckUpdate => 'Check for updates';

  @override
  String get settingsCheckingUpdate => 'Checking...';

  @override
  String get settingsUpToDate => 'You\'re on the latest version.';

  @override
  String settingsUpdateAvailable(String version) {
    return 'New version available: $version';
  }

  @override
  String get settingsUpdateError =>
      'Couldn\'t check for updates. Check your connection.';

  @override
  String get aboutTitle => 'About RubikGo';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutCreationDate => 'App created on 08/05/2026';

  @override
  String get aboutSignature => 'Build digital signature';

  @override
  String get aboutSignatureExplain =>
      'Unique cryptographic fingerprint of this build (version + author + creation date). Cannot be edited or removed from within the app.';

  @override
  String get aboutFooter =>
      '© Created by Pedro Espinal — All rights reserved 2026';

  @override
  String get aboutSourceLink => 'View source on GitHub';

  @override
  String updateBannerTitle(String version) {
    return 'New version available: $version';
  }

  @override
  String get updateBannerAction => 'View on GitHub';

  @override
  String get updateBannerDismiss => 'Not now';

  @override
  String get guideTitle => 'User guide';

  @override
  String get guideIntroTitle => 'What is RubikGo?';

  @override
  String get guideIntroBody =>
      'RubikGo reads the state of your 3x3 Rubik\'s Cube (by photo or by manually choosing colors) and computes the solution with the smallest possible number of moves, using Kociemba\'s two-phase algorithm — the same kind of algorithm used by the world\'s fastest solvers.';

  @override
  String get guideScanTitle => 'How to scan your cube with the camera';

  @override
  String get guideScanBody =>
      '1. Tap \"Scan with camera\" on the home screen.\n2. Hold the cube in good light and align whichever face is facing you inside the guide grid.\n3. Take the photo, check that it lines up well, and confirm with \"Use photo\". It doesn\'t matter which face is which or what order you show them in — just turn the cube to any side you haven\'t photographed yet and repeat until all 6 are done. The thumbnail strip at the bottom shows your progress and lets you tap any of them to retake it.\n4. On the correction screen, review the detected colors and fix any misidentified sticker before continuing.';

  @override
  String get guideManualTitle => 'How to choose colors manually';

  @override
  String get guideManualBody =>
      '1. Tap \"Choose colors manually\".\n2. Select a color from the palette at the bottom.\n3. Tap each sticker on all 6 faces to paint it with that color, using your physical cube as reference.\n4. Once all 6 faces are complete, tap \"Solve\".';

  @override
  String get guideStepsTitle => 'How to read the solution steps';

  @override
  String get guideStepsBody =>
      'Each step shows a move in standard Rubik\'s Cube notation. Use the \"Previous\"/\"Next\" buttons to move at your own pace, and the cube drawing updates to show what it should look like after each move.';

  @override
  String get guideNotationTitle => 'Move notation';

  @override
  String get guideNotationBody =>
      'U = Up, D = Down, F = Front, B = Back, L = Left, R = Right. A single letter turns that face 90° clockwise. An apostrophe (\') turns it counter-clockwise. A 2 turns it 180°. Example: R\' means turn the right face 90° counter-clockwise.';

  @override
  String get guideFaqTitle => 'Frequently asked questions';

  @override
  String get guideFaqBody =>
      'Why do I need to photograph all 6 faces? Because computing a solution requires knowing the position of all 54 pieces of the cube, not just one face.\n\nWhat if it says \"invalid state\"? Check that each color appears exactly 9 times and that no sticker is misassigned; rescan or correct it manually.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonBack => 'Back';

  @override
  String get commonClose => 'Close';
}
