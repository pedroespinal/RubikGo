import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/cube_state.dart';
import '../../widgets/cube_color_editor.dart';
import '../solve/solution_steps_screen.dart';

/// Lets the user fix any sticker the camera misidentified before solving.
/// This screen is mandatory in the camera flow (never skipped), because
/// automatic color detection is best-effort and lighting varies a lot.
class ColorCorrectionScreen extends StatelessWidget {
  final CubeState detectedState;

  const ColorCorrectionScreen({super.key, required this.detectedState});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.correctionTitle)),
      body: CubeColorEditor(
        initialState: detectedState,
        instructions: l10n.correctionInstructions,
        submitLabel: l10n.correctionContinue,
        onSubmit: (validState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SolutionStepsScreen(scannedState: validState),
            ),
          );
        },
      ),
    );
  }
}
