import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';

/// The 6 physical sticker colors of a standard Rubik's Cube.
enum CubeColor { white, yellow, red, orange, blue, green }

extension CubeColorX on CubeColor {
  Color get swatch {
    switch (this) {
      case CubeColor.white:
        return AppColors.stickerWhite;
      case CubeColor.yellow:
        return AppColors.stickerYellow;
      case CubeColor.red:
        return AppColors.stickerRed;
      case CubeColor.orange:
        return AppColors.stickerOrange;
      case CubeColor.blue:
        return AppColors.stickerBlue;
      case CubeColor.green:
        return AppColors.stickerGreen;
    }
  }

  /// Single-letter tag shown in colorblind-accessible mode.
  String get accessibilityLetter {
    switch (this) {
      case CubeColor.white:
        return 'W';
      case CubeColor.yellow:
        return 'Y';
      case CubeColor.red:
        return 'R';
      case CubeColor.orange:
        return 'O';
      case CubeColor.blue:
        return 'B';
      case CubeColor.green:
        return 'G';
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case CubeColor.white:
        return l10n.colorWhite;
      case CubeColor.yellow:
        return l10n.colorYellow;
      case CubeColor.red:
        return l10n.colorRed;
      case CubeColor.orange:
        return l10n.colorOrange;
      case CubeColor.blue:
        return l10n.colorBlue;
      case CubeColor.green:
        return l10n.colorGreen;
    }
  }

  /// Whether black or white text reads better on top of this sticker.
  Color get contrastingTextColor {
    switch (this) {
      case CubeColor.white:
      case CubeColor.yellow:
        return Colors.black;
      case CubeColor.red:
      case CubeColor.orange:
      case CubeColor.blue:
      case CubeColor.green:
        return Colors.white;
    }
  }
}
