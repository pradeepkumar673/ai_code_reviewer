import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devforge_ai/core/router/app_router.dart';
import 'package:devforge_ai/core/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/creds/.env');
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStatusProvider);

    // Handle auth status to determine initial route
    Widget initialScreen;
    if (authStatus == AuthStatus.loading) {
      initialScreen = const SplashScreen();
    } else if (authStatus == AuthStatus.unauthenticated) {
      initialScreen = const LoginPage();
    } else if (authStatus == AuthStatus.biometricRequired) {
      initialScreen = const BiometricAuthPage();
    } else {
      // Authenticated - go to main app
      initialScreen = MainAppHome();
    }

    return MaterialApp.router(
      title: 'DevForge AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(goRouterProvider),
      // Override initial location based on auth status
      // We'll handle this through redirects in the router or by using a different approach
      // For simplicity, we'll use the router as-is and handle redirects in the router itself
    );
  }
}

/// Splash screen shown while checking auth status
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo/icon
            Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              'DevForge AI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Main app home that uses the router
class MainAppHome extends ConsumerWidget {
  const MainAppHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simply return the router - the router handles navigation
    return ref.watch(goRouterProvider);
  }
}