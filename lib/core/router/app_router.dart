import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:devforge_ai/features/auth/presentation/pages/login_page.dart';
import 'package:devforge_ai/features/auth/presentation/pages/biometric_auth_page.dart';
import 'package:devforge_ai/features/home/presentation/pages/main_screen.dart';
import 'package:devforge_ai/features/chat/presentation/pages/chat_page.dart';
import 'package:devforge_ai/features/camera_scanner/presentation/pages/scanner_page.dart';
import 'package:devforge_ai/features/code_quality/presentation/pages/quality_scorer_page.dart';
import 'package:devforge_ai/features/gamification/presentation/pages/gamification_dashboard.dart';
import 'package:devforge_ai/features/hackathon_co_pilot/presentation/pages/hackathon_co_pilot_page.dart';
import 'package:devforge_ai/features/voice_io/presentation/pages/voice_io_page.dart';
import 'package:devforge_ai/features/skill_tracker/presentation/pages/skill_tracker_page.dart';
import 'package:devforge_ai/features/interview_prep/presentation/pages/interview_prep_page.dart';
import 'package:devforge_ai/features/resume_analyzer/presentation/pages/resume_analyzer_page.dart';
import 'package:devforge_ai/features/snippet_library/presentation/pages/snippet_library_page.dart';
import 'package:devforge_ai/features/settings/presentation/pages/settings_page.dart';

/// App router using GoRouter for navigation
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/chat',
    debugLogDiagnostics: true,
    routes: [
      // Home screen with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainScreen(
          child: child,
          location: state.location,
        ),
        routes: [
          // Chat
          GoRoute(
            path: '/chat',
            name: 'chat',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatPage(),
            ),
          ),
          // Scanner
          GoRoute(
            path: '/scanner',
            name: 'scanner',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ScannerPage(),
            ),
          ),
          // Code Quality
          GoRoute(
            path: '/quality',
            name: 'quality',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: QualityScorerPage(),
            ),
          ),
          // Gamification
          GoRoute(
            path: '/gamification',
            name: 'gamification',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GamificationDashboard(),
            ),
          ),
          // Settings
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
          // ... other feature routes will be added similarly
        ],
      ),
      // Auth screens (full screen, not in shell)
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: '/biometric',
        name: 'biometric',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: BiometricAuthPage(),
        ),
      ),
      // ... other full-screen routes (like onboarding, etc.)
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
});

/// Helper class for transitions (we're using no transition for simplicity)
class NoTransitionPage extends CustomTransitionPage<void> {
  const NoTransitionPage({required Widget child})
      : super(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          child: child,
        );
}