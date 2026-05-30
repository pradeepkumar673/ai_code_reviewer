import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Button widget with consistent styling
class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Creates an outlined button variant
  factory CustomButton.outlined({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool fullWidth = false,
  }) {
    return CustomButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimary;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton.icon(
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : icon != null
                ? Icon(icon, color: fgColor, size: 20)
                : null,
        label: isLoading
            ? const Text('')
            : Text(
                text,
                style: GoogleFonts.sourceCodePro(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: bgColor.withOpacity(0.5),
          disabledForegroundColor: fgColor.withOpacity(0.5),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}