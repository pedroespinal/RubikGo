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
}
