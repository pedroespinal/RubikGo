import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/cube_color.dart';

/// Lets the user confirm or fix the 9 detected colors of a single freshly
/// photographed face before moving on to the next one. Confirming here
/// (rather than only at the very end, across all 6 faces) is what lets the
/// app build up a per-cube color calibration as it goes — the earlier a
/// mistake gets fixed, the sooner classification improves for the
/// remaining faces.
class SingleFaceColorGrid extends StatefulWidget {
  final List<CubeColor> initialColors;
  final String instructions;
  final String confirmLabel;
  final void Function(List<CubeColor> colors) onConfirm;

  const SingleFaceColorGrid({
    super.key,
    required this.initialColors,
    required this.instructions,
    required this.confirmLabel,
    required this.onConfirm,
  }) : assert(initialColors.length == 9);

  @override
  State<SingleFaceColorGrid> createState() => _SingleFaceColorGridState();
}

class _SingleFaceColorGridState extends State<SingleFaceColorGrid> {
  late List<CubeColor> _colors;
  CubeColor _selected = CubeColor.white;

  @override
  void initState() {
    super.initState();
    _colors = List.of(widget.initialColors);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        Theme.of(context).brightness == Brightness.dark ? AppColors.stickerBorderDark : AppColors.stickerBorderLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(widget.instructions, textAlign: TextAlign.center),
        ),
        const SizedBox(height: 16),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (col) {
                final index = row * 3 + col;
                final color = _colors[index];
                return GestureDetector(
                  onTap: () => setState(() => _colors[index] = _selected),
                  child: Container(
                    width: 52,
                    height: 52,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: color.swatch,
                      border: Border.all(color: borderColor, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (final color in CubeColor.values)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = color),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.swatch,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selected == color ? Theme.of(context).colorScheme.primary : Colors.black26,
                          width: _selected == color ? 3 : 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onConfirm(_colors),
              child: Text(widget.confirmLabel),
            ),
          ),
        ),
      ],
    );
  }
}
