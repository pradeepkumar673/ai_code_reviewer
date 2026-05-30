import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:devforge_ai/core/services/secure_storage_service.dart' as secure_storage;
import 'package:devforge_ai/services/auth_service.dart';
import 'package:devforge_ai/services/theme_provider.dart';
import 'package:devforge_ai/repos/chat_repo.dart';
import 'package:devforge_ai/models/user.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  User? _currentUser;
  bool _biometricEnabled = false;
  bool _isBiometricAvailable = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkBiometricSettings();
  }

  Future<void> _loadUserData() async {
    final user = await secure_storage.SecureStorageService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _checkBiometricSettings() async {
    final isAvailable = await AuthService.isBiometricAvailable();
    final isEnabled = await secure_storage.SecureStorageService.isBiometricEnabled();
    setState(() {
      _isBiometricAvailable = isAvailable;
      _biometricEnabled = isEnabled;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value && _isBiometricAvailable) {
      // Test biometric authentication before enabling
      final success = await AuthService.authenticateWithBiometrics();
      if (success) {
        await secure_storage.SecureStorageService.setBiometricEnabled(true);
        setState(() {
          _biometricEnabled = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication enabled'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      await secure_storage.SecureStorageService.setBiometricEnabled(false);
      setState(() {
        _biometricEnabled = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication disabled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _updateProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
      imageQuality: 80,
    );

    if (pickedFile != null && _currentUser != null) {
      setState(() {
        _loading = true;
      });

      try {
        final updatedUser = _currentUser!.copyWith(
          profileImagePath: pickedFile.path,
        );
        await secure_storage.SecureStorageService.saveUser(updatedUser);
        setState(() {
          _currentUser = updatedUser;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update profile picture: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _clearChatHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242A38),
        title: Text(
          'Clear Chat History',
          style: GoogleFonts.sourceCodePro(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete all chat sessions? This action cannot be undone.',
          style: GoogleFonts.sourceCodePro(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.sourceCodePro(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Clear All',
              style: GoogleFonts.sourceCodePro(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await secure_storage.SecureStorageService.saveChatSessions([]);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chat history cleared'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeProvider.notifier).isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.sourceCodePro(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary,
                      backgroundImage: _currentUser?.profileImagePath != null
                          ? FileImage(File(_currentUser!.profileImagePath!))
                          : null,
                      child: _currentUser?.profileImagePath == null
                          ? Text(
                              _currentUser?.name
                                      .substring(0, 1)
                                      .toUpperCase() ??
                                  'U',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _loading ? null : _updateProfilePicture,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: theme.colorScheme.surface, width: 2),
                          ),
                          child: _loading
                              ? SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                )
                              : Icon(
                                  Iconsax.camera,
                                  color: theme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _currentUser?.name ?? 'User',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  _currentUser?.email ?? '',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Security Section
          Text(
            'Security',
            style: GoogleFonts.sourceCodePro(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12);
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Iconsax.finger_scan,
                    color: _isBiometricAvailable
                        ? const Color(0xFF6366F1)
                        : Colors.grey,
                  ),
                  title: Text(
                    'Biometric Authentication',
                    style: GoogleFonts.sourceCodePro(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    _isBiometricAvailable
                        ? 'Use fingerprint or face unlock'
                        : 'Not available on this device',
                    style: GoogleFonts.sourceCodePro(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  trailing: Switch(
                    value: _biometricEnabled && _isBiometricAvailable,
                    onChanged: _isBiometricAvailable ? _toggleBiometric : null,
                    activeThumbColor: const Color(0xFF6366F1),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                ListTile(
                  leading: Icon(
                    isDarkMode ? Iconsax.moon : Iconsax.sun_1,
                    color: const Color(0xFF6366F1),
                  ),
                  title: Text(
                    'Light Theme',
                    style: GoogleFonts.sourceCodePro(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    isDarkMode
                        ? 'Dark mode is enabled'
                        : 'Light mode is enabled',
                    style: GoogleFonts.sourceCodePro(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  trailing: Switch(
                    value: !isDarkMode, // ON = light mode
                    onChanged: (value) {
                      if (value) {
                        // Switch to light mode
                        ref.read(themeProvider.notifier).toggleTheme();
                      } else {
                        // Switch to dark mode
                        ref.read(themeProvider.notifier).toggleTheme();
                      }
                    },
                    activeThumbColor: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data Section
          Text(
            'Data',
            style: GoogleFonts.sourceCodePro(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12);
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Iconsax.trash, color: Colors.red),
                  title: Text(
                    'Clear Chat History',
                    style: GoogleFonts.sourceCodePro(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Delete all saved conversations',
                    style: GoogleFonts.sourceCodePro(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  onTap: _clearChatHistory,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}