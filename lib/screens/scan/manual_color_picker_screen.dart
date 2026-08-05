import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/cube_state.dart';
import '../../widgets/cube_color_editor.dart';
import '../solve/solution_steps_screen.dart';

class ManualColorPickerScreen extends StatelessWidget {
  const ManualColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.manualPickerTitle)),
      body: CubeColorEditor(
        initialState: CubeState.empty(),
        instructions: l10n.manualPickerInstructions,
        submitLabel: l10n.manualPickerSolve,
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
