import 'package:flutter/material.dart';

import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBackground,
  colorScheme: const ColorScheme.light(
    primary: AppColors.lightPrimary,
    onPrimary: Colors.white,
    secondary: AppColors.lightAccent,
    onSecondary: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    error: AppColors.lightAccent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightSurface,
    foregroundColor: AppColors.lightTextPrimary,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
    bodyMedium: TextStyle(color: AppColors.lightTextPrimary),
    bodySmall: TextStyle(color: AppColors.lightTextSecondary),
    titleLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
  ),
  cardTheme: const CardThemeData(
    color: AppColors.lightSurface,
    surfaceTintColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
