import 'dart:convert';
import 'package:devforge_ai/features/camera_scanner/domain/repositories/scanner_repository.dart';
import 'package:devforge_ai/features/camera_scanner/domain/entities/scan_history.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of the ScannerRepository using Google ML Kit
class ScannerRepositoryImpl implements ScannerRepository {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();
  static const _historyKey = 'devforge_ai_scan_history';

  @override
  Future<String?> recognizeTextFromImage(XFile image) async {
    try {
      // Process the image with text recognition
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Extract and clean the text
      String scannedText = recognizedText.text;
      String cleanedText = _cleanScannedText(scannedText);

      // Save to history
      await _saveToHistory(scannedText, cleanedText);

      return cleanedText.isEmpty ? null : cleanedText;
    } catch (e) {
      // In a real app, you might want to log this error
      return null;
    } finally {
      // Close the text recognizer when done
      await _textRecognizer.close();
    }
  }

  @override
  Future<String?> scanCodeFromCamera() async {
    try {
      // Pick image from camera
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await recognizeTextFromImage(image);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> scanCodeFromGallery() async {
    try {
      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await recognizeTextFromImage(image);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ScanHistory>> getScanHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? historyStrings =
          prefs.getStringList(_historyKey);

      if (historyStrings == null || historyStrings.isEmpty) {
        return [];
      }

      return historyStrings
          .map((jsonString) => ScanHistory.fromMap(
                jsonDecode(jsonString) as Map<String, dynamic>,
              ))
          .toList()
          .reversed // Most recent first
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveToFavorites(String scanId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? historyStrings =
          prefs.getStringList(_historyKey);

      if (historyStrings == null) return;

      final List<ScanHistory> history = historyStrings
          .map((jsonString) => ScanHistory.fromMap(
                jsonDecode(jsonString) as Map<String, dynamic>,
              ))
          .toList();

      final updatedHistory = history.map((scan) {
        if (scan.id == scanId) {
          return scan.copyWith(isFavorite: true);
        }
        return scan;
      }).toList();

      final List<String> updatedJsonStrings = updatedHistory
          .map((scan) => jsonEncode(scan.toMap()))
          .toList();

      await prefs.setStringList(_historyKey, updatedJsonStrings);
    } catch (e) {
      // Silently fail - favorites are nice-to-have
    }
  }

  /// Cleans up scanned text to make it suitable for code
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

  /// Saves a scan to history
  Future<void> _saveToHistory(String scannedText, String cleanedText) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? historyStrings =
          prefs.getStringList(_historyKey);

      final ScanHistory newScan = ScanHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        scannedText: scannedText,
        cleanedText: cleanedText.isEmpty ? null : cleanedText,
        timestamp: DateTime.now(),
        isFavorite: false,
      );

      List<String> updatedHistory = historyStrings != null
          ? List.from(historyStrings)
          : [];

      // Add new scan to the beginning
      updatedHistory.insert(0, jsonEncode(newScan.toMap()));

      // Keep only last 50 scans to prevent excessive storage
      if (updatedHistory.length > 50) {
        updatedHistory = updatedHistory.sublist(0, 50);
      }

      await prefs.setStringList(_historyKey, updatedHistory);
    } catch (e) {
      // Silently fail - history is nice-to-have, not critical
    }
  }
}