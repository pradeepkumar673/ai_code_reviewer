import 'package:devforge_ai/features/camera_scanner/domain/repositories/scanner_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Use case for scanning code from camera or gallery
class ScanCode {
  final ScannerRepository repository;

  ScanCode(this.repository);

  /// Scan code using the camera or gallery
  Future<String?> call({required bool useCamera}) async {
    if (useCamera) {
      return await repository.scanCodeFromCamera();
    } else {
      return await repository.scanCodeFromGallery();
    }
  }
}

/// Riverpod provider for the ScanCode use case
final scanCodeProvider = Provider<ScanCode>((ref) {
  final repository = ref.watch(scannerRepositoryProvider);
  return ScanCode(repository);
});

/// Provider for the ScannerRepository
final scannerRepositoryProvider = Provider<ScannerRepository>((ref) {
  return ScannerRepositoryImpl();
});