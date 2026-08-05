import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter_test/flutter_test.dart';
import 'package:rubik_go/services/solver_service.dart';

void main() {
  const service = SolverService();

  test('an already-solved cube needs zero moves', () async {
    final result = await service.solve(cuber.Cube.solved);
    expect(result, isNotNull);
    expect(result!.moveCount, 0);
  });

  test('a scrambled cube is solved and the moves actually solve it', () async {
    final scrambled = cuber.Cube.scrambled(n: 10);
    final result = await service.solve(scrambled);
    expect(result, isNotNull);
    expect(result!.moveCount, greaterThan(0));
    expect(result.stateAfter(result.moveCount).isSolved, isTrue);
  });
}
