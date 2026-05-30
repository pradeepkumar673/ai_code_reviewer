import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// ProgressService
/// Handles tracking of user's XP, levels, badges, and progress.
class ProgressService {
  // SharedPreferences keys
  static const _xpKey = 'devforge_ai_xp';
  static const _levelKey = 'devforge_ai_level';
  static const _badgesKey = 'devforge_ai_badges';

  // XP required for each level (can be made more complex)
  static const _xpPerLevel = 100;

  // Initialize SharedPreferences
  static Future<SharedPreferences> _getPrefs() =>
      SharedPreferences.getInstance();

  // ── XP Management ─────────────────────────────────────────────────────────

  /// Add [amount] XP to the user's total.
  static Future<void> addXP(int amount) async {
    final prefs = await _getPrefs();
    final currentXP = await getXP();
    final newXP = currentXP + amount;
    await prefs.setInt(_xpKey, newXP);
    // Check for level up after adding XP
    await _checkLevelUp(newXP);
  }

  /// Get the user's total XP.
  static Future<int> getXP() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_xpKey) ?? 0;
  }

  /// Get the user's current level based on XP.
  static Future<int> getLevel() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_levelKey) ?? 1;
  }

  /// Set the user's level directly (used internally).
  static Future<void> _setLevel(int level) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_levelKey, level);
  }

  /// Check if the user has enough XP to level up and update level if so.
  static Future<void> _checkLevelUp(int xp) async {
    final currentLevel = await getLevel();
    final newLevel = (xp ~/ _xpPerLevel) + 1;
    if (newLevel > currentLevel) {
      await _setLevel(newLevel);
      // TODO: Trigger level up event/show celebration
    }
  }

  // ── Badge Management ──────────────────────────────────────────────────────

  /// Award a badge to the user if they don't already have it.
  static Future<void> awardBadge(String badgeId) async {
    final prefs = await _getPrefs();
    final List<String> currentBadges = await getBadges();
    if (!currentBadges.contains(badgeId)) {
      currentBadges.add(badgeId);
      await prefs.setStringList(_badgesKey, currentBadges);
      // TODO: Trigger badge award event/show notification
    }
  }

  /// Get the list of badge IDs the user has earned.
  static Future<List<String>> getBadges() async {
    final prefs = await _getPrefs();
    return prefs.getStringList(_badgesKey) ?? [];
  }

  /// Check if the user has a specific badge.
  static Future<bool> hasBadge(String badgeId) async {
    final badges = await getBadges();
    return badges.contains(badgeId);
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  /// Reset all progress (XP, level, badges) to initial state.
  /// Useful for testing or if user wants to restart.
  static Future<void> resetProgress() async {
    final prefs = await _getPrefs();
    await prefs.remove(_xpKey);
    await prefs.remove(_levelKey);
    await prefs.remove(_badgesKey);
  }
}