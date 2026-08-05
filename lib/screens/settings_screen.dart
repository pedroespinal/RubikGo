import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../l10n/app_localizations.dart';
import '../services/prefs_service.dart';
import '../services/update_check_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _checking = false;
  String? _statusMessage;

  Future<void> _checkForUpdates() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _checking = true;
      _statusMessage = null;
    });

    final info = await PackageInfo.fromPlatform();
    final result = await UpdateCheckService().check(info.version);
    if (!mounted) return;

    setState(() {
      _checking = false;
      if (result == null) {
        _statusMessage = l10n.settingsUpdateError;
      } else if (result.hasUpdate) {
        _statusMessage = l10n.settingsUpdateAvailable(result.latestVersion);
      } else {
        _statusMessage = l10n.settingsUpToDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListenableBuilder(
        listenable: PrefsService.instance,
        builder: (context, _) {
          final prefs = PrefsService.instance;
          return ListView(
            children: [
              _SectionHeader(l10n.settingsLanguage),
              RadioGroup<Locale>(
                groupValue: prefs.locale,
                onChanged: (value) => prefs.setLocale(value),
                child: Column(
                  children: [
                    RadioListTile<Locale>(
                      value: const Locale('es'),
                      title: Text(l10n.settingsLanguageSpanish),
                    ),
                    RadioListTile<Locale>(
                      value: const Locale('en'),
                      title: Text(l10n.settingsLanguageEnglish),
                    ),
                  ],
                ),
              ),
              const Divider(),
              _SectionHeader(l10n.settingsTheme),
              RadioGroup<ThemeMode>(
                groupValue: prefs.themeMode,
                onChanged: (value) => prefs.setThemeMode(value ?? ThemeMode.system),
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      title: Text(l10n.settingsThemeLight),
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      title: Text(l10n.settingsThemeDark),
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      title: Text(l10n.settingsThemeSystem),
                    ),
                  ],
                ),
              ),
              const Divider(),
              SwitchListTile(
                value: prefs.colorblindMode,
                title: Text(l10n.settingsColorblind),
                onChanged: (value) => prefs.setColorblindMode(value),
              ),
              const Divider(),
              ListTile(
                title: Text(l10n.settingsCheckUpdate),
                subtitle: _checking
                    ? Text(l10n.settingsCheckingUpdate)
                    : (_statusMessage != null ? Text(_statusMessage!) : null),
                trailing: _checking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                onTap: _checking ? null : _checkForUpdates,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
