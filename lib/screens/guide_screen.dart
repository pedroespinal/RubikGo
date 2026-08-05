import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final sections = [
      (l10n.guideIntroTitle, l10n.guideIntroBody),
      (l10n.guideScanTitle, l10n.guideScanBody),
      (l10n.guideManualTitle, l10n.guideManualBody),
      (l10n.guideStepsTitle, l10n.guideStepsBody),
      (l10n.guideNotationTitle, l10n.guideNotationBody),
      (l10n.guideFaqTitle, l10n.guideFaqBody),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.guideTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: sections.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final (title, body) = sections[index];
          return ExpansionTile(
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            initiallyExpanded: index == 0,
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          );
        },
      ),
    );
  }
}
