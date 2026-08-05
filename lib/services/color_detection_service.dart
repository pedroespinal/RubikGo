import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../models/cube_color.dart';

/// Best-effort classification of the 9 stickers of one cube face photo into
/// the 6 standard cube colors.
///
/// Lighting varies a lot between phones and rooms, so this is intentionally
/// simple (average color per cell + nearest reference color) rather than a
/// full calibration pipeline — the app always routes the result through a
/// mandatory manual correction screen, which is what actually makes the
/// scan flow reliable.
class ColorDetectionService {
  const ColorDetectionService();

  static const _referenceColors = {
    CubeColor.white: (r: 255, g: 255, b: 255),
    CubeColor.yellow: (r: 255, g: 213, b: 0),
    CubeColor.red: (r: 196, g: 30, b: 58),
    CubeColor.orange: (r: 255, g: 127, b: 0),
    CubeColor.blue: (r: 0, g: 81, b: 186),
    CubeColor.green: (r: 0, g: 158, b: 96),
  };

  /// Returns the 9 detected colors (row-major, matching [CubeState]'s
  /// sticker order) for a photo of a single face aligned to a 3x3 guide
  /// grid that fills the frame.
  List<CubeColor> detectFace(Uint8List imageBytes) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw const FormatException('Could not decode the captured photo.');
    }

    return [
      for (var row = 0; row < 3; row++)
        for (var col = 0; col < 3; col++) _classify(_averageCellColor(decoded, row, col)),
    ];
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
    var best = CubeColor.white;
    var bestDistance = double.infinity;
    for (final entry in _referenceColors.entries) {
      final distance = _redmeanDistance(sample, entry.value);
      if (distance < bestDistance) {
        bestDistance = distance;
        best = entry.key;
      }
    }
    return best;
  }

  /// "Redmean" weighted RGB distance: a cheap approximation of perceptual
  /// color difference that works noticeably better than plain Euclidean
  /// distance without needing a full Lab color-space conversion.
  double _redmeanDistance(({int r, int g, int b}) a, ({int r, int g, int b}) b) {
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
