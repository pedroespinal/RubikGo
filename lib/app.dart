import 'package:flutter/material.dart';

import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/prefs_service.dart';

class RubikGoApp extends StatelessWidget {
  const RubikGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PrefsService.instance,
      builder: (context, _) {
        final prefs = PrefsService.instance;
        return MaterialApp(
          title: 'RubikGo',
          debugShowCheckedModeBanner: false,
          themeMode: prefs.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          locale: prefs.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const HomeScreen(),
        );
      },
    );
  }
}
