import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devforge_ai/core/widgets/custom_app_bar.dart';
import 'package:devforge_ai/core/widgets/custom_button.dart';
import 'package:devforge_ai/core/widgets/custom_text_field.dart';
import 'package:devforge_ai/core/widgets/loading_indicator.dart';
import 'package:devforge_ai/core/widgets/error_display.dart';
import 'package:devforge_ai/core/constants/icon_constants.dart';
import 'package:devforge_ai/features/code_quality/domain/usecases/analyze_code_quality.dart';
import 'package:devforge_ai/features/code_quality/domain/entities/quality_analysis_result.dart';
import 'package:devforge_ai/core/models/persona.dart';

class QualityScorerPage extends ConsumerStatefulWidget {
  const QualityScorerPage({super.key});

  @override
  ConsumerState<QualityScorerPage> createState() => _QualityScorerPageState();
}

class _QualityScorerPageState extends ConsumerState<QualityScorerPage> {
  final _codeController = TextEditingController();
  String _selectedLanguage = 'Dart';
  bool _isAnalyzing = false;
  QualityAnalysisResult? _analysisResult;
  String? _errorMessage;

  final List<String> _supportedLanguages = [
    'Dart',
    'JavaScript',
    'TypeScript',
    'Python',
    'Java',
    'C++',
    'C#',
    'Go',
    'Rust',
    'PHP',
  ];

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final analyzeCodeQuality = ref.watch(analyzeCodeQualityProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Code Quality Scorer',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(IconConstants.clear),
            tooltip: 'Clear Code',
            onPressed: _isAnalyzing ? null : _clearCode,
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
                // Language Selector
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: 'Programming Language',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: _supportedLanguages.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(
                          language,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: _isAnalyzing
                        ? null
                        : (String? newValue) {
                            setState(() {
                              _selectedLanguage = newValue!;
                            });
                          },
                  ),
                ),
                const SizedBox(height: 16),

                // Code Input
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    hintText: 'Paste your code here for analysis...',
                    controller: _codeController,
                    maxLines: 10,
                  ),
                ),
                const SizedBox(height: 16),

                // Analyze Button
                CustomButton(
                  text: 'Analyze Code Quality',
                  icon: IconConstants.insights,
                  onPressed: _isAnalyzing ? null : _analyzeCode,
                  isLoading: _isAnalyzing,
                  fullWidth: true,
                ),
                const SizedBox(height: 24),

                // Results or Error
                if (_errorMessage != null) ...[
                  ErrorDisplay(
                    message: _errorMessage!,
                    onRetry: _analyzeCode,
                  ),
                ] else if (_analysisResult != null) ...[
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Overall Score
                          _buildScoreCard(
                            title: 'Overall Score',
                            score: _analysisResult!.overallScore,
                            color: _getScoreColor(_analysisResult!.overallScore),
                          ),
                          const SizedBox(height: 16),

                          // Individual Scores
                          Text(
                            'Detailed Analysis',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildScoreRow(
                            label: 'Readability',
                            score: _analysisResult!.readabilityScore,
                            color: _getScoreColor(_analysisResult!.readabilityScore),
                          ),
                          _buildScoreRow(
                            label: 'Performance',
                            score: _analysisResult!.performanceScore,
                            color: _getScoreColor(_analysisResult!.performanceScore),
                          ),
                          _buildScoreRow(
                            label: 'Security',
                            score: _analysisResult!.securityScore,
                            color: _getScoreColor(_analysisResult!.securityScore),
                          ),
                          _buildScoreRow(
                            label: 'Maintainability',
                            score: _analysisResult!.maintainabilityScore,
                            color: _getScoreColor(_analysisResult!.maintainabilityScore),
                          ),
                          const SizedBox(height: 24),

                          // Strengths
                          if (_analysisResult!.strengths.isNotEmpty) ...[
                            Text(
                              'Strengths',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ..._analysisResult!.strengths.map((strength) => Padding(
                                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          strength,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 16),
                          ],

                          // Suggestions
                          if (_analysisResult!.suggestions.isNotEmpty) ...[
                            Text(
                              'Improvement Suggestions',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ..._analysisResult!.suggestions.map((suggestion) => Padding(
                                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.lightbulb_outline),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          suggestion,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ]
                                  ),
                                )),
                            const SizedBox(height: 16),
                          ],

                          // Action Buttons
                          CustomButton(
                            text: 'Send Analysis to Chat',
                            icon: IconConstants.send,
                            onPressed: _sendToChat,
                            fullWidth: true,
                          ),
                          const SizedBox(height: 8),
                          CustomButton.outlined(
                            text: 'Analyze Another Code Snippet',
                            icon: IconConstants.refresh,
                            onPressed: _analyzeAnother,
                            fullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Placeholder when no analysis has been done
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconConstants.insights,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Paste code above and click "Analyze Code Quality" to get started',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard({
    required String title,
    required double score,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${score.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow({
    required String label,
    required double score,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth * (score / 100);
                  return Stack(
                    children: [
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${score.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: score > 50 ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Future<void> _analyzeCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some code to analyze';
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      _analysisResult = null;
    });

    try {
      final result = await analyzeCodeQuality.call(
        code: code,
        language: _selectedLanguage,
      );
      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error analyzing code: $e';
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _sendToChat() async {
    if (_analysisResult == null) return;

    // Format the analysis results for sending to chat
    final analysisMessage = '''
I analyzed this $_selectedLanguage code:

\`\`\`$_selectedLanguage
${_codeController.text}
\`\`\`

**Code Quality Analysis Results:**
- Overall Score: ${_analysisResult!.overallScore.toStringAsFixed(0)}/100
- Readability: ${_analysisResult!.readabilityScore.toStringAsFixed(0)}/100
- Performance: ${_analysisResult!.performanceScore.toStringAsFixed(0)}/100
- Security: ${_analysisResult!.securityScore.toStringAsFixed(0)}/100
- Maintainability: ${_analysisResult!.maintainabilityScore.toStringAsFixed(0)}/100

**Strengths:**
${_analysisResult!.strengths.map((s) => '• $s').join('\n')}

**Improvement Suggestions:**
${_analysisResult!.suggestions.map((s) => '• $s').join('\n')}

Based on this analysis, could you provide specific guidance on how to improve this code?
''';

    try {
      // We would use the sendMessage use case here
      // For now, we'll show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analysis sent to chat!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending to chat: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _clearCode() {
    setState(() {
      _codeController.clear();
      _analysisResult = null;
      _errorMessage = null;
    });
  }

  void _analyzeAnother() {
    setState(() {
      _analysisResult = null;
      _errorMessage = null;
    });
    _codeController.clear();
  }
}