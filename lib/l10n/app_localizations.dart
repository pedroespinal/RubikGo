import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'RubikGo'**
  String get appName;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'RubikGo'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Solve your Rubik\'s Cube in the fastest moves'**
  String get homeSubtitle;

  /// No description provided for @homeScanPhoto.
  ///
  /// In en, this message translates to:
  /// **'Scan with camera'**
  String get homeScanPhoto;

  /// No description provided for @homeScanManual.
  ///
  /// In en, this message translates to:
  /// **'Choose colors manually'**
  String get homeScanManual;

  /// No description provided for @homePractice.
  ///
  /// In en, this message translates to:
  /// **'Practice mode'**
  String get homePractice;

  /// No description provided for @homeGuide.
  ///
  /// In en, this message translates to:
  /// **'User guide'**
  String get homeGuide;

  /// No description provided for @homeSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettings;

  /// No description provided for @homeAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get homeAbout;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @faceUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get faceUp;

  /// No description provided for @faceDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get faceDown;

  /// No description provided for @faceFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get faceFront;

  /// No description provided for @faceBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get faceBack;

  /// No description provided for @faceLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get faceLeft;

  /// No description provided for @faceRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get faceRight;

  /// No description provided for @cameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo of face: {face}'**
  String cameraTitle(String face);

  /// No description provided for @cameraInstructions.
  ///
  /// In en, this message translates to:
  /// **'Align the cube face inside the grid and take the photo. Repeat for all 6 faces.'**
  String get cameraInstructions;

  /// No description provided for @cameraCapture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get cameraCapture;

  /// No description provided for @cameraRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake photo'**
  String get cameraRetake;

  /// No description provided for @cameraUsePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use photo'**
  String get cameraUsePhoto;

  /// No description provided for @cameraReviewInstructions.
  ///
  /// In en, this message translates to:
  /// **'Check that all 9 colors line up well inside the box before continuing.'**
  String get cameraReviewInstructions;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan the cube.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraFaceProgress.
  ///
  /// In en, this message translates to:
  /// **'Face {current} of 6'**
  String cameraFaceProgress(int current);

  /// No description provided for @correctionTitle.
  ///
  /// In en, this message translates to:
  /// **'Review detected colors'**
  String get correctionTitle;

  /// No description provided for @correctionInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap any sticker to correct it if automatic detection got it wrong.'**
  String get correctionInstructions;

  /// No description provided for @correctionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get correctionContinue;

  /// No description provided for @manualPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your cube\'s colors'**
  String get manualPickerTitle;

  /// No description provided for @manualPickerInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap a color in the palette, then tap each sticker to paint it. Complete all 6 faces.'**
  String get manualPickerInstructions;

  /// No description provided for @manualPickerReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get manualPickerReset;

  /// No description provided for @manualPickerSolve.
  ///
  /// In en, this message translates to:
  /// **'Solve'**
  String get manualPickerSolve;

  /// No description provided for @validationTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid cube state'**
  String get validationTitle;

  /// No description provided for @validationColorCount.
  ///
  /// In en, this message translates to:
  /// **'Each color must appear exactly 9 times. Check: {colors}.'**
  String validationColorCount(String colors);

  /// No description provided for @validationDuplicateCenters.
  ///
  /// In en, this message translates to:
  /// **'The 6 center pieces must all be different colors.'**
  String get validationDuplicateCenters;

  /// No description provided for @validationUnsolvable.
  ///
  /// In en, this message translates to:
  /// **'This color combination doesn\'t match a real physical cube. Check that every sticker matches your cube and try again.'**
  String get validationUnsolvable;

  /// No description provided for @validationOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get validationOk;

  /// No description provided for @solutionTitle.
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get solutionTitle;

  /// No description provided for @solutionStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String solutionStepOf(int current, int total);

  /// No description provided for @solutionMoveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} moves'**
  String solutionMoveCount(int count);

  /// No description provided for @solutionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get solutionNext;

  /// No description provided for @solutionPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get solutionPrevious;

  /// No description provided for @solutionRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart solution'**
  String get solutionRestart;

  /// No description provided for @solutionSolved.
  ///
  /// In en, this message translates to:
  /// **'Cube solved! 🎉'**
  String get solutionSolved;

  /// No description provided for @solutionAlreadySolved.
  ///
  /// In en, this message translates to:
  /// **'Your cube is already solved.'**
  String get solutionAlreadySolved;

  /// No description provided for @practiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice mode'**
  String get practiceTitle;

  /// No description provided for @practiceScramble.
  ///
  /// In en, this message translates to:
  /// **'New scramble'**
  String get practiceScramble;

  /// No description provided for @practiceStart.
  ///
  /// In en, this message translates to:
  /// **'Start timer'**
  String get practiceStart;

  /// No description provided for @practiceStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get practiceStop;

  /// No description provided for @practiceBestTime.
  ///
  /// In en, this message translates to:
  /// **'Best time: {time}'**
  String practiceBestTime(String time);

  /// No description provided for @practiceLastTime.
  ///
  /// In en, this message translates to:
  /// **'Last time: {time}'**
  String practiceLastTime(String time);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsColorblind.
  ///
  /// In en, this message translates to:
  /// **'Colorblind mode (letters over colors)'**
  String get settingsColorblind;

  /// No description provided for @settingsCheckUpdate.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get settingsCheckUpdate;

  /// No description provided for @settingsCheckingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get settingsCheckingUpdate;

  /// No description provided for @settingsUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the latest version.'**
  String get settingsUpToDate;

  /// No description provided for @settingsUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available: {version}'**
  String settingsUpdateAvailable(String version);

  /// No description provided for @settingsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check for updates. Check your connection.'**
  String get settingsUpdateError;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About RubikGo'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutCreationDate.
  ///
  /// In en, this message translates to:
  /// **'App created on 08/05/2026'**
  String get aboutCreationDate;

  /// No description provided for @aboutSignature.
  ///
  /// In en, this message translates to:
  /// **'Build digital signature'**
  String get aboutSignature;

  /// No description provided for @aboutSignatureExplain.
  ///
  /// In en, this message translates to:
  /// **'Unique cryptographic fingerprint of this build (version + author + creation date). Cannot be edited or removed from within the app.'**
  String get aboutSignatureExplain;

  /// No description provided for @aboutFooter.
  ///
  /// In en, this message translates to:
  /// **'© Created by Pedro Espinal — All rights reserved 2026'**
  String get aboutFooter;

  /// No description provided for @aboutSourceLink.
  ///
  /// In en, this message translates to:
  /// **'View source on GitHub'**
  String get aboutSourceLink;

  /// No description provided for @updateBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'New version available: {version}'**
  String updateBannerTitle(String version);

  /// No description provided for @updateBannerAction.
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get updateBannerAction;

  /// No description provided for @updateBannerDismiss.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get updateBannerDismiss;

  /// No description provided for @guideTitle.
  ///
  /// In en, this message translates to:
  /// **'User guide'**
  String get guideTitle;

  /// No description provided for @guideIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'What is RubikGo?'**
  String get guideIntroTitle;

  /// No description provided for @guideIntroBody.
  ///
  /// In en, this message translates to:
  /// **'RubikGo reads the state of your 3x3 Rubik\'s Cube (by photo or by manually choosing colors) and computes the solution with the smallest possible number of moves, using Kociemba\'s two-phase algorithm — the same kind of algorithm used by the world\'s fastest solvers.'**
  String get guideIntroBody;

  /// No description provided for @guideScanTitle.
  ///
  /// In en, this message translates to:
  /// **'How to scan your cube with the camera'**
  String get guideScanTitle;

  /// No description provided for @guideScanBody.
  ///
  /// In en, this message translates to:
  /// **'1. Tap \"Scan with camera\" on the home screen.\n2. Hold the cube in good light and align each face inside the guide grid.\n3. Take one photo per face, following the order shown.\n4. Review the detected colors on the correction screen and fix any misidentified sticker before continuing.'**
  String get guideScanBody;

  /// No description provided for @guideManualTitle.
  ///
  /// In en, this message translates to:
  /// **'How to choose colors manually'**
  String get guideManualTitle;

  /// No description provided for @guideManualBody.
  ///
  /// In en, this message translates to:
  /// **'1. Tap \"Choose colors manually\".\n2. Select a color from the palette at the bottom.\n3. Tap each sticker on all 6 faces to paint it with that color, using your physical cube as reference.\n4. Once all 6 faces are complete, tap \"Solve\".'**
  String get guideManualBody;

  /// No description provided for @guideStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to read the solution steps'**
  String get guideStepsTitle;

  /// No description provided for @guideStepsBody.
  ///
  /// In en, this message translates to:
  /// **'Each step shows a move in standard Rubik\'s Cube notation. Use the \"Previous\"/\"Next\" buttons to move at your own pace, and the cube drawing updates to show what it should look like after each move.'**
  String get guideStepsBody;

  /// No description provided for @guideNotationTitle.
  ///
  /// In en, this message translates to:
  /// **'Move notation'**
  String get guideNotationTitle;

  /// No description provided for @guideNotationBody.
  ///
  /// In en, this message translates to:
  /// **'U = Up, D = Down, F = Front, B = Back, L = Left, R = Right. A single letter turns that face 90° clockwise. An apostrophe (\') turns it counter-clockwise. A 2 turns it 180°. Example: R\' means turn the right face 90° counter-clockwise.'**
  String get guideNotationBody;

  /// No description provided for @guideFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get guideFaqTitle;

  /// No description provided for @guideFaqBody.
  ///
  /// In en, this message translates to:
  /// **'Why do I need to photograph all 6 faces? Because computing a solution requires knowing the position of all 54 pieces of the cube, not just one face.\n\nWhat if it says \"invalid state\"? Check that each color appears exactly 9 times and that no sticker is misassigned; rescan or correct it manually.'**
  String get guideFaqBody;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
