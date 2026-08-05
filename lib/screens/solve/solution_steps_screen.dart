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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.solutionTitle)),
      body: FutureBuilder<SolveResult?>(
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
                  child: _MoveBadge(move: result.moves[_step].toString()),
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
    );
  }
}

class _MoveBadge extends StatelessWidget {
  final String move;

  const _MoveBadge({required this.move});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        move,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
