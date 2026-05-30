import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devforge_ai/core/services/auth_service.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  biometricRequired,
  loading,
}

/// Notifier for authentication status
class AuthStatusNotifier extends StateNotifier<AuthStatus> {
  final AuthService _authService;

  AuthStatusNotifier(this._authService) : super(AuthStatus.unknown) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = AuthStatus.loading;
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (!isLoggedIn) {
        state = AuthStatus.unauthenticated;
        return;
      }

      final isBiometricAvailable = await _authService.isBiometricAvailable();
      final isBiometricEnabled = await _authService.isBiometricEnabled();

      if (isBiometricAvailable && isBiometricEnabled) {
        state = AuthStatus.biometricRequired;
      } else {
        state = AuthStatus.authenticated;
      }
    } catch (e) {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<void> login() async {
    state = AuthStatus.loading;
    try {
      await _authService.login();
      final isBiometricAvailable = await _authService.isBiometricAvailable();
      final isBiometricEnabled = await _authService.isBiometricEnabled();
      if (isBiometricAvailable && isBiometricEnabled) {
        state = AuthStatus.biometricRequired;
      } else {
        state = AuthStatus.authenticated;
      }
    } catch (e) {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthStatus.unauthenticated;
  }

  Future<void> toggleBiometric(bool enabled) async {
    await _authService.setBiometricEnabled(enabled);
    if (state == AuthStatus.authenticated) {
      final isBiometricAvailable = await _authService.isBiometricAvailable();
      if (isBiometricAvailable && enabled) {
        state = AuthStatus.biometricRequired;
      } else {
        state = AuthStatus.authenticated;
      }
    }
  }
}

/// Provider for authentication status
final authStatusProvider =
    StateNotifierProvider<AuthStatusNotifier, AuthStatus>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthStatusNotifier(authService);
});