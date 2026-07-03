import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Palette
  static const primary = Color(0xFF2563EB); // Royal Blue
  static const secondary = Color(0xFF4F46E5); // Indigo
  static const accent = Color(0xFF10B981); // Emerald Green
  
  // Backgrounds
  static const background = Color(0xFFF8FAFC);
  static const cardBackground = Colors.white;
  static const darkBackground = Color(0xFF0F172A);
  static const darkCardBackground = Color(0xFF1E293B);

  // Typography
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const textPrimaryDark = Color(0xFFF1F5F9);
  static const textSecondaryDark = Color(0xFF94A3B8);

  // States
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);
  
  // Badges (kept for backward compatibility with older components)
  static const badgeGreenBg = Color(0xFFD1FAE5);
  static const badgeGreenText = Color(0xFF065F46);
  static const badgeAmberBg = Color(0xFFFEF3C7);
  static const badgeAmberText = Color(0xFF92400E);
  static const badgeBlueBg = Color(0xFFDBEAFE);
  static const badgeBlueText = Color(0xFF1E40AF);
  static const badgeRedBg = Color(0xFFFEE2E2);
  static const badgeRedText = Color(0xFF991B1B);
}

class AppTheme {
  static ThemeData get light {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.cardBackground,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(color: AppColors.textPrimary),
        displayMedium: baseTextTheme.displayMedium?.copyWith(color: AppColors.textPrimary),
        displaySmall: baseTextTheme.displaySmall?.copyWith(color: AppColors.textPrimary),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: AppColors.textPrimary),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: AppColors.textPrimary),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleLarge: baseTextTheme.titleLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: baseTextTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        titleSmall: baseTextTheme.titleSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.2), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 14),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black.withOpacity(0.05), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardBackground,
        side: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
        labelStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.textSecondary.withOpacity(0.1),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get dark {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.darkCardBackground,
        error: AppColors.error,
        brightness: Brightness.dark,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: baseTextTheme.displayMedium?.copyWith(color: AppColors.textPrimaryDark),
        displaySmall: baseTextTheme.displaySmall?.copyWith(color: AppColors.textPrimaryDark),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: AppColors.textPrimaryDark),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600),
        titleLarge: baseTextTheme.titleLarge?.copyWith(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600),
        titleMedium: baseTextTheme.titleMedium?.copyWith(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w500),
        titleSmall: baseTextTheme.titleSmall?.copyWith(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w500),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: AppColors.textSecondaryDark),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: AppColors.textSecondaryDark),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryDark,
          side: const BorderSide(color: AppColors.textPrimaryDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCardBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textSecondaryDark.withOpacity(0.2), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.textSecondaryDark.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondaryDark, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: AppColors.textSecondaryDark.withOpacity(0.5), fontSize: 14),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCardBackground,
        side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        labelStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textPrimaryDark, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.textSecondaryDark.withOpacity(0.1),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
