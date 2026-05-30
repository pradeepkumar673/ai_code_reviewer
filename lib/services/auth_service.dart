import 'package:local_auth/local_auth.dart';
import '../models/user.dart';
import '../repos/chat_repo.dart';
import 'package:uuid/uuid.dart';

/// AuthService
/// Provides all authentication-related static methods used across the app.
class AuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // ── Session check ──────────────────────────────────────────────────────────

  static Future<bool> isLoggedIn() async {
    final user = await SecureStorageService.getCurrentUser();
    return user != null;
  }

  // ── Biometric availability ─────────────────────────────────────────────────

  /// Returns true when the device hardware supports biometrics AND
  /// at least one biometric (fingerprint / face) is enrolled.
  static Future<bool> isBiometricAvailable() async {
    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      if (!isDeviceSupported) return false;

      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return false;

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ── Authentication ─────────────────────────────────────────────────────────

  /// Used by BiometricAuthPage on app launch.
  static Future<bool> login() async {
    return authenticateWithBiometrics(
      reason: 'Please authenticate to access DevForge AI',
    );
  }

  /// Used by SettingsPage when the user toggles biometric ON.
  static Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to continue',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // ── User creation ──────────────────────────────────────────────────────────

  /// Called by LoginPage when a new user registers.
  static Future<void> createUser({
    required String name,
    required String email,
    String? profileImagePath,
  }) async {
    final now = DateTime.now();
    final user = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
      profileImagePath: profileImagePath,
      createdAt: now,
      lastLoginAt: now,
    );
    await SecureStorageService.saveUser(user);
  }

  // ── Last-login timestamp ───────────────────────────────────────────────────

  /// Called by BiometricAuthPage after a successful skip/bypass.
  static Future<void> updateLastLogin(User user) async {
    final updated = user.copyWith(lastLoginAt: DateTime.now());
    await SecureStorageService.saveUser(updated);
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  static Future<void> logout() async {
    await SecureStorageService.clearAll();
  }
}
