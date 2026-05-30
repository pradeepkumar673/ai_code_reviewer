import 'package:devforge_ai/features/gamification/domain/entities/gamification_progress.dart';

abstract class GamificationRepository {
  /// Gets the current gamification progress
  Future<GamificationProgress> getGamificationProgress();

  /// Earns XP for an action
  Future<void> earnXP(String action, int xpAmount);

  /// Checks and awards badges based on progress
  Future<List<String>> checkAndAwardBadges();

  /// Resets daily XP and quests (called at midnight or when day changes)
  Future<void> resetDailyProgress();
}