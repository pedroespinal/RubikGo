import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../l10n/app_localizations.dart';
import '../services/update_check_service.dart';
import '../widgets/app_footer.dart';
import '../widgets/update_banner.dart';
import 'about_screen.dart';
import 'guide_screen.dart';
import 'practice/scramble_timer_screen.dart';
import 'scan/camera_capture_screen.dart';
import 'scan/manual_color_picker_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UpdateCheckResult? _updateResult;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdateSilently();
  }

  Future<void> _checkForUpdateSilently() async {
    final info = await PackageInfo.fromPlatform();
    final result = await UpdateCheckService().check(info.version);
    if (mounted && result != null && result.hasUpdate) {
      setState(() => _updateResult = result);
    }
  }

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (_updateResult != null && !_dismissed)
              UpdateBanner(
                result: _updateResult!,
                onDismiss: () => setState(() => _dismissed = true),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Icon(Icons.view_in_ar, size: 72, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    l10n.homeTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  _HomeButton(
                    icon: Icons.camera_alt,
                    label: l10n.homeScanPhoto,
                    onTap: () => _push(const CameraCaptureScreen()),
                  ),
                  _HomeButton(
                    icon: Icons.palette,
                    label: l10n.homeScanManual,
                    onTap: () => _push(const ManualColorPickerScreen()),
                  ),
                  _HomeButton(
                    icon: Icons.timer,
                    label: l10n.homePractice,
                    onTap: () => _push(const ScrambleTimerScreen()),
                  ),
                  _HomeButton(
                    icon: Icons.menu_book,
                    label: l10n.homeGuide,
                    onTap: () => _push(const GuideScreen()),
                  ),
                  _HomeButton(
                    icon: Icons.settings,
                    label: l10n.homeSettings,
                    onTap: () => _push(const SettingsScreen()),
                  ),
                  _HomeButton(
                    icon: Icons.info_outline,
                    label: l10n.homeAbout,
                    onTap: () => _push(const AboutScreen()),
                  ),
                ],
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Align(alignment: Alignment.centerLeft, child: Text(label)),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
