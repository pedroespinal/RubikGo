import 'dart:async';

import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../models/cube_color.dart';
import '../../models/cube_state.dart';
import '../../widgets/cube_net_view.dart';

/// Practice mode: a random scramble to apply to your physical cube plus a
/// speedcubing-style stopwatch. This uses a fixed virtual color scheme
/// (standard White-top/Green-front/Red-right) purely for the on-screen
/// diagram — it isn't tied to any scanned cube.
class ScrambleTimerScreen extends StatefulWidget {
  const ScrambleTimerScreen({super.key});

  @override
  State<ScrambleTimerScreen> createState() => _ScrambleTimerScreenState();
}

class _ScrambleTimerScreenState extends State<ScrambleTimerScreen> {
  static const _prefsKeyBestMs = 'practice_best_time_ms';

  static const _virtualColorMap = {
    cuber.Color.up: CubeColor.white,
    cuber.Color.right: CubeColor.red,
    cuber.Color.front: CubeColor.green,
    cuber.Color.down: CubeColor.yellow,
    cuber.Color.left: CubeColor.orange,
    cuber.Color.bottom: CubeColor.blue,
  };

  late cuber.Algorithm _scramble;
  late cuber.Cube _cube;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  int? _bestMs;
  int? _lastMs;

  @override
  void initState() {
    super.initState();
    _newScramble();
    _loadBest();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _loadBest() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _bestMs = prefs.getInt(_prefsKeyBestMs));
  }

  Future<void> _saveBest(int ms) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKeyBestMs, ms);
  }

  void _newScramble() {
    _stopwatch.stop();
    _ticker?.cancel();
    final scramble = cuber.Algorithm.scramble(n: 20);
    setState(() {
      _scramble = scramble;
      _cube = scramble.apply(cuber.Cube.solved);
      _elapsed = Duration.zero;
      _lastMs = null;
    });
  }

  void _toggleTimer() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _ticker?.cancel();
      final ms = _stopwatch.elapsedMilliseconds;
      setState(() => _lastMs = ms);
      if (_bestMs == null || ms < _bestMs!) {
        setState(() => _bestMs = ms);
        _saveBest(ms);
      }
    } else {
      _stopwatch
        ..reset()
        ..start();
      _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) {
        setState(() => _elapsed = _stopwatch.elapsed);
      });
      setState(() {});
    }
  }

  CubeColor? _colorAt(CubeFace face, int index) {
    final letter = _cube.colors[face.index * 9 + index];
    return _virtualColorMap[letter];
  }

  String _formatMs(int ms) {
    final minutes = ms ~/ 60000;
    final seconds = (ms ~/ 1000) % 60;
    final centis = (ms % 1000) ~/ 10;
    final secondsStr = seconds.toString().padLeft(2, '0');
    final centisStr = centis.toString().padLeft(2, '0');
    return minutes > 0 ? '$minutes:$secondsStr.$centisStr' : '$seconds.$centisStr';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.practiceTitle)),
      body: SafeArea(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _scramble.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Center(child: CubeNetView(colorAt: _colorAt)),
          ),
          Text(
            _formatMs(_elapsed.inMilliseconds),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          if (_lastMs != null) Text(l10n.practiceLastTime(_formatMs(_lastMs!))),
          if (_bestMs != null) Text(l10n.practiceBestTime(_formatMs(_bestMs!))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _newScramble,
                    child: Text(l10n.practiceScramble),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _toggleTimer,
                    child: Text(_stopwatch.isRunning ? l10n.practiceStop : l10n.practiceStart),
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
