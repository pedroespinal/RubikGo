import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/app_localizations.dart';
import '../../models/cube_state.dart';
import '../../services/color_detection_service.dart';
import 'color_correction_screen.dart';

/// Guides the user through photographing all 6 faces of the cube, one at a
/// time, with a 3x3 alignment grid overlay. Automatic color detection runs
/// on each photo; the result always continues to [ColorCorrectionScreen]
/// so misreads can be fixed before solving.
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

enum _SetupState { loading, ready, permissionDenied, noCamera }

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  static const _detector = ColorDetectionService();

  CameraController? _controller;
  _SetupState _setup = _SetupState.loading;
  int _faceIndex = 0;
  bool _capturing = false;
  late CubeState _state;

  @override
  void initState() {
    super.initState();
    _state = CubeState.empty();
    _init();
  }

  Future<void> _init() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) setState(() => _setup = _SetupState.permissionDenied);
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      if (mounted) setState(() => _setup = _SetupState.noCamera);
      return;
    }

    final controller = CameraController(cameras.first, ResolutionPreset.medium, enableAudio: false);
    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() {
      _controller = controller;
      _setup = _SetupState.ready;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _capturing) return;

    setState(() => _capturing = true);
    try {
      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();
      final colors = _detector.detectFace(bytes);
      final face = CubeFace.values[_faceIndex];
      for (var i = 0; i < 9; i++) {
        _state.setSticker(face, i, colors[i]);
      }

      if (_faceIndex == CubeFace.values.length - 1) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ColorCorrectionScreen(detectedState: _state)),
        );
      } else {
        setState(() {
          _faceIndex++;
          _capturing = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _capturing = false);
    }
  }

  void _retakePrevious() {
    if (_faceIndex > 0) setState(() => _faceIndex--);
  }

  String _faceLabel(CubeFace face, AppLocalizations l10n) {
    switch (face) {
      case CubeFace.up:
        return l10n.faceUp;
      case CubeFace.right:
        return l10n.faceRight;
      case CubeFace.front:
        return l10n.faceFront;
      case CubeFace.down:
        return l10n.faceDown;
      case CubeFace.left:
        return l10n.faceLeft;
      case CubeFace.back:
        return l10n.faceBack;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final face = CubeFace.values[_faceIndex];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cameraFaceProgress(_faceIndex + 1))),
      body: switch (_setup) {
        _SetupState.loading => const Center(child: CircularProgressIndicator()),
        _SetupState.permissionDenied || _SetupState.noCamera => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.cameraPermissionDenied, textAlign: TextAlign.center),
            ),
          ),
        _SetupState.ready => Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  l10n.cameraTitle(_faceLabel(face, l10n)),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_controller!),
                    const IgnorePointer(child: CustomPaint(painter: _GuideGridPainter())),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.cameraInstructions, textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Row(
                  children: [
                    if (_faceIndex > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _capturing ? null : _retakePrevious,
                          child: Text(l10n.cameraRetake),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _capturing ? null : _capture,
                        icon: _capturing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.camera_alt),
                        label: Text(l10n.cameraCapture),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      },
    );
  }
}

class _GuideGridPainter extends CustomPainter {
  const _GuideGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final side = size.shortestSide * 0.7;
    final left = (size.width - side) / 2;
    final top = (size.height - side) / 2;

    canvas.drawRect(Rect.fromLTWH(left, top, side, side), paint);
    for (var i = 1; i < 3; i++) {
      final x = left + side / 3 * i;
      canvas.drawLine(Offset(x, top), Offset(x, top + side), paint);
      final y = top + side / 3 * i;
      canvas.drawLine(Offset(left, y), Offset(left + side, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
