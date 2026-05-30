import 'package:devforge_ai/features/gamification/domain/entities/gamification_progress.dart';
import 'package:devforge_ai/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:devforge_ai/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Use case for getting gamification progress
class GetGamificationProgress {
  final GamificationRepository repository;

  GetGamificationProgress(this.repository);

  /// Get the current gamification progress
  Future<GamificationProgress> call() async {
    return await repository.getGamificationProgress();
  }
}

/// Use case for earning XP
class EarnXP {
  final GamificationRepository repository;

  EarnXP(this.repository);

  /// Earn XP for an action
  Future<void> call(String action, int xpAmount) async {
    await repository.earnXP(action, xpAmount);
  }
}

/// Use case for checking and awarding badges
class CheckAndAwardBadges {
  final GamificationRepository repository;

  CheckAndAwardBadges(this.repository);

  /// Check and award badges based on progress
  Future<List<String>> call() async {
    return await repository.checkAndAwardBadges();
  }
}

/// Use case for resetting daily progress
class ResetDailyProgress {
  final GamificationRepository repository;

  ResetDailyProgress(this.repository);

  /// Reset daily progress
  Future<void> call() async {
    await repository.resetDailyProgress();
  }
}

/// Riverpod provider for the GetGamificationProgress use case
final getGamificationProgressProvider = Provider<GetGamificationProgress>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return GetGamificationProgress(repository);
});

/// Riverpod provider for the EarnXP use case
final earnXPProvider = Provider<EarnXP>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return EarnXP(repository);
});

/// Riverpod provider for the CheckAndAwardBadges use case
final checkAndAwardBadgesProvider = Provider<CheckAndAwardBadges>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return CheckAndAwardBadges(repository);
});

/// Riverpod provider for the ResetDailyProgress use case
final resetDailyProgressProvider = Provider<ResetDailyProgress>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return ResetDailyProgress(repository);
});

/// Provider for the GamificationRepository
final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return GamificationRepositoryImpl();
});