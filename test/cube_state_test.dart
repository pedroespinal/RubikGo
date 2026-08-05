import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter_test/flutter_test.dart';
import 'package:rubik_go/models/cube_color.dart';
import 'package:rubik_go/models/cube_state.dart';

/// A fixed, arbitrary mapping from cuber's abstract face letters to
/// physical sticker colors, used only for building test fixtures.
const _physicalColorOf = {
  cuber.Color.up: CubeColor.white,
  cuber.Color.right: CubeColor.red,
  cuber.Color.front: CubeColor.green,
  cuber.Color.down: CubeColor.yellow,
  cuber.Color.left: CubeColor.orange,
  cuber.Color.bottom: CubeColor.blue,
};

CubeState _stateFromCube(cuber.Cube cube) {
  final state = CubeState.empty();
  final colors = cube.colors;
  for (final face in CubeFace.values) {
    for (var i = 0; i < 9; i++) {
      final letterColor = colors[face.index * 9 + i];
      state.setSticker(face, i, _physicalColorOf[letterColor]!);
    }
  }
  return state;
}

void main() {
  group('CubeState validation', () {
    test('incomplete state is reported as incomplete', () {
      final state = CubeState.empty();
      expect(state.validate(), CubeValidationError.incomplete);
    });

    test('solved cube round-trips through CubeState', () {
      final state = _stateFromCube(cuber.Cube.solved);
      expect(state.validate(), isNull);
      expect(state.toCube()!.isSolved, isTrue);
    });

    test('scrambled cube round-trips through CubeState', () {
      final scrambled = cuber.Cube.scrambled(n: 15);
      final state = _stateFromCube(scrambled);
      expect(state.validate(), isNull);
      expect(state.toCube(), scrambled);
    });

    test('wrong color counts are detected', () {
      final state = _stateFromCube(cuber.Cube.solved);
      // Overwrite one white sticker with red, breaking the 9-per-color rule.
      state.setSticker(CubeFace.up, 0, CubeColor.red);
      expect(state.validate(), CubeValidationError.wrongColorCounts);
    });

    test('duplicate centers are detected', () {
      final state = _stateFromCube(cuber.Cube.solved);
      // Make the front center the same color as the up center.
      state.setSticker(CubeFace.front, 4, CubeColor.white);
      // This also breaks color counts, but duplicate centers must still be
      // detectable on its own.
      expect(state.hasDuplicateCenters, isTrue);
    });

    test('swapped stickers that keep color counts but break the cube are unsolvable', () {
      final state = _stateFromCube(cuber.Cube.solved);
      // Swap two non-center stickers of different colors on adjacent faces
      // without touching centers or overall counts per color pair swap.
      final a = state.stickerAt(CubeFace.up, 0)!;
      final b = state.stickerAt(CubeFace.front, 0)!;
      state.setSticker(CubeFace.up, 0, b);
      state.setSticker(CubeFace.front, 0, a);
      // Either specific diagnosis is acceptable here — what matters is that
      // this is caught as unsolvable at all, not which piece cuber blames.
      expect(
        state.validate(),
        anyOf(CubeValidationError.twistedPiece, CubeValidationError.probableSwap),
      );
    });

    test('a single flipped edge (colors swapped within one piece) is reported as twisted', () {
      final state = _stateFromCube(cuber.Cube.solved);
      // U6/R2 are the two facelets of the same up-right edge piece — swap
      // just those two with each other, which flips that one edge in place
      // without touching any other piece.
      final a = state.stickerAt(CubeFace.up, 5)!;
      final b = state.stickerAt(CubeFace.right, 1)!;
      state.setSticker(CubeFace.up, 5, b);
      state.setSticker(CubeFace.right, 1, a);
      expect(state.validate(), CubeValidationError.twistedPiece);
    });
  });
}
