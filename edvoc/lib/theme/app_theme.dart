import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF2196F3); // Simple blue
  static const Color secondary = Color(0xFF64B5F6); // Lighter blue
  static const Color accent = Color(0xFF90CAF9); // Very light blue
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE57373); // Light red
  static const Color text = Color(0xFF333333); // Dark gray
  static const Color textLight = Color(0xFF666666); // Medium gray

  static ThemeData get theme => ThemeData(
    primaryColor: primary,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: surface,
      background: background,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: text,
      onBackground: text,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      elevation: 1, // Reduced elevation
    ),
    cardTheme: CardTheme(
      elevation: 2, // Reduced elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), // Smaller radius
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary, // Using primary instead of secondary
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Smaller radius
        ),
      ),
    ),
  );
}
