import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter/foundation.dart';

/// Result of a successful solve: the starting cube and the ordered list of
/// moves (in Kociemba two-phase, near-optimal length) that solve it.
class SolveResult {
  final cuber.Cube start;
  final cuber.Algorithm moves;

  const SolveResult({required this.start, required this.moves});

  int get moveCount => moves.length;

  /// The cube state after applying the first [stepCount] moves.
  cuber.Cube stateAfter(int stepCount) {
    var cube = start;
    for (var i = 0; i < stepCount; i++) {
      cube = cube.move(moves[i]);
    }
    return cube;
  }
}

/// Wraps `package:cuber`'s Kociemba two-phase solver, running the search on
/// a background isolate so the UI never freezes while solving.
class SolverService {
  const SolverService();

  /// Solves [cube]. Returns `null` if no solution was found within the
  /// default search depth/timeout (should not happen for a valid cube).
  Future<SolveResult?> solve(cuber.Cube cube) async {
    if (cube.isSolved) {
      return SolveResult(start: cube, moves: cuber.Algorithm.empty);
    }
    final notation = await compute(_solveInIsolate, cube.definition);
    if (notation == null) return null;
    return SolveResult(start: cube, moves: cuber.Algorithm.parse(notation));
  }
}

/// Runs on a background isolate. Must be a top-level/static function and
/// only exchange primitive data across the isolate boundary.
String? _solveInIsolate(String definition) {
  final cube = cuber.Cube.from(definition);
  final solution = cube.solve();
  if (solution == null) return null;
  return solution.algorithm.map((m) => m.toString()).join(' ');
}
