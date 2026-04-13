import 'package:flutter/material.dart';

class AppColors {
  static const thread = Color(0xFF2C1A0E);
  static const sand = Color(0xFFF5F0E8);
  static const cream = Color(0xFFFAF7F2);
  static const gold = Color(0xFFC9973A);
  static const silk = Color(0xFF8B5E3C);
  static const taupe = Color(0xFF9A8F82);
  static const accent = Color(0xFFD4A853);

  static const badgeGreenBg = Color(0xFFEAF3DE);
  static const badgeGreenText = Color(0xFF3B6D11);
  static const badgeAmberBg = Color(0xFFFAEEDA);
  static const badgeAmberText = Color(0xFF854F0B);
  static const badgeBlueBg = Color(0xFFE6F1FB);
  static const badgeBlueText = Color(0xFF185FA5);
  static const badgeRedBg = Color(0xFFFCEBEB);
  static const badgeRedText = Color(0xFFA32D2D);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: 'DM Sans',
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.gold,
          primary: AppColors.thread,
          secondary: AppColors.gold,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.thread,
          foregroundColor: AppColors.cream,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.cream,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.thread,
            foregroundColor: AppColors.cream,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontFamily: 'DM Sans', fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.thread,
            side: const BorderSide(color: AppColors.thread, width: 0.5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontFamily: 'DM Sans', fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x33000000), width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x33000000), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.gold, width: 1),
          ),
          labelStyle: const TextStyle(color: AppColors.taupe, fontSize: 13),
          hintStyle: const TextStyle(color: AppColors.taupe, fontSize: 13),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black.withOpacity(0.08), width: 0.5),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.black.withOpacity(0.15), width: 0.5),
          labelStyle: const TextStyle(fontSize: 12, color: AppColors.taupe),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
}
