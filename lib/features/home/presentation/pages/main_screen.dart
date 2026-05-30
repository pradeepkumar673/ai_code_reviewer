import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:devforge_ai/core/router/app_router.dart';

class MainScreen extends ConsumerWidget {
  final Widget child;
  final String location;

  const MainScreen({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate selected index based on location
    int selectedIndex = _calculateSelectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          final List<String> routes = ['/chat', '/scanner', '/quality', '/gamification', '/settings'];
          if (index < routes.length) {
            // Use GoRouter for navigation
            context.go(routes[index]);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Scanner',
          ),
          NavigationDestination(
            icon: Icon(Icons.code_outlined),
            label: 'Quality',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border), // Using star instead of trophy
            label: 'Gamification',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    switch (location) {
      case '/chat':
        return 0;
      case '/scanner':
        return 1;
      case '/quality':
        return 2;
      case '/gamification':
        return 3;
      case '/settings':
        return 4;
      default:
        return 0; // Default to chat
    }
  }
}