import 'package:devforge_ai/features/camera_scanner/domain/entities/scan_history.dart';
import 'package:image_picker/image_picker.dart';

abstract class ScannerRepository {
  /// Recognize text from an image file.
  Future<String?> recognizeTextFromImage(XFile image);

  /// Get the list of scan history (most recent first).
  Future<List<ScanHistory>> getScanHistory();

  /// Save a scan to favorites.
  Future<void> saveToFavorites(String scanId);
}