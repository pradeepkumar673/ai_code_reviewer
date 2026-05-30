import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devforge_ai/core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/creds/.env');
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isInitialized = false;
  bool _isLoggedIn = false;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // For now, we'll simulate auth status
    // In a real app, this would check secure storage
    final isLoggedIn = true; // Simulate logged in for testing
    if (isLoggedIn) {
      final isBiometricEnabled = true; // Simulate biometric enabled
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
          _isBiometricEnabled = isBiometricEnabled;
          _isInitialized = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!_isInitialized) {
      return const SplashScreen();
    }

    if (!_isLoggedIn) {
      return const SplashScreen(); // Temporarily show splash until auth is implemented
    }

    // If logged in, check if biometric is enabled and required
    if (_isBiometricEnabled) {
      // We need to check if biometric is enabled in settings
      // For now, we'll always require biometric if available
      return const SplashScreen(); // Temporarily show splash until biometric is implemented
    }

    // If biometric is not enabled or not required, go to main screen
    return MaterialApp(
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
      home: ref.read(goRouterProvider),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(height: 24),
            Text(
              'DevForge AI',
              style: GoogleFonts.sourceCodePro(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}