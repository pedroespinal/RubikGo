import 'package:cuber/cuber.dart' as cuber;

import 'cube_color.dart';

/// The 6 faces of a 3x3 cube, in the same order as `cuber.Color.values`
/// (up, right, front, down, left, back) so `CubeFace.values[i].index` can
/// always be used to index into cuber's own enums.
enum CubeFace { up, right, front, down, left, back }

extension CubeFaceX on CubeFace {
  cuber.Color get cuberColor => cuber.Color.values[index];
}

/// Reasons a [CubeState] cannot be sent to the solver yet.
///
/// The last two both mean "color counts are correct but this specific
/// arrangement can't be a real cube" — kept distinct from one generic
/// "invalid" bucket because they point at different kinds of mistakes,
/// which is the most actionable hint the app can give: it has no way to
/// know exactly *which* sticker is wrong, only what shape of mistake
/// tends to produce this kind of failure.
enum CubeValidationError {
  /// Not all 54 stickers have been assigned a color yet.
  incomplete,

  /// A color does not appear exactly 9 times across the whole cube.
  wrongColorCounts,

  /// Two or more center stickers share the same color.
  duplicateCenters,

  /// A real edge or corner piece, but flipped/rotated in place — typically
  /// means two stickers *of the same piece* (the two or three squares
  /// meeting at one edge/corner) were read in the wrong order.
  twistedPiece,

  /// Every other unsolvable case — typically two stickers were swapped
  /// between two different pieces (most often a misread between two
  /// similar colors, e.g. white/yellow or red/orange).
  probableSwap,
}

/// Mutable in-progress (or completed) color state of a physical cube, as
/// entered by the user (manually or via photo scan + correction).
///
/// Each face holds 9 stickers in row-major order (index 4 is the center,
/// which is fixed and never changes on a real cube).
class CubeState {
  final Map<CubeFace, List<CubeColor?>> _stickers;

  CubeState._(this._stickers);

  factory CubeState.empty() {
    return CubeState._({
      for (final face in CubeFace.values) face: List<CubeColor?>.filled(9, null),
    });
  }

  CubeState copy() {
    return CubeState._({
      for (final entry in _stickers.entries) entry.key: List<CubeColor?>.of(entry.value),
    });
  }

  CubeColor? stickerAt(CubeFace face, int index) => _stickers[face]![index];

  void setSticker(CubeFace face, int index, CubeColor color) {
    _stickers[face]![index] = color;
  }

  List<CubeColor?> faceStickers(CubeFace face) => List.unmodifiable(_stickers[face]!);

  CubeColor? centerOf(CubeFace face) => _stickers[face]![4];

  bool get isComplete => CubeFace.values.every((f) => _stickers[f]!.every((c) => c != null));

  /// Count of each color across all 54 stickers.
  Map<CubeColor, int> colorCounts() {
    final counts = {for (final c in CubeColor.values) c: 0};
    for (final face in CubeFace.values) {
      for (final color in _stickers[face]!) {
        if (color != null) counts[color] = counts[color]! + 1;
      }
    }
    return counts;
  }

  /// Colors whose count is not exactly 9 (only meaningful once [isComplete]).
  List<CubeColor> colorsWithWrongCount() {
    final counts = colorCounts();
    return [
      for (final entry in counts.entries)
        if (entry.value != 9) entry.key,
    ];
  }

  bool get hasDuplicateCenters {
    final centers = CubeFace.values.map(centerOf).whereType<CubeColor>().toSet();
    return centers.length != CubeFace.values.length;
  }

  /// Runs all checks in order and returns the first failure, or `null` if
  /// the state is a valid, solvable cube.
  CubeValidationError? validate() {
    if (!isComplete) return CubeValidationError.incomplete;
    if (colorsWithWrongCount().isNotEmpty) return CubeValidationError.wrongColorCounts;
    if (hasDuplicateCenters) return CubeValidationError.duplicateCenters;

    final status = _rawStatus();
    if (status == null || status == cuber.CubeStatus.ok) return null;

    switch (status) {
      case cuber.CubeStatus.twistedEdge:
      case cuber.CubeStatus.twistedCorner:
        return CubeValidationError.twistedPiece;
      case cuber.CubeStatus.missingEdge:
      case cuber.CubeStatus.missingCorner:
      case cuber.CubeStatus.parityError:
      case cuber.CubeStatus.ok:
        return CubeValidationError.probableSwap;
    }
  }

