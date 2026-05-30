# Testing Instructions for DevForge AI

## 🔧 Setup and Prerequisites

Before testing, ensure you have:

1. **Flutter SDK** installed and configured
2. **Android device/emulator** with camera support (for scanner testing)
3. **Gemini API key** set in `assets/creds/.env`:
   ```
   API_KEY=your_actual_gemini_api_key_here
   ```
4. **Run `flutter pub get`** to install all dependencies

## 📱 Testing the Smart Camera Code Scanner

### 1. Accessing the Scanner Page
You'll need to temporarily add navigation to test the scanner. Add this to your home page or create a temporary button:

```dart
// Example: Add to your HomePage
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );
  },
  child: const Text('Test Scanner'),
)
```

### 2. Camera Scanner Tests

#### Test Case 1: Camera Permission Handling
- [ ] Launch the scanner page
- [ ] Tap "Scan with Camera" button
- [ ] Verify camera permission dialog appears (if not previously granted)
- [ ] If denied, verify appropriate error handling
- [ ] If granted, verify camera preview opens

#### Test Case 2: Gallery Access
- [ ] Launch the scanner page
- [ ] Tap the gallery icon in app bar to switch to gallery mode
- [ ] Tap "Scan from Gallery" button
- [ ] Verify gallery picker opens
- [ ] Select an image containing code
- [ ] Verify scanned text is extracted and displayed

#### Test Case 3: Text Recognition Accuracy
- [ ] Prepare test images with:
  - Clear, well-lit code snippets
  - Various programming languages (Dart, Python, JavaScript, etc.)
  - Code with errors/exceptions
  - Terminal output
- [ ] Scan each image
- [ ] Verify:
  - Text is correctly recognized (minimal errors)
  - Formatting is preserved (indentation, line breaks)
  - Excessive whitespace is cleaned up
  - Very long scans are handled appropriately

#### Test Case 4: Integration with Chat
- [ ] After successful scan, tap "Send to Chat" button
- [ ] Verify:
  - Scanned code is sent to chat with appropriate context
  - Chat switches to or remains in current persona
  - AI responds appropriately to the scanned code
  - Chat history is updated and persisted

#### Test Case 5: Error Handling
- [ ] Test with blurry or low-contrast images
- [ ] Test with images containing no readable text
- [ ] Test camera failure scenarios (if possible to simulate)
- [ ] Verify appropriate error messages are shown
- [ ] Verify app doesn't crash

## 📊 Testing the Code Quality Scorer

### 1. Accessing the Quality Scorer Page
Add temporary navigation similar to the scanner:

```dart
// Example: Add to your HomePage
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QualityScorerPage()),
    );
  },
  child: const Text('Test Quality Scorer'),
)
```

### 2. Code Quality Scorer Tests

#### Test Case 1: Basic Functionality
- [ ] Navigate to quality scorer page
- [ ] Paste a simple code snippet in the code editor
- [ ] Select appropriate language from dropdown
- [ ] Tap "Analyze Code Quality" button
- [ ] Verify loading indicator appears during analysis
- [ ] Verify results are displayed after analysis completes

#### Test Case 2: Score Accuracy
- [ ] Test with:
  - **High-quality code**: Well-commented, properly indented, good naming, error handling
    - Expected: High scores (80-100) across all dimensions
  - **Low-quality code**: No comments, poor formatting, magic numbers, no error handling
    - Expected: Lower scores (0-60) with specific suggestions
  - **Security-risk code**: Hardcoded passwords, API keys, eval() usage
    - Expected: Low security score with specific warnings
  - **Performance-issue code**: Nested loops, inefficient algorithms
    - Expected: Lower performance score with optimization suggestions
- [ ] Verify scores align with expectations
- [ ] Verify individual dimension scores are calculated correctly
- [ ] Verify overall score is proper weighted average

#### Test Case 3: Visual Feedback
- [ ] Verify:
  - Overall score card displays correctly with appropriate color
  - Individual score rows show progress bars with correct fill
  - Score percentages are displayed correctly
  - Color coding works: Green (≥80), Orange (60-79), Red (<60)
  - Strengths and suggestions are displayed in appropriate sections
  - Icons are shown correctly for strengths (check) and suggestions (lightbulb)

