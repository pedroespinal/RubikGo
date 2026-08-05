import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:rubik_go/models/cube_color.dart';
import 'package:rubik_go/services/color_detection_service.dart';

Uint8List _solidPng(int r, int g, int b) {
  final image = img.Image(width: 60, height: 60);
  img.fill(image, color: img.ColorRgb8(r, g, b));
  return Uint8List.fromList(img.encodePng(image));
}

void main() {
  const service = ColorDetectionService();

  const cases = {
    CubeColor.white: (255, 255, 255),
    CubeColor.yellow: (255, 213, 0),
    CubeColor.red: (196, 30, 58),
    CubeColor.orange: (255, 127, 0),
    CubeColor.blue: (0, 81, 186),
    CubeColor.green: (0, 158, 96),
  };

  for (final entry in cases.entries) {
    test('a solid ${entry.key.name} photo is classified as ${entry.key.name}', () {
      final (r, g, b) = entry.value;
      final bytes = _solidPng(r, g, b);
      final result = service.detectFace(bytes);
      expect(result, hasLength(9));
      expect(result.every((c) => c == entry.key), isTrue);
    });
  }

  test('a slightly off-white photo (uneven lighting) still reads as white', () {
    final bytes = _solidPng(238, 240, 235);
    final result = service.detectFace(bytes);
    expect(result.every((c) => c == CubeColor.white), isTrue);
  });

  group('robust under real-world lighting (shadows, warm/cool white balance)', () {
    // Hue-based classification is what makes these pass: the same color
    // photographed in a shadow gets uniformly darker (lower value) but
    // keeps roughly the same hue, whereas a plain RGB-distance classifier
    // (the previous implementation) systematically misread darkened
    // stickers as an entirely different color.
    for (final entry in cases.entries) {
      if (entry.key == CubeColor.white) continue;
      test('a shadowed (60% brightness) ${entry.key.name} sticker is still ${entry.key.name}', () {
        final (r, g, b) = entry.value;
        final bytes = _solidPng((r * 0.6).round(), (g * 0.6).round(), (b * 0.6).round());
        final result = service.detectFace(bytes);
        expect(result.every((c) => c == entry.key), isTrue);
      });
    }

    test('a warm-white-balance white sticker (255, 235, 200) still reads as white', () {
      final bytes = _solidPng(255, 235, 200);
      final result = service.detectFace(bytes);
      expect(result.every((c) => c == CubeColor.white), isTrue);
    });

    test('a cool-white-balance white sticker (225, 235, 255) still reads as white', () {
      final bytes = _solidPng(225, 235, 255);
      final result = service.detectFace(bytes);
      expect(result.every((c) => c == CubeColor.white), isTrue);
    });
  });
}
