import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted user preferences: language, theme and colorblind-accessible
/// mode. A single app-wide singleton, loaded once at startup.
class PrefsService extends ChangeNotifier {
  PrefsService._();

  static final PrefsService instance = PrefsService._();

  static const _keyLocale = 'locale';
  static const _keyThemeMode = 'theme_mode';
  static const _keyColorblind = 'colorblind_mode';

  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;
  bool _colorblindMode = false;

  Locale? get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get colorblindMode => _colorblindMode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_keyLocale);
    _locale = localeCode == null ? null : Locale(localeCode);

    final themeName = prefs.getString(_keyThemeMode);
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == themeName,
      orElse: () => ThemeMode.system,
    );

    _colorblindMode = prefs.getBool(_keyColorblind) ?? false;
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_keyLocale);
    } else {
      await prefs.setString(_keyLocale, locale.languageCode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode.name);
  }

  Future<void> setColorblindMode(bool value) async {
    _colorblindMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyColorblind, value);
  }
}
