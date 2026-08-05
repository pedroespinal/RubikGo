import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cube_color.dart';
import '../models/cube_state.dart';
import 'cube_net_view.dart';

/// Shared editor used by both the manual color picker and the
/// photo-correction screen: a tappable 6-face net plus a color palette.
///
/// The caller owns what happens once the cube state is valid (usually:
/// send it to the solver), via [onSubmit].
class CubeColorEditor extends StatefulWidget {
  final CubeState initialState;
  final String instructions;
  final String submitLabel;
  final bool showAccessibilityLetters;
  final void Function(CubeState validState) onSubmit;

  const CubeColorEditor({
    super.key,
    required this.initialState,
    required this.instructions,
    required this.submitLabel,
    required this.onSubmit,
    this.showAccessibilityLetters = false,
  });

  @override
  State<CubeColorEditor> createState() => _CubeColorEditorState();
}

class _CubeColorEditorState extends State<CubeColorEditor> {
  late CubeState _state;
  CubeColor _selectedColor = CubeColor.white;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState.copy();
  }

  void _paint(CubeFace face, int index) {
    setState(() => _state.setSticker(face, index, _selectedColor));
  }

  void _reset() {
    setState(() => _state = CubeState.empty());
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final error = _state.validate();
    if (error == null) {
      widget.onSubmit(_state);
      return;
    }

    final message = switch (error) {
      CubeValidationError.incomplete => l10n.validationIncomplete,
      CubeValidationError.wrongColorCounts => l10n.validationColorCount(
          _state.colorsWithWrongCount().map((c) => c.label(l10n)).join(', '),
        ),
      CubeValidationError.duplicateCenters => l10n.validationDuplicateCenters,
      CubeValidationError.twistedPiece => l10n.validationTwistedPiece,
      CubeValidationError.probableSwap => l10n.validationProbableSwap,
    };

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.validationTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.validationOk),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final counts = _state.colorCounts();

    return SafeArea(
      child: Column(
        children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(widget.instructions, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: CubeNetView(
                colorAt: (face, index) => _state.stickerAt(face, index),
                onTapSticker: _paint,
                showAccessibilityLetters: widget.showAccessibilityLetters,
              ),
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            for (final color in CubeColor.values)
              _ColorCountChip(color: color, count: counts[color]!, label: color.label(l10n)),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (final color in CubeColor.values)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.swatch,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedColor == color
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black26,
                          width: _selectedColor == color ? 3 : 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child: Text(l10n.manualPickerReset),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(widget.submitLabel),
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}

class _ColorCountChip extends StatelessWidget {
  final CubeColor color;
  final int count;
  final String label;

  const _ColorCountChip({required this.color, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    final ok = count == 9;
    return Chip(
      avatar: CircleAvatar(backgroundColor: color.swatch, radius: 8),
      label: Text('$label $count/9'),
      backgroundColor: ok
          ? Colors.green.withValues(alpha: 0.15)
          : Theme.of(context).colorScheme.surface,
      side: BorderSide(color: ok ? Colors.green : Colors.grey.withValues(alpha: 0.4)),
    );
  }
}
