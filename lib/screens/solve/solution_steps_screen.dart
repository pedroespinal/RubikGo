import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/cube_color.dart';
import '../../models/cube_state.dart';
import '../../services/solver_service.dart';
import '../../widgets/cube_net_view.dart';

/// Shows the move-by-move solution for a scanned cube, using the same
/// physical colors the user scanned/painted (not a generic color scheme),
/// so the on-screen diagram always matches their real cube.
class SolutionStepsScreen extends StatefulWidget {
  final CubeState scannedState;

  const SolutionStepsScreen({super.key, required this.scannedState});

  @override
  State<SolutionStepsScreen> createState() => _SolutionStepsScreenState();
}

class _SolutionStepsScreenState extends State<SolutionStepsScreen> {
  static const _solver = SolverService();

  late final Map<cuber.Color, CubeColor> _letterToPhysical;
  late final cuber.Cube _startCube;

  Future<SolveResult?>? _future;
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _letterToPhysical = {
      for (final face in CubeFace.values) face.cuberColor: widget.scannedState.centerOf(face)!,
    };
    _startCube = widget.scannedState.toCube()!;
    _future = _solver.solve(_startCube);
  }

  CubeColor? _colorAt(cuber.Cube cube, CubeFace face, int index) {
    final letter = cube.colors[face.index * 9 + index];
    return _letterToPhysical[letter];
  }

  /// Faces are identified by their center color (what the user can
  /// actually see on their physical cube), never by the abstract
  /// up/down/left/right/front/back names — those don't correspond to any
  /// required orientation in this app.
  String _moveDescription(cuber.Move move, AppLocalizations l10n) {
    final colorName = _letterToPhysical[move.color]!.label(l10n);
    if (move.double) return l10n.solutionTurnDouble(colorName);
    return move.inverted
        ? l10n.solutionTurnCounterClockwise(colorName)
        : l10n.solutionTurnClockwise(colorName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.solutionTitle)),
      body: SafeArea(
        child: FutureBuilder<SolveResult?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = snapshot.data;
          if (result == null) {
            return Center(child: Text(l10n.validationUnsolvable));
          }

          if (result.moveCount == 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.solutionAlreadySolved,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            );
          }

          final total = result.moveCount;
          final displayCube = result.stateAfter(_step);
          final solved = _step == total;
          final nextMove = solved ? null : result.moves[_step];
          final highlightFace = nextMove == null ? null : CubeFace.values[nextMove.color.index];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      l10n.solutionStepOf(_step, total),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(l10n.solutionMoveCount(total)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: CubeNetView(
                    colorAt: (face, index) => _colorAt(displayCube, face, index),
                    highlightFace: highlightFace,
                  ),
                ),
              ),
              if (solved)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    l10n.solutionSolved,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: _MoveBadge(
                    move: nextMove.toString(),
                    description: _moveDescription(nextMove!, l10n),
                    color: _letterToPhysical[nextMove.color]!,
                    inverted: nextMove.inverted,
                    double: nextMove.double,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _step > 0 ? () => setState(() => _step--) : null,
                        icon: const Icon(Icons.chevron_left),
                        label: Text(l10n.solutionPrevious),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _step < total ? () => setState(() => _step++) : null,
                        icon: const Icon(Icons.chevron_right),
                        label: Text(l10n.solutionNext),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        ),
      ),
    );
  }
}

class _MoveBadge extends StatelessWidget {
  final String move;
  final String description;
  final CubeColor color;
  final bool inverted;
  final bool double;

  const _MoveBadge({
    required this.move,
    required this.description,
    required this.color,
    required this.inverted,
    required this.double,
  });

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final rotationIcon = double
        ? Icons.sync_alt
        : (inverted ? Icons.rotate_left : Icons.rotate_right);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: color.swatch,
                  border: Border.all(color: onPrimary, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Icon(rotationIcon, color: onPrimary, size: 28),
              const SizedBox(width: 8),
              Text(
                move,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: onPrimary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: onPrimary),
          ),
        ],
      ),
    );
  }
}
