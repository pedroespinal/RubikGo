import 'package:flutter/material.dart';

/// Fixed brand palette for RubikGo, tuned for WCAG AA contrast in both
/// light and dark mode. Do not derive these from [Theme.of(context)]
/// defaults — they are hand-picked so sticker colors and text never blend
/// into the background.
class AppColors {
  AppColors._();

  // Light theme.
  static const lightBackground = Color(0xFFFAFAFA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightTextPrimary = Color(0xFF1A1A1A);
  static const lightTextSecondary = Color(0xFF4A4A4A);
  static const lightPrimary = Color(0xFF2B4C7E);
  static const lightAccent = Color(0xFFD32F2F);

  // Dark theme.
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFF2F2F2);
  static const darkTextSecondary = Color(0xFFC7C7C7);
  static const darkPrimary = Color(0xFF7FA6E3);
  static const darkAccent = Color(0xFFEF5350);

  /// Physical cube sticker colors (used in pickers and the cube diagram).
  /// These stay constant across themes; a thin border is always drawn
  /// around each sticker so the white tile never disappears into a light
  /// background.
  static const stickerWhite = Color(0xFFFFFFFF);
  static const stickerYellow = Color(0xFFFFD500);
  static const stickerRed = Color(0xFFC41E3A);
  static const stickerOrange = Color(0xFFFF7F00);
  static const stickerBlue = Color(0xFF0051BA);
  static const stickerGreen = Color(0xFF009E60);

  /// Border drawn around every sticker, regardless of theme.
  static const stickerBorderLight = Color(0xFF1A1A1A);
  static const stickerBorderDark = Color(0xFFE0E0E0);
}
