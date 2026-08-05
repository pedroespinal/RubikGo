import 'package:flutter/material.dart';

import 'app_colors.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkPrimary,
    onPrimary: Colors.black,
    secondary: AppColors.darkAccent,
    onSecondary: Colors.black,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    error: AppColors.darkAccent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.darkTextPrimary,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
    bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
    bodySmall: TextStyle(color: AppColors.darkTextSecondary),
    titleLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
  ),
  cardTheme: const CardThemeData(
    color: AppColors.darkSurface,
    surfaceTintColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
