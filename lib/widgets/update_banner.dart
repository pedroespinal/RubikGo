import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/update_check_service.dart';

/// Shown on the home screen when a newer GitHub release exists. Tapping it
/// opens the release page in the browser — the app never downloads or
/// installs anything on its own.
class UpdateBanner extends StatelessWidget {
  final UpdateCheckResult result;
  final VoidCallback onDismiss;

  const UpdateBanner({super.key, required this.result, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(result.releaseUrl), mode: LaunchMode.externalApplication),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.system_update, color: onPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.updateBannerTitle(result.latestVersion),
                  style: TextStyle(color: onPrimary, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: onDismiss,
                child: Text(l10n.updateBannerDismiss, style: TextStyle(color: onPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
