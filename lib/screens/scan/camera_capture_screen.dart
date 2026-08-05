import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/app_localizations.dart';
import '../../models/cube_state.dart';
import '../../services/color_detection_service.dart';
import 'color_correction_screen.dart';

/// Guides the user through photographing all 6 faces of the cube, one at a
/// time, with a 3x3 alignment grid overlay. Every photo goes through a
/// review step (retake or confirm) before moving on, and a thumbnail strip
/// always shows progress across all 6 faces — so it's hard to get lost or
/// rush past a misaligned shot. Automatic color detection then runs on the
/// confirmed photo; the result always continues to [ColorCorrectionScreen]
/// so misreads can still be fixed by hand.
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
  bool _flashOn = false;
  Uint8List? _reviewPhotoBytes;
  late CubeState _state;
  final List<Uint8List?> _thumbnails = List<Uint8List?>.filled(6, null);

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

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null) return;
    final turnOn = !_flashOn;
    try {
      await controller.setFlashMode(turnOn ? FlashMode.torch : FlashMode.off);
      if (mounted) setState(() => _flashOn = turnOn);
    } catch (_) {
      // Some devices/emulators have no flash — leave the toggle as-is.
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _capturing) return;

    setState(() => _capturing = true);
    try {
      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _capturing = false;
        _reviewPhotoBytes = bytes;
      });
    } catch (_) {
      if (mounted) setState(() => _capturing = false);
    }
  }

  void _retakePhoto() {
    setState(() => _reviewPhotoBytes = null);
  }

  void _confirmPhoto() {
    final bytes = _reviewPhotoBytes;
    if (bytes == null) return;

    final colors = _detector.detectFace(bytes);
    final face = CubeFace.values[_faceIndex];
    for (var i = 0; i < 9; i++) {
      _state.setSticker(face, i, colors[i]);
    }
    _thumbnails[_faceIndex] = bytes;

    final isLastFace = _faceIndex == CubeFace.values.length - 1;
    setState(() => _reviewPhotoBytes = null);

    if (isLastFace) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ColorCorrectionScreen(detectedState: _state)),
      );
    } else {
      setState(() => _faceIndex++);
    }
  }

  void _jumpToFace(int index) {
    if (_reviewPhotoBytes != null) return;
    setState(() => _faceIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reviewing = _reviewPhotoBytes != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cameraFaceProgress(_faceIndex + 1)),
        actions: [
          if (_setup == _SetupState.ready && !reviewing)
            IconButton(
              icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off),
              tooltip: l10n.cameraToggleFlash,
              onPressed: _toggleFlash,
            ),
        ],
      ),
      body: SafeArea(
        child: switch (_setup) {
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
                  l10n.cameraAnyOrderHint,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Some devices/emulators report `aspectRatio` already
                    // oriented for portrait display, others report the raw
                    // (often landscape) sensor ratio. Rather than guessing
                    // which convention applies and risking an overflowing,
                    // stretched box (which is exactly what made the guide
                    // grid not line up with the physical cube), always
                    // normalize to a portrait (<=1) ratio and then manually
                    // fit it inside the available space — this can never
                    // overflow, no matter what the camera reports.
                    final rawRatio = _controller!.value.aspectRatio;
                    final portraitRatio = rawRatio > 1 ? 1 / rawRatio : rawRatio;

                    var boxWidth = constraints.maxWidth;
                    var boxHeight = boxWidth / portraitRatio;
                    if (boxHeight > constraints.maxHeight) {
                      boxHeight = constraints.maxHeight;
                      boxWidth = boxHeight * portraitRatio;
                    }

                    return Center(
                      child: SizedBox(
                        width: boxWidth,
                        height: boxHeight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (reviewing)
                              Image.memory(_reviewPhotoBytes!, fit: BoxFit.cover)
                            else
                              CameraPreview(_controller!),
                            const IgnorePointer(child: CustomPaint(painter: _GuideGridPainter())),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  reviewing ? l10n.cameraReviewInstructions : l10n.cameraInstructions,
                  textAlign: TextAlign.center,
                ),
              ),
              _FaceThumbnailStrip(
                thumbnails: _thumbnails,
                currentIndex: _faceIndex,
                onTap: _jumpToFace,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: reviewing
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _retakePhoto,
                              icon: const Icon(Icons.replay),
                              label: Text(l10n.cameraRetake),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _confirmPhoto,
                              icon: const Icon(Icons.check),
                              label: Text(l10n.cameraUsePhoto),
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
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
        },
      ),
    );
  }
}

class _FaceThumbnailStrip extends StatelessWidget {
  final List<Uint8List?> thumbnails;
  final int currentIndex;
  final void Function(int index) onTap;

  const _FaceThumbnailStrip({
    required this.thumbnails,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: thumbnails.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final bytes = thumbnails[index];
          final isCurrent = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isCurrent ? primary : Colors.grey, width: isCurrent ? 3 : 1),
                color: Colors.grey.withValues(alpha: 0.15),
              ),
              clipBehavior: Clip.antiAlias,
              child: bytes == null
                  ? Center(child: Text('${index + 1}'))
                  : Image.memory(bytes, fit: BoxFit.cover),
            ),
          );
        },
      ),
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

    final side = size.shortestSide * kCubeGuideSquareFraction;
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
