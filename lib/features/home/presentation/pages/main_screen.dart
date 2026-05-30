import 'package:flutter/material.dart';
import 'package:devforge_ai/core/router/app_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // We'll use a Scaffold with a bottom navigation bar
    // The child parameter will be the actual content from the routes

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(ModalRoute.of(context)?.settings.name),
        onDestinationSelected: (int index) {
          final List<String> routes = ['/chat', '/scanner', '/quality', '/gamification', '/settings'];
          if (index < routes.length) {
            // In a real app, we would use GoRouter here
            // For now, we'll just navigate using Navigator
            // TODO: Implement proper navigation with GoRouter
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

  int _calculateSelectedIndex(String? location) {
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