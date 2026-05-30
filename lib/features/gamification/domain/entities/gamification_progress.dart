/// Model representing user's gamification progress
class GamificationProgress {
  final int totalXP;
  final int level;
  final int xpToNextLevel;
  final List<String> badges;
  final int dailyQuestStreak;
  final int dailyXPEarned;
  final int dailyXPGoal;

  const GamificationProgress({
    required this.totalXP,
    required this.level,
    required this.xpToNextLevel,
    required this.badges,
    required this.dailyQuestStreak,
    required this.dailyXPEarned,
    required this.dailyXPGoal,
  });

  /// Calculates the percentage progress to next level
  double get levelProgressPercent {
    if (xpToNextLevel == 0) return 100.0;
    return ((totalXP % (level * 100)) / (level * 100)) * 100;
  }

  /// Creates a GamificationProgress from a map (for storage)
  factory GamificationProgress.fromMap(Map<String, dynamic> map) {
    return GamificationProgress(
      totalXP: map['totalXP'] ?? 0,
      level: map['level'] ?? 1,
      xpToNextLevel: map['xpToNextLevel'] ?? 100,
      badges: List<String>.from(map['badges'] ?? []),
      dailyQuestStreak: map['dailyQuestStreak'] ?? 0,
      dailyXPEarned: map['dailyXPEarned'] ?? 0,
      dailyXPGoal: map['dailyXPGoal'] ?? 100,
    );
  }

  /// Converts to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'totalXP': totalXP,
      'level': level,
      'xpToNextLevel': xpToNextLevel,
      'badges': badges,
      'dailyQuestStreak': dailyQuestStreak,
      'dailyXPEarned': dailyXPEarned,
      'dailyXPGoal': dailyXPGoal,
    };
  }

  /// Creates an empty progress state
  factory GamificationProgress.empty() {
    return const GamificationProgress(
      totalXP: 0,
      level: 1,
      xpToNextLevel: 100,
      badges: [],
      dailyQuestStreak: 0,
      dailyXPEarned: 0,
      dailyXPGoal: 100,
    );
  }
}