#### Test Case 4: Language Support
- [ ] Test with code snippets in:
  - Dart
  - Python
  - JavaScript/TypeScript
  - Java
  - C++
  - C#
  - Go
  - Rust
  - PHP
- [ ] Verify analysis runs for each language
- [ ] Verify language-specific considerations are taken into account

#### Test Case 5: Integration with Chat
- [ ] After analysis completes, tap "Send Analysis to Chat" button
- [ ] Verify:
  - Formatted analysis results are sent to chat
  - Includes code, scores, strengths, and suggestions
  - AI provides meaningful follow-up based on the analysis
  - Chat history is updated

#### Test Case 6: UI Interactions
- [ ] Test "Clear Code" button clears the editor and results
- [ ] Test "Analyze Another" button resets for new analysis
- [ ] Test language selector works correctly
- [ ] Verify error handling for empty code submission
- [ ] Test edge cases: very long code, special characters, etc.

### 3. Cross-Feature Tests

#### Test Case: Scanner → Quality Scorer Workflow
- [ ] Scan code using the camera scanner
- [ ] Send scanned code to chat
- [ ] Copy code from chat response
- [ ] Paste into quality scorer
- [ ] Analyze the code quality
- [ ] Verify end-to-end workflow works seamlessly

#### Test Case: Quality Scorer → Chat Improvement
- [ ] Analyze low-quality code in quality scorer
- [ ] Send analysis to chat
- [ ] Ask AI for specific improvement suggestions
- [ ] Verify AI provides actionable guidance based on analysis

## ⚙️ Technical Verification

### 1. Dependencies and Build
- [ ] Run `flutter pub get` - should succeed without errors
- [ ] Run `flutter build apk` or `flutter run` - should build successfully
- [ ] Check for any lint errors with `flutter analyze`

### 2. State Management
- [ ] Verify Riverpod providers are working correctly
- [ ] Test that persona changes affect chat behavior
- [ ] Test that state persists appropriately (where needed)

### 3. Storage and Persistence
- [ ] Test that user data persists between app restarts
- [ ] Test that chat sessions are saved and loaded correctly
- [ ] Test that progress service data (XP, level, badges) persists

### 4. Performance
- [ ] Monitor app startup time
- [ ] Check for jank during animations/transitions
- [ ] Verify battery usage is reasonable during scanner use
- [ ] Test memory usage doesn't leak during extended use

## 🐛 Known Issues to Watch For

1. **ML Kit Initialization**: First-time ML Kit usage might cause slight delay
2. **Text Recognition Variability**: Accuracy depends on image quality, lighting, font
3. **Simulated Analysis**: Code quality scorer currently uses simulated analysis (replace with real tools later)
4. **Provider Initialization**: Some providers use placeholder implementations that need to be replaced with proper DI
5. **Navigation**: You'll need to implement proper navigation to access these features

## ✅ Success Criteria

For each feature to be considered "working":
1. Feature launches without crashes
2. Core functionality works as expected
3. Error handling is graceful and informative
4. UI is responsive and provides appropriate feedback
5. Integration points with other features work correctly
6. Performance is acceptable for a mobile app

## 📝 Testing Checklist

Use this checklist during your testing sessions:

```
[ ] Camera Scanner:
    [ ] Camera permission handling
    [ ] Gallery image selection
    [ ] Text recognition accuracy
    [ ] Text cleanup and formatting
    [ ] Send to chat integration
    [ ] Error handling

[ ] Code Quality Scorer:
    [ ] Basic analysis functionality
    [ ] Score accuracy and reliability
    [ ] Visual feedback and colors
    [ ] Language support
    [ ] Strengths and suggestions
    [ ] Send to chat integration
    [ ] UI interactions (clear, analyze another)
    [ ] Error handling

[ ] Integration:
    [ ] Scanner → Chat workflow
    [ ] Quality Scorer → Chat workflow
    [ ] Cross-feature data flow

[ ] Technical:
    [ ] Build success
    [ ] Dependency resolution
    [ ] State management
    [ ] Storage persistence
    [ ] Performance metrics
```

When you've completed testing these features and they meet the success criteria, you'll be ready to move on to implementing the Gamification system next!

Happy testing and coding! 🚀