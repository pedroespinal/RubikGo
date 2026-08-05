import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Fixed copyright footer. This text is a hardcoded constant (via
/// [AppLocalizations.aboutFooter]) with no corresponding setting anywhere
/// in the app — there is no way to edit or hide it from the UI.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        l10n.aboutFooter,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
