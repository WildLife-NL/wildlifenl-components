import 'package:flutter/material.dart';

/// Kleuren en stijl voor de login-UI. Apps kunnen deze overschrijven.
class LoginTheme {
  const LoginTheme({
    this.primaryColor = const Color(0xFF1C4620),
    this.accentColor = const Color(0xFF5E3E27),
    this.inputBackgroundColor = const Color(0xFFF1F5F2),
    this.errorColor,
  });

  final Color primaryColor;
  final Color accentColor;
  final Color inputBackgroundColor;
  final Color? errorColor;

  Color get effectiveErrorColor => errorColor ?? Colors.red.shade600;
}
