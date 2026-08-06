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

/// An averaged RGB color sampled from one sticker cell.
typedef RgbSample = ({int r, int g, int b});

/// A running per-cube-per-session calibration: for each cube color, the
/// actual samples (raw RGB, before classification) the user has confirmed
/// so far. Built up face by face — see [CameraCaptureScreen] — and reused
/// as ground truth for classifying the remaining faces, since it reflects
/// this exact cube's sticker material and the room's exact lighting far
/// better than any fixed generic reference could.
typedef ColorCalibration = Map<CubeColor, List<RgbSample>>;

/// Best-effort classification of the 9 stickers of one cube face photo into
/// the 6 standard cube colors.
///
/// Without calibration data, classification is hue-based (HSV): real photos
/// vary a lot in brightness (shadows, camera auto-exposure, warm/cool white
/// balance), and brightness swings are exactly what make RGB-distance
/// matching against a fixed reference misfire — a shadowed red sticker can
/// end up numerically closer to a "green" reference than to "red" once
/// everything gets darker. Hue stays comparatively stable under those
/// changes. But a fixed reference still can't know this particular cube's
/// actual sticker shades (manufacturers vary a lot, especially orange/red
/// and white/yellow), so as soon as [ColorCalibration] samples are
/// available they take priority — nearest-neighbor against colors actually
/// seen on this cube beats any generic guess. Lighting and calibration are
/// still never perfect, so the app always routes the result through a
/// mandatory manual correction step.
class ColorDetectionService {
  const ColorDetectionService();

  /// Raw average color per cell (row-major, matching [CubeState]'s sticker
  /// order), cropped to the on-screen guide square — no classification yet.
  List<RgbSample> sampleFace(Uint8List imageBytes, {double guideSquareFraction = kCubeGuideSquareFraction}) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw const FormatException('Could not decode the captured photo.');
    }

    final cropped = _cropToCenterSquare(decoded, guideSquareFraction);

    return [
      for (var row = 0; row < 3; row++)
        for (var col = 0; col < 3; col++) _averageCellColor(cropped, row, col),
    ];
  }

  /// Samples and classifies in one step. Equivalent to
  /// `sampleFace(...).map((s) => classifySample(s, calibration: calibration))`.
  List<CubeColor> detectFace(
    Uint8List imageBytes, {
    double guideSquareFraction = kCubeGuideSquareFraction,
    ColorCalibration? calibration,
  }) {
    return sampleFace(imageBytes, guideSquareFraction: guideSquareFraction)
        .map((sample) => classifySample(sample, calibration: calibration))
        .toList();
  }

  /// Classifies one sampled color, preferring nearest-neighbor against
  /// [calibration] (this specific cube's confirmed colors so far) and
  /// falling back to the generic hue-based guess for any color that
  /// calibration has no samples for yet.
  CubeColor classifySample(RgbSample sample, {ColorCalibration? calibration}) {
    if (calibration != null && calibration.isNotEmpty) {
      CubeColor? best;
      var bestDistance = double.infinity;
      for (final entry in calibration.entries) {
        for (final reference in entry.value) {
          final distance = _redmeanDistance(sample, reference);
          if (distance < bestDistance) {
            bestDistance = distance;
            best = entry.key;
          }
        }
      }
      // Calibration rarely covers all 6 colors from a single face (a
      // scrambled face might only show 3-4 different colors), so a sample
      // of a color with zero calibration data would otherwise get matched
      // to whichever calibrated color happens to be "least wrong" even if
      // it's nothing alike — only trust the match if it's actually close.
      if (best != null && bestDistance <= _maxCalibrationDistance) return best;
    }
    return _classifyByHue(sample);
  }

  static const _maxCalibrationDistance = 60.0;

  img.Image _cropToCenterSquare(img.Image image, double fraction) {
    final side = (min(image.width, image.height) * fraction).round();
    final x = ((image.width - side) / 2).round();
    final y = ((image.height - side) / 2).round();
    return img.copyCrop(image, x: x, y: y, width: side, height: side);
  }

  RgbSample _averageCellColor(img.Image image, int row, int col) {
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

  CubeColor _classifyByHue(RgbSample sample) {
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

  /// "Redmean" weighted RGB distance — used only for calibrated
  /// nearest-neighbor matching, where both colors come from photos taken
  /// moments apart under the same lighting, so a simple weighted distance
  /// is reliable (unlike comparing against a fixed generic reference).
  double _redmeanDistance(RgbSample a, RgbSample b) {
    final rMean = (a.r + b.r) / 2.0;
    final dr = (a.r - b.r).toDouble();
    final dg = (a.g - b.g).toDouble();
    final db = (a.b - b.b).toDouble();
    final weightR = 2 + rMean / 256;
    final weightG = 4.0;
    final weightB = 2 + (255 - rMean) / 256;
    return sqrt(weightR * dr * dr + weightG * dg * dg + weightB * db * db);
  }
}
