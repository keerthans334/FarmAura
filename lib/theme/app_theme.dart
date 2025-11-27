import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFFFAFAF5);
  static const Color primary = Color(0xFF43A047);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color accent = Color(0xFFFFC107);
  static const Color muted = Color(0xFF757575);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE8F5E9);
}

LinearGradient primaryGradient() => const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryDark],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

ThemeData buildAppTheme() {
  final baseText = GoogleFonts.notoSansTextTheme();
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
      surface: AppColors.background,
      primary: AppColors.primary,
      secondary: AppColors.accent,
    ),
    textTheme: baseText.copyWith(
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
      headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
      headlineSmall: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
      titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
      bodyMedium: GoogleFonts.notoSans(fontSize: 14, color: AppColors.primaryDark),
      bodySmall: GoogleFonts.notoSans(fontSize: 12, color: AppColors.muted),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primaryDark,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFAFAF5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.muted),
    ),
  );
}
