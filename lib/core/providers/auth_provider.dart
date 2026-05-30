import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  biometricRequired,
}

/// Provider for authentication status
final authStatusProvider = StateProvider<AuthStatus>((ref) => AuthStatus.unknown);