import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/signature/app_signature.dart';
import '../l10n/app_localizations.dart';
import '../services/update_check_service.dart';
import '../widgets/app_footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.data?.version ?? '…';

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: 96,
                  height: 96,
                  errorBuilder: (context, error, stack) => Icon(
                    Icons.view_in_ar,
                    size: 96,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text('RubikGo', style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 24),
              Text(l10n.aboutVersion(version), style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(l10n.aboutCreationDate, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Text(l10n.aboutSignature, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              SelectableText(
                AppSignature.buildSignature,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(l10n.aboutSignatureExplain, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse('https://github.com/$kGitHubRepo'),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.code),
                label: Text(l10n.aboutSourceLink),
              ),
              const SizedBox(height: 32),
              const AppFooter(),
            ],
          );
        },
      ),
    );
  }
}
