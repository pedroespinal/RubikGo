import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/cube_color.dart';
import '../models/cube_state.dart';

/// Read-only or editable unfolded ("cross") net view of a 3x3 cube:
/// ```
///        [ U ]
/// [ L ] [ F ] [ R ] [ B ]
///        [ D ]
/// ```
/// Used by the manual picker, the photo-correction screen and the solution
/// step viewer, so all three look and behave consistently.
class CubeNetView extends StatelessWidget {
  final CubeColor? Function(CubeFace face, int index) colorAt;
  final void Function(CubeFace face, int index)? onTapSticker;
  final bool showAccessibilityLetters;
  final double maxStickerSize;

  const CubeNetView({
    super.key,
    required this.colorAt,
    this.onTapSticker,
    this.showAccessibilityLetters = false,
    this.maxStickerSize = 34,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Each sticker draws a 1px margin on every side (see _FaceGrid), so
        // its actual footprint is `size + 2`, not just `size` — leaving that
        // out here made the 12-sticker-wide net overflow past the screen
        // edge on phones.
        const marginPerSticker = 2.0;
        final size = constraints.maxWidth.isFinite
            ? ((constraints.maxWidth / 12) - marginPerSticker).clamp(10.0, maxStickerSize)
            : maxStickerSize;
        final faceFootprint = (size + marginPerSticker) * 3;

        Widget faceGrid(CubeFace face) => _FaceGrid(
              face: face,
              size: size,
              colorAt: colorAt,
              onTap: onTapSticker,
              showLetters: showAccessibilityLetters,
            );
        Widget blank() => SizedBox(width: faceFootprint, height: faceFootprint);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [blank(), faceGrid(CubeFace.up), blank(), blank()],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                faceGrid(CubeFace.left),
                faceGrid(CubeFace.front),
                faceGrid(CubeFace.right),
                faceGrid(CubeFace.back),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [blank(), faceGrid(CubeFace.down), blank(), blank()],
            ),
          ],
        );
      },
    );
  }
}

class _FaceGrid extends StatelessWidget {
  final CubeFace face;
  final double size;
  final CubeColor? Function(CubeFace, int) colorAt;
  final void Function(CubeFace, int)? onTap;
  final bool showLetters;

  const _FaceGrid({
    required this.face,
    required this.size,
    required this.colorAt,
    required this.onTap,
    required this.showLetters,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.stickerBorderDark
        : AppColors.stickerBorderLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (col) {
            final index = row * 3 + col;
            final color = colorAt(face, index);
            return GestureDetector(
              onTap: onTap == null ? null : () => onTap!(face, index),
              child: Container(
                width: size,
                height: size,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: color?.swatch ?? const Color(0xFF9E9E9E),
                  border: Border.all(color: borderColor, width: 1),
                  borderRadius: BorderRadius.circular(3),
                ),
                alignment: Alignment.center,
                child: showLetters && color != null
                    ? Text(
                        color.accessibilityLetter,
                        style: TextStyle(
                          fontSize: size * 0.42,
                          fontWeight: FontWeight.bold,
                          color: color.contrastingTextColor,
                        ),
                      )
                    : null,
              ),
            );
          }),
        );
      }),
    );
  }
}
