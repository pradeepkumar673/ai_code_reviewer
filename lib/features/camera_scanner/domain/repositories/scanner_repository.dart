abstract class ScannerRepository {
  Future<String?> scanCodeFromCamera();
  Future<String?> scanCodeFromGallery();
}