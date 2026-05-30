import 'package:devforge_ai/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:devforge_ai/features/gamification/domain/usecases/get_gamification_progress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Use case for earning XP
class EarnXP {
  final GamificationRepository repository;

  EarnXP(this.repository);

  /// Earn XP for an action
  Future<void> call(String action, int xpAmount) async {
    await repository.earnXP(action, xpAmount);
  }
}

/// Riverpod provider for the EarnXP use case
final earnXPProvider = Provider<EarnXP>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return EarnXP(repository);
});