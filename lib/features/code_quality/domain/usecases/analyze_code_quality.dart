import 'package:devforge_ai/features/code_quality/domain/repositories/quality_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Use case for analyzing code quality
class AnalyzeCodeQuality {
  final QualityRepository repository;

  AnalyzeCodeQuality(this.repository);

  /// Analyze the quality of the provided code
  Future<QualityAnalysisResult> call({
    required String code,
    required String language,
  }) async {
    return await repository.analyzeCodeQuality(
      code: code,
      language: language,
    );
  }
}

/// Riverpod provider for the AnalyzeCodeQuality use case
final analyzeCodeQualityProvider = Provider<AnalyzeCodeQuality>((ref) {
  final repository = ref.watch(qualityRepositoryProvider);
  return AnalyzeCodeQuality(repository);
});

/// Provider for the QualityRepository
final qualityRepositoryProvider = Provider<QualityRepository>((ref) {
  return QualityRepositoryImpl();
});