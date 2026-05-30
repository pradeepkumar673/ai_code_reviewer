/// Represents the result of a code quality analysis
class QualityAnalysisResult {
  final double readabilityScore; // 0-100
  final double performanceScore; // 0-100
  final double securityScore; // 0-100
  final double maintainabilityScore; // 0-100
  final double overallScore; // 0-100
  final List<String> suggestions;
  final List<String> strengths;

  QualityAnalysisResult({
    required this.readabilityScore,
    required this.performanceScore,
    required this.securityScore,
    required this.maintainabilityScore,
    required this.overallScore,
    required this.suggestions,
    required this.strengths,
  });

  factory QualityAnalysisResult.fromJson(Map<String, dynamic> json) {
    return QualityAnalysisResult(
      readabilityScore: (json['readabilityScore'] as num).toDouble(),
      performanceScore: (json['performanceScore'] as num).toDouble(),
      securityScore: (json['securityScore'] as num).toDouble(),
      maintainabilityScore: (json['maintainabilityScore'] as num).toDouble(),
      overallScore: (json['overallScore'] as num).toDouble(),
      suggestions: List<String>.from(json['suggestions'] ?? []),
      strengths: List<String>.from(json['strengths'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'readabilityScore': readabilityScore,
      'performanceScore': performanceScore,
      'securityScore': securityScore,
      'maintainabilityScore': maintainabilityScore,
      'overallScore': overallScore,
      'suggestions': suggestions,
      'strengths': strengths,
    };
  }
}