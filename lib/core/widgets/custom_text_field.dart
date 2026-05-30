import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.maxLines = 1,
    this.onSubmitted,
    this.obscureText = false,
    this.validator,
    this.decoration,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
            filled: true,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
      maxLines: maxLines,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      readOnly: readOnly,
      validator: validator,
    );
  }
}