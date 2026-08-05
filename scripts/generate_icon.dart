// Procedurally draws the RubikGo app icon: a stylized isometric Rubik's
// Cube (3 visible faces, each subdivided 3x3) so the app doesn't depend on
// any external image-editing tool.
//
// Usage: dart run scripts/generate_icon.dart
// Produces:
//   assets/icon/app_icon.png             (flat icon, solid background)
//   assets/icon/app_icon_foreground.png  (transparent background, for the
//                                         Android adaptive icon foreground)
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const _backgroundColorArgb = 0xFF2B4C7E; // AppColors.lightPrimary
const _outlineColorArgb = 0xFF14202E;

img.ColorRgba8 _fromArgb(int argb) {
  return img.ColorRgba8(
    (argb >> 16) & 0xFF,
    (argb >> 8) & 0xFF,
    argb & 0xFF,
    (argb >> 24) & 0xFF,
  );
}

img.Point _add(img.Point a, img.Point b) => a + b;
img.Point _scale(img.Point a, double s) => a * s;

/// Point that is `t` of the way from [from] towards [to].
img.Point _lerp(img.Point from, img.Point to, double t) {
  final delta = _add(to, _scale(from, -1.0));
  return _add(from, _scale(delta, t));
}

void _drawCube(img.Image image, {required double cx, required double cy, required double s}) {
  final p0 = img.Point(cx, cy + s * 0.55);
  final eUp = img.Point(0, -s);
  final eLeft = img.Point(-s * 0.866, -s * 0.5);
  final eRight = img.Point(s * 0.866, -s * 0.5);

  final outline = _fromArgb(_outlineColorArgb);
  final stickerInset = 0.06;
  final gridThickness = math.max(2.0, s * 0.012);

  final faces = <(img.Point origin, img.Point u, img.Point v, img.ColorRgba8 color)>[
    (p0, _scale(eUp, 1 / 3), _scale(eLeft, 1 / 3), _fromArgb(0xFFC41E3A)), // left face: red
    (p0, _scale(eUp, 1 / 3), _scale(eRight, 1 / 3), _fromArgb(0xFF0051BA)), // right face: blue
    (_add(p0, eUp), _scale(eLeft, 1 / 3), _scale(eRight, 1 / 3), _fromArgb(0xFFFFFFFF)), // top face: white
  ];

  for (final (origin, u, v, color) in faces) {
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        final a = _add(origin, _add(_scale(u, i.toDouble()), _scale(v, j.toDouble())));
        final b = _add(origin, _add(_scale(u, (i + 1).toDouble()), _scale(v, j.toDouble())));
        final c = _add(origin, _add(_scale(u, (i + 1).toDouble()), _scale(v, (j + 1).toDouble())));
        final d = _add(origin, _add(_scale(u, i.toDouble()), _scale(v, (j + 1).toDouble())));

        final center = _scale(_add(_add(a, b), _add(c, d)), 0.25);
        final vertices = [
          _lerp(a, center, stickerInset),
          _lerp(b, center, stickerInset),
          _lerp(c, center, stickerInset),
          _lerp(d, center, stickerInset),
        ];

        img.fillPolygon(image, vertices: vertices, color: color);
        img.drawPolygon(image, vertices: vertices, color: outline, thickness: gridThickness);
      }
    }
  }

  // Bold outer silhouette of the whole cube.
  final top = _add(p0, eUp);
  img.drawPolygon(
    image,
    vertices: [_add(p0, eLeft), _add(top, eLeft), top, _add(top, eRight), _add(p0, eRight), p0],
    color: outline,
    thickness: math.max(4.0, s * 0.02),
  );
}

img.Image _renderIcon({required bool withBackground}) {
  const size = 1024;
  final image = img.Image(width: size, height: size, numChannels: 4);
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));

  if (withBackground) {
    final bg = _fromArgb(_backgroundColorArgb);
    img.fillRect(
      image,
      x1: 0,
      y1: 0,
      x2: size - 1,
      y2: size - 1,
      color: bg,
      radius: size * 0.22,
    );
  }

  _drawCube(image, cx: size / 2, cy: size / 2, s: size * (withBackground ? 0.30 : 0.34));
  return image;
}

void main() {
  final iconDir = Directory('assets/icon');
  if (!iconDir.existsSync()) {
    iconDir.createSync(recursive: true);
  }

  final flat = _renderIcon(withBackground: true);
  File('assets/icon/app_icon.png').writeAsBytesSync(img.encodePng(flat));

  final foreground = _renderIcon(withBackground: false);
  File('assets/icon/app_icon_foreground.png').writeAsBytesSync(img.encodePng(foreground));

  stdout.writeln('Wrote assets/icon/app_icon.png and assets/icon/app_icon_foreground.png');
}
