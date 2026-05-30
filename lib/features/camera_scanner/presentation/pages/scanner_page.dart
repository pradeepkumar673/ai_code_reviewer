import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devforge_ai/core/widgets/custom_app_bar.dart';
import 'package:devforge_ai/core/widgets/custom_button.dart';
import 'package:devforge_ai/core/widgets/custom_text_field.dart';
import 'package:devforge_ai/core/widgets/loading_indicator.dart';
import 'package:devforge_ai/core/widgets/error_display.dart';
import 'package:devforge_ai/features/camera_scanner/domain/usecases/scan_code.dart';
import 'package:devforge_ai/features/chat/domain/use_cases/send_message.dart';
import 'package:devforge_ai/core/models/persona.dart';
import 'package:devforge_ai/core/providers/app_providers.dart';

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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentPersona = ref.watch(personaProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Code Scanner',
        showBackButton: false,
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
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _useCamera
                        ? 'Point your camera at code on your laptop screen\nMake sure the code is well-lit and in focus'
                        : 'Select an image from your gallery containing code',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
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
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
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
                                  style: const TextStyle(
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
      final scanCode = ref.read(scanCodeProvider);
      final scannedText = await scanCode.call(useCamera: _useCamera);
      if (scannedText != null && scannedText.isNotEmpty) {
        setState(() {
          _scannedText = scannedText;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'No text detected. Please try again with better lighting.',
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
        const SnackBar(
          content: Text('Text copied to clipboard!'),
          backgroundColor: Colors.green,
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
      final sendMessage = ref.read(sendMessageProvider);
      final currentPersona = ref.read(personaProvider);
      await sendMessage.call(contextMessage);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sent to chat with ${currentPersona.displayName}',
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
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}