  /// The raw cuber diagnosis for the current stickers, or `null` if the
  /// definition can't even be parsed (e.g. centers not yet resolvable).
  cuber.CubeStatus? _rawStatus() {
    final definition = _toFaceletDefinition();
    if (definition == null) return null;
    try {
      return cuber.Cube.from(definition).verify();
    } on ArgumentError {
      return null;
    }
  }

  /// Builds the cuber facelet definition string (U9 R9 F9 D9 L9 B9), using
  /// each face's center color as the identity of that face's letter — this
  /// makes conversion independent of how the physical cube happens to be
  /// oriented or color-schemed.
  String? _toFaceletDefinition() {
    final centerToFace = <CubeColor, CubeFace>{};
    for (final face in CubeFace.values) {
      final center = centerOf(face);
      if (center == null) return null;
      centerToFace[center] = face;
    }
    if (centerToFace.length != CubeFace.values.length) return null;

    final buffer = StringBuffer();
    for (final face in CubeFace.values) {
      for (final sticker in _stickers[face]!) {
        if (sticker == null) return null;
        final letterFace = centerToFace[sticker];
        if (letterFace == null) return null;
        buffer.write(letterFace.cuberColor.letter);
      }
    }
    return buffer.toString();
  }

  /// Converts to a `cuber.Cube`, or `null` if the state is incomplete or
  /// does not correspond to any physically valid cube.
  cuber.Cube? toCube() {
    final definition = _toFaceletDefinition();
    if (definition == null) return null;
    try {
      final cube = cuber.Cube.from(definition);
      return cube.isOk ? cube : null;
    } on ArgumentError {
      return null;
    }
  }

  /// A copy of this state with [face]'s 9 stickers rotated in place by
  /// [quarterTurns] * 90° clockwise (as seen looking directly at that
  /// face). The center (index 4) is a fixed point of any rotation, so it's
  /// unaffected either way.
  CubeState withFaceRotated(CubeFace face, int quarterTurns) {
    final next = copy();
    var current = List<CubeColor?>.of(_stickers[face]!);
    for (var turn = 0; turn < (quarterTurns % 4); turn++) {
      current = [
        for (var row = 0; row < 3; row++)
          for (var col = 0; col < 3; col++) current[(2 - col) * 3 + row],
      ];
    }
    next._stickers[face] = current;
    return next;
  }

  /// If the cube is invalid only because exactly one face was photographed
  /// rotated relative to the others — the single most common real-world
  /// mistake, since it's easy to lose track of "which way is up" while
  /// turning the cube between the 6 photos — returns which face and by how
  /// many quarter turns to fix it.
  ///
  /// Only returns a suggestion when exactly one (face, rotation) combination
  /// out of all 18 possible makes the cube valid — if none do, or more than
  /// one coincidentally does (most likely on a cube with a lot of repeated
  /// colors per face), guessing could "fix" it into a cube that doesn't
  /// match the user's real one, so it's safer to say nothing.
  ({CubeFace face, int quarterTurns})? findSingleFaceRotationFix() {
    if (validate() == null) return null;
    if (!isComplete || colorsWithWrongCount().isNotEmpty || hasDuplicateCenters) {
      return null;
    }

    final candidates = <({CubeFace face, int quarterTurns})>[];
    for (final face in CubeFace.values) {
      for (final turns in [1, 2, 3]) {
        if (withFaceRotated(face, turns).validate() == null) {
          candidates.add((face: face, quarterTurns: turns));
        }
      }
    }
    return candidates.length == 1 ? candidates.single : null;
  }
}
