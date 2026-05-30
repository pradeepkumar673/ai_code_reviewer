import 'package:devforge_ai/features/camera_scanner/domain/repositories/scanner_repository.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

/// Implementation of the ScannerRepository using Google ML Kit
class ScannerRepositoryImpl implements ScannerRepository {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

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

      // Process the image with text recognition
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Extract and clean the text
      String scannedText = recognizedText.text;

      // Basic cleanup - remove excessive newlines and spaces
      scannedText = scannedText
          .replaceAll(RegExp(r'\s+\n\s+'), '\n') // Clean up whitespace around newlines
          .replaceAll(RegExp(r'\n\s+\n'), '\n\n') // Normalize multiple newlines
          .trim();

      return scannedText.isEmpty ? null : scannedText;
    } catch (e) {
      // In a real app, you might want to log this error
      return null;
    } finally {
      // Close the text recognizer when done
      await _textRecognizer.close();
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

      // Process the image with text recognition
      final InputImage inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Extract and clean the text
      String scannedText = recognizedText.text;

      // Basic cleanup - remove excessive newlines and spaces
      scannedText = scannedText
          .replaceAll(RegExp(r'\s+\n\s+'), '\n') // Clean up whitespace around newlines
          .replaceAll(RegExp(r'\n\s+\n'), '\n\n') // Normalize multiple newlines
          .trim();

      return scannedText.isEmpty ? null : scannedText;
    } catch (e) {
      // In a real app, you might want to log this error
      return null;
    } finally {
      // Close the text recognizer when done
      await _textRecognizer.close();
    }
  }
}