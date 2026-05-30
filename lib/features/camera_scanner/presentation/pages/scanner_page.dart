import 'dart:async';
import 'package:devforge_ai/features/camera_scanner/domain/usecases/scan_code.dart';
import 'package:devforge_ai/features/camera_scanner/presentation/widgets/scan_overlay.dart';
import 'package:devforge_ai/features/camera_scanner/presentation/widgets/scan_history_dialog.dart';
import 'package:devforge_ai/features/camera_scanner/presentation/widgets/edit_scan_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

/// Camera scanner page with real-time text recognition
class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  late CameraController _cameraController;
  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _scannedText;
  String? _cleanedText;
  Timer? _processingTimer;
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == LensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      // Start processing frames for real-time text recognition
      _startFrameProcessing();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  void _startFrameProcessing() {
    if (_isProcessing || !_isInitialized) return;

    _isProcessing = true;
    _processingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!_isInitialized || !_cameraController.value.isInitialized) return;

      try {
        final image = await _cameraController.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);

        final recognizedText = await _textRecognizer.processImage(inputImage);
        final scannedText = recognizedText.text;

        if (scannedText.isNotEmpty) {
          final cleanedText = _cleanScannedText(scannedText);

          if (cleanedText.isNotEmpty) {
            setState(() {
              _scannedText = scannedText;
              _cleanedText = cleanedText;
            });

            // Stop processing once we have good text
            _processingTimer?.cancel();
            _isProcessing = false;

            // Show edit dialog
            if (mounted) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => EditScanDialog(
                  scannedText: _scannedText!,
                  cleanedText: _cleanedText!,
                  onSave: (text) {
                    Navigator.of(context).pop();
                    // TODO: Send to current persona
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Text sent to AI Mentor!')),
                    );
                  },
                ),
              );
            }
          }
        }
      } catch (e) {
        debugPrint('Error processing frame: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    });
  }

  String _cleanScannedText(String text) {
    if (text.isEmpty) return '';

    // Split into lines and process each line
    final List<String> lines = text.split('\n');
    final List<String> cleanedLines = [];

    for (String line in lines) {
      // Remove leading/trailing whitespace
      String trimmed = line.trim();

      // Skip empty lines but keep track of consecutive empty lines for code structure
      if (trimmed.isEmpty) {
        // Only add empty line if previous line wasn't empty (to avoid multiple empty lines)
        if (cleanedLines.isNotEmpty && cleanedLines.last.isNotEmpty) {
          cleanedLines.add('');
        }
        continue;
      }

      // Fix common OCR mistakes in code
      trimmed = trimmed
          .replaceAll(RegExp(r'O(?=[A-Za-z])'), '0') // O between letters -> 0
          .replaceAll(RegExp(r'l(?=[A-Za-z])'), '1') // l between letters -> 1
          .replaceAll(RegExp(r'S(?=[A-Za-z])'), '5') // S between letters -> 5
          .replaceAll('`', ''); // Remove backticks that often appear in OCR

      cleanedLines.add(trimmed);
    }

    // Join lines back together
    String result = cleanedLines.join('\n');

    // Remove multiple consecutive empty lines (more than 2)
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // Trim final result
    return result.trim();
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    _cameraController.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || !_cameraController.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera preview
          CameraPreview(_cameraController),

          // Scan overlay with guidance
          const ScanOverlay(),

          // Bottom controls
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : () {
                      _startFrameProcessing();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: Text(
                      _isProcessing ? 'Processing...' : 'Scan Code',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _isProcessing ? Colors.grey : Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ScanHistoryDialog(),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('History'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}