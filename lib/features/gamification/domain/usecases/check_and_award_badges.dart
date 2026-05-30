import 'package:devforge_ai/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:devforge_ai/features/gamification/domain/usecases/get_gamification_progress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Use case for checking and awarding badges
class CheckAndAwardBadges {
  final GamificationRepository repository;

  CheckAndAwardBadges(this.repository);

  /// Check and award badges based on progress
  Future<List<String>> call() async {
    return await repository.checkAndAwardBadges();
  }
}

/// Riverpod provider for the CheckAndAwardBadges use case
final checkAndAwardBadgesProvider = Provider<CheckAndAwardBadges>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return CheckAndAwardBadges(repository);
});