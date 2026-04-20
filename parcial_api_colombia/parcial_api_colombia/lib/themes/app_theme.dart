import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF005792);
  static const Color primaryVariant = Color(0xFF003F63);
  static const Color secondary = Color(0xFFFFC857);
  static const Color accent = Color(0xFF2EC4B6);
  static const Color background = Color(0xFFF6F8FA);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      error: AppColors.error,
      onError: Colors.white,
      background: AppColors.background,
      onBackground: Colors.black87,
      surface: AppColors.surface,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 14),
      bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
    ),
  );
}

// Export common paddings and shapes
class AppStyles {
  static const double padding = 16.0;
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(12));
}
