import 'dart:convert';
import 'package:devforge_ai/features/camera_scanner/domain/entities/scan_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devforge_ai/features/camera_scanner/data/repositories/scanner_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dialog to display scan history with favorites
class ScanHistoryDialog extends ConsumerStatefulWidget {
  const ScanHistoryDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanHistoryDialog> createState() => _ScanHistoryDialogState();
}

class _ScanHistoryDialogState extends ConsumerState<ScanHistoryDialog> {
  late final ScannerRepositoryImpl _repository;
  List<ScanHistory> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = ScannerRepositoryImpl();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _repository.getScanHistory();
      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(ScanHistory scan) async {
    await _repository.saveToFavorites(scan.id);
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan History'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _history.isEmpty
                ? const Center(child: Text('No scan history'))
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final scan = _history[index];
                      return ListTile(
                        leading: Icon(
                          scan.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: scan.isFavorite ? Colors.red : null,
                        ),
                        title: Text(
                          scan.cleanedText?.split('\n').first ?? '(No text)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                        subtitle: Text(
                          '${scan.timestamp.year}-${scan.timestamp.month.toString().padLeft(2, '0')}-${scan.timestamp.day.toString().padLeft(2, '0')} '
                          '${scan.timestamp.hour.toString().padLeft(2, '0')}:${scan.timestamp.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () {
                            // Copy to clipboard
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Copied: ${scan.cleanedText?.substring(0, 50) ?? ''}...',
                                ),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          // Show full scan dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Scan Details'),
                              content: SizedBox(
                                width: double.maxFinite,
                                height: 300,
                                child: SingleChildScrollView(
                                  child: Text(
                                    scan.cleanedText ?? scan.scannedText,
                                    style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                                if (!scan.isFavorite)
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _toggleFavorite(scan);
                                    },
                                    child: const Text('Add to Favorites'),
                                  ),
                                if (scan.isFavorite)
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _toggleFavorite(scan);
                                    },
                                    child: const Text('Remove from Favorites'),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  // Clear history confirmation
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear History'),
                      content: const Text('Are you sure you want to clear all scan history?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('devforge_ai_scan_history');
                            if (mounted) {
                              setState(() {
                                _history = [];
                              });
                            }
                          },
                          child: const Text('Clear'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
          child: const Text('Clear All'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}