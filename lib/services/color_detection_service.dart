import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../models/cube_color.dart';

/// Fraction of the shortest side used for the on-screen alignment square in
/// the camera capture screen. [ColorDetectionService.detectFace] crops to
/// this exact same fraction before sampling, so whatever the user sees
/// inside the guide box on screen is exactly what gets analyzed — the two
/// must always use this one shared constant, never separate numbers.
const double kCubeGuideSquareFraction = 0.72;

/// Best-effort classification of the 9 stickers of one cube face photo into
/// the 6 standard cube colors.
///
/// Classification is hue-based (HSV), not a raw RGB distance to fixed
/// reference colors: real photos vary a lot in brightness (shadows, camera
/// auto-exposure, warm/cool white balance), and brightness swings are
/// exactly what make RGB-distance matching misfire — a shadowed red sticker
/// can end up numerically closer to a "green" reference than to "red" once
/// everything gets darker. Hue stays comparatively stable under those
/// changes, which is why real-world cube scanners classify this way.
/// Lighting is still never perfectly controlled, so the app always routes
/// the result through a mandatory manual correction screen.
class ColorDetectionService {
  const ColorDetectionService();

  /// Returns the 9 detected colors (row-major, matching [CubeState]'s
  /// sticker order) for a photo of a single face aligned to the on-screen
  /// guide square. Only the center [kCubeGuideSquareFraction] of the photo
  /// is analyzed — the same fraction the guide box shows on screen — so
  /// background outside the cube never gets sampled as if it were a sticker.
  List<CubeColor> detectFace(Uint8List imageBytes, {double guideSquareFraction = kCubeGuideSquareFraction}) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw const FormatException('Could not decode the captured photo.');
    }

    final cropped = _cropToCenterSquare(decoded, guideSquareFraction);

    return [
      for (var row = 0; row < 3; row++)
        for (var col = 0; col < 3; col++) _classify(_averageCellColor(cropped, row, col)),
    ];
  }

  img.Image _cropToCenterSquare(img.Image image, double fraction) {
    final side = (min(image.width, image.height) * fraction).round();
    final x = ((image.width - side) / 2).round();
    final y = ((image.height - side) / 2).round();
    return img.copyCrop(image, x: x, y: y, width: side, height: side);
  }

  ({int r, int g, int b}) _averageCellColor(img.Image image, int row, int col) {
    final cellW = image.width / 3;
    final cellH = image.height / 3;
    final cx = ((col + 0.5) * cellW).round();
    final cy = ((row + 0.5) * cellH).round();
    final patch = (min(cellW, cellH) * 0.15).round().clamp(3, 80);

    var rSum = 0, gSum = 0, bSum = 0, n = 0;
    for (var y = cy - patch; y <= cy + patch; y++) {
      if (y < 0 || y >= image.height) continue;
      for (var x = cx - patch; x <= cx + patch; x++) {
        if (x < 0 || x >= image.width) continue;
        final pixel = image.getPixel(x, y);
        rSum += pixel.r.toInt();
        gSum += pixel.g.toInt();
        bSum += pixel.b.toInt();
        n++;
      }
    }
    if (n == 0) return (r: 0, g: 0, b: 0);
    return (r: rSum ~/ n, g: gSum ~/ n, b: bSum ~/ n);
  }

  CubeColor _classify(({int r, int g, int b}) sample) {
    final hsv = _rgbToHsv(sample.r, sample.g, sample.b);

    // Low saturation means "not really a color" — white, regardless of hue,
    // as long as it isn't too dark to be a lit sticker.
    if (hsv.s < 0.28 && hsv.v > 0.5) {
      return CubeColor.white;
    }

    final h = hsv.h;
    if (h >= 335 || h < 14) return CubeColor.red;
    if (h < 40) return CubeColor.orange;
    if (h < 70) return CubeColor.yellow;
    if (h < 170) return CubeColor.green;
    return CubeColor.blue;
  }

  /// Converts 8-bit RGB to HSV, with hue in degrees [0, 360), and
  /// saturation/value in [0, 1].
  ({double h, double s, double v}) _rgbToHsv(int r, int g, int b) {
    final rf = r / 255.0, gf = g / 255.0, bf = b / 255.0;
    final maxc = max(rf, max(gf, bf));
    final minc = min(rf, min(gf, bf));
    final delta = maxc - minc;

    final v = maxc;
    final s = maxc == 0 ? 0.0 : delta / maxc;

    double h;
    if (delta == 0) {
      h = 0;
    } else if (maxc == rf) {
      h = 60 * (((gf - bf) / delta) % 6);
    } else if (maxc == gf) {
      h = 60 * (((bf - rf) / delta) + 2);
    } else {
      h = 60 * (((rf - gf) / delta) + 4);
    }
    if (h < 0) h += 360;

    return (h: h, s: s, v: v);
  }
}
