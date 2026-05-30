import 'package:flutter/material.dart';

/// Dialog to edit scanned text before sending
class EditScanDialog extends StatefulWidget {
  final String scannedText;
  final String cleanedText;
  final Function(String) onSave;

  const EditScanDialog({
    Key? key,
    required this.scannedText,
    required this.cleanedText,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditScanDialog> createState() => _EditScanDialogState();
}

class _EditScanDialogState extends State<EditScanDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.cleanedText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Scanned Text'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: TextField(
          controller: _controller,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Edit the scanned text here...',
          ),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final editedText = _controller.text.trim();
            if (editedText.isNotEmpty) {
              widget.onSave(editedText);
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}