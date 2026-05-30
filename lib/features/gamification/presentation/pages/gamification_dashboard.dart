import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devforge_ai/core/widgets/custom_app_bar.dart';
import 'package:devforge_ai/core/widgets/custom_button.dart';
import 'package:devforge_ai/features/gamification/domain/entities/gamification_progress.dart';
import 'package:devforge_ai/features/gamification/domain/usecases/get_gamification_progress.dart';
import 'package:devforge_ai/features/gamification/domain/usecases/earn_xp.dart';
import 'package:devforge_ai/features/gamification/domain/usecases/check_and_award_badges.dart';
import 'package:devforge_ai/core/providers/app_providers.dart';

class GamificationDashboard extends ConsumerStatefulWidget {
  const GamificationDashboard({super.key});

  @override
  ConsumerState<GamificationDashboard> createState() => _GamificationDashboardState();
}

class _GamificationDashboardState extends ConsumerState<GamificationDashboard> {
  @override
  void initState() {
    super.initState();
    // Award XP for visiting the dashboard (example)
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(earnXPProvider)('visited_dashboard', 10);
    // });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncProgress = ref.watch(getGamificationProgressProvider);

    return asyncProgress.when(
      data: (progress) => _buildDashboard(context, theme, progress),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading gamification data: $error'),
      ),
    );
  }

  Widget _buildDashboard(
      BuildContext context,
      ThemeData theme,
      GamificationProgress progress,
      ) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gamification Dashboard',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              // Refresh the progress
              ref.refresh(getGamificationProgressProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with XP and Level
            _buildHeader(theme, progress),

            const SizedBox(height: 24),

            // Level Progress Bar
            _buildLevelProgressBar(theme, progress),

            const SizedBox(height: 24),

            // Badges Section
            _buildBadgesSection(theme, progress.badges),

            const SizedBox(height: 24),

            // Daily Quest Section
            _buildDailyQuestSection(theme, progress),

            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, GamificationProgress progress) {
    return Row(
      children: [
        // XP and Level
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level ${progress.level}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${progress.totalXP} XP',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // XP Icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star,
            color: theme.colorScheme.onPrimaryContainer,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelProgressBar(ThemeData theme, GamificationProgress progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level Progress',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          // Progress bar container
          LayoutBuilder(
            builder: (context, constraints) {
              final progressPercent = progress.levelProgressPercent / 100;
              final barWidth = constraints.maxWidth;
              return Stack(
                children: [
                  // Background track
                  Container(
                    width: barWidth,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Progress fill
                  Container(
                    width: barWidth * progressPercent,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Progress text
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        '${progress.levelProgressPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          // Level info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level ${progress.level}',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                'Level ${progress.level + 1}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(ThemeData theme, List<String> badges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Badges Earned',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        badges.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'No badges earned yet!\nKeep using the app to earn badges.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        )
            : Wrap(
          spacing: 12,
          runSpacing: 12,
          children: badges.map((badgeId) {
            // In a real app, we'd map badgeId to actual badge names/icons
            final badgeName = _getBadgeName(badgeId);
            final badgeIcon = _getBadgeIcon(badgeId);
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    badgeIcon,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badgeName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDailyQuestSection(
      ThemeData theme,
      GamificationProgress progress,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Quest',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                '${progress.dailyXPEarned}/${progress.dailyXPGoal} XP',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Daily progress bar
          LayoutBuilder(
            builder: (context, constraints) {
              final progressPercent =
                  progress.dailyXPEarned / progress.dailyXPGoal;
              final barWidth = constraints.maxWidth;
              return Stack(
                children: [
                  // Background track
                  Container(
                    width: barWidth,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Progress fill
                  Container(
                    width: barWidth * progressPercent.clamp(0.0, 1.0),
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Streak: ${progress.dailyQuestStreak} days',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildQuickActionButton(
              context,
              'Scan Code',
              Icons.camera_alt,
                  () {
                // TODO: Navigate to scanner page
                // For now, show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to Scanner')),
                );
              },
            ),
            _buildQuickActionButton(
              context,
              'Analyze Code',
              Icons.insights,
                  () {
                // TODO: Navigate to quality scorer page
                // For now, show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to Quality Scorer')),
                );
              },
            ),
            _buildQuickActionButton(
              context,
              'Start Chat',
              Icons.chat_bubble,
                  () {
                // TODO: Navigate to chat page
                // For now, show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigate to Chat')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 40),
      ),
    );
  }

  String _getBadgeName(String badgeId) {
    // Map badge IDs to human-readable names
    switch (badgeId) {
      case 'first_scan':
        return 'First Scan';
      case 'first_analysis':
        return 'First Analysis';
      case 'chat_starter':
        return 'Chat Starter';
      case 'xp_beginner':
        return 'XP Beginner';
      case 'daily_quester':
        return 'Daily Quester';
      case 'level_up':
        return 'Level Up';
      default:
        return badgeId.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join(' ');
    }
  }

  IconData _getBadgeIcon(String badgeId) {
    // Map badge IDs to icons
    switch (badgeId) {
      case 'first_scan':
        return Icons.camera_alt;
      case 'first_analysis':
        return Icons.insights;
      case 'chat_starter':
        return Icons.chat_bubble;
      case 'xp_beginner':
        return Icons.star;
      case 'daily_quester':
        return Icons.calendar_today;
      case 'level_up':
        return Icons.trending_up;
      default:
        return Icons.help;
    }
  }
}