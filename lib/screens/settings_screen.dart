import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _checkFailed = false;
  UpdateCheckResult? _result;

  Future<void> _checkForUpdates() async {
    setState(() {
      _checking = true;
      _checkFailed = false;
      _result = null;
    });

    final info = await PackageInfo.fromPlatform();
    final result = await UpdateCheckService().check(info.version);
    if (!mounted) return;

    setState(() {
      _checking = false;
      _checkFailed = result == null;
      _result = result;
    });
  }

  // Tapping the row after finding an update must actually take you to it —
  // it previously just re-ran the same check again, so nothing seemed to
  // happen when you tapped it (the home screen's banner already did this
  // correctly; this screen didn't).
  Future<void> _openLatestRelease() async {
    final releaseUrl = _result?.releaseUrl;
    if (releaseUrl == null) return;
    await launchUrl(Uri.parse(releaseUrl), mode: LaunchMode.externalApplication);
  }

  String? _statusText(AppLocalizations l10n) {
    if (_checking) return l10n.settingsCheckingUpdate;
    if (_checkFailed) return l10n.settingsUpdateError;
    final result = _result;
    if (result == null) return null;
    return result.hasUpdate ? l10n.settingsUpdateAvailable(result.latestVersion) : l10n.settingsUpToDate;
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
          final updateStatusText = _statusText(l10n);
          return SafeArea(
            child: ListView(
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
                subtitle: updateStatusText == null ? null : Text(updateStatusText),
                trailing: _checking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_result?.hasUpdate == true ? Icons.open_in_new : Icons.refresh),
                onTap: _checking
                    ? null
                    : (_result?.hasUpdate == true ? _openLatestRelease : _checkForUpdates),
              ),
            ],
            ),
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
