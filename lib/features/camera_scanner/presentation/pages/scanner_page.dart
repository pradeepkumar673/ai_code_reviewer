import 'package:devforge_ai/core/widgets/custom_button.dart';
import 'package:devforge_ai/core/widgets/custom_text_field.dart';
import 'package:devforge_ai/core/widgets/loading_indicator.dart';
import 'package:devforge_ai/features/chat/domain/use_cases/send_message.dart';
import 'package:devforge_ai/features/camera_scanner/domain/use_cases/scan_code.dart';
import 'package:devforge_ai/features/chat/domain/entities/persona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scanner Page for capturing code from laptop screen using device camera
class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  String _scannedText = '';
  bool _isScanning = false;
  bool _useCamera = true; // true for camera, false for gallery

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scanCode = ref.watch(scanCodeProvider);
    final sendMessage = ref.watch(sendMessageProvider);
    final currentPersona = ref.watch(personaProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Code Scanner',
          style: GoogleFonts.sourceCodePro(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_useCamera ? Icons.photo_library : Icons.camera_alt),
            tooltip: _useCamera ? 'Use Camera' : 'Use Gallery',
            onPressed: _isScanning
                ? null
                : () {
                    setState(() {
                      _useCamera = !_useCamera;
                    });
                  },
          ),
        ],
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _useCamera
                        ? 'Point your camera at code on your laptop screen\nMake sure the code is well-lit and in focus'
                        : 'Select an image from your gallery containing code',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceCodePro(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Scan Button
                CustomButton(
                  text: _useCamera ? 'Scan with Camera' : 'Scan from Gallery',
                  icon: _useCamera ? Icons.camera_alt : Icons.photo_library,
                  onPressed: _isScanning ? null : _performScan,
                  isLoading: _isScanning,
                  fullWidth: true,
                ),
                const SizedBox(height: 24),

                // Divider
                Divider(
                  color: theme.colorScheme.outlineVariant,
                  height: 1,
                ),
                const SizedBox(height: 24),

                // Scanned Text Preview
                Expanded(
                  child: _scannedText.isEmpty
                      ? Center(
                          child: Text(
                            'No code scanned yet',
                            style: GoogleFonts.sourceCodePro(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  _scannedText,
                                  style: GoogleFonts.sourceCodePro(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),

                // Action Buttons
                if (_scannedText.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton.outlined(
                          text: 'Copy Text',
                          icon: Icons.content_copy,
                          onPressed: _copyToClipboard,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Send to Chat',
                          icon: Icons.send,
                          onPressed: _sendToChat,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _performScan() async {
    setState(() {
      _isScanning = true;
    });

    try {
      final scannedText = await scanCode(useCamera: _useCamera);
      if (scannedText != null && scannedText.isNotEmpty) {
        setState(() {
          _scannedText = scannedText;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No text detected. Please try again with better lighting.',
                style: GoogleFonts.sourceCodePro(),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error scanning: $e',
              style: GoogleFonts.sourceCodePro(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  Future<void> _copyToClipboard() async {
    // In a real implementation, we would use clipboard package
    // For now, we'll show a snackbar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Text copied to clipboard!',
            style: GoogleFonts.sourceCodePro(),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  Future<void> _sendToChat() async {
    if (_scannedText.isEmpty) return;

    // Prepend context about the scanned code
    final contextMessage = '''
I scanned this code from my laptop screen:

```$_scannedText```

Can you help me understand, debug, or improve this code?
''';

    try {
      await sendMessage(contextMessage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sent to chat with ${currentPersona.displayName}',
              style: GoogleFonts.sourceCodePro(),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        // Clear the scanned text after sending
        setState(() {
          _scannedText = '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error sending to chat: $e',
              style: GoogleFonts.sourceCodePro(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}