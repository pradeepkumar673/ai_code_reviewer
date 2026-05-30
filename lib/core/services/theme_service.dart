import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ThemeService handles light/dark theme management
class ThemeService {
  static const _themeKey = 'devforge_ai_theme';

  /// Get the current theme mode from SharedPreferences
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? true; // Default to dark
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  /// Save the theme preference
  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, mode == ThemeMode.dark);
  }

  /// Toggle between light and dark theme
  static Future<void> toggleThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? true;
    await prefs.setBool(_themeKey, !isDarkMode);
  }

  /// Get the light theme for DevForge AI (optimized for developers)
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF6366F1), // Indigo
        secondary: const Color(0xFF8B5CF6), // Violet
        surface: const Color(0xFFF9FAFB),
        background: Colors.white,
        error: const Color(0xFFEF4444), // Red
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextStyle(
        fontFamily: 'SourceCodePro',
      ).apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF6366F1), width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Get the dark theme for DevForge AI (optimized for developers)
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF818CF8), // Violet-400
        secondary: const Color(0xFFA78BFA), // Violet-300
        surface: const Color(0xFF1F2937), // Gray-800
        background: const Color(0xFF111827), // Gray-900
        error: const Color(0xFFF87171), // Red-400
      ),
      scaffoldBackgroundColor: const Color(0xFF111827), // Gray-900
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F2937), // Gray-800
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextStyle(
        fontFamily: 'SourceCodePro',
      ).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF374151), // Gray-700
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4B5563)), // Gray-600
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF818CF8), width: 2), // Violet-400
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF818CF8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

/// Riverpod provider for theme mode
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  // This will be initialized properly in main.dart
  return ThemeMode.dark;
});

/// Riverpod provider for ThemeService
final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService();
});