import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.darkSurface,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge(isDark: true),
        iconTheme: const IconThemeData(
          color: AppColors.darkText,
          size: 24,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(isDark: true),
        displayMedium: AppTextStyles.displayMedium(isDark: true),
        displaySmall: AppTextStyles.displaySmall(isDark: true),
        headlineMedium: AppTextStyles.headlineMedium(isDark: true),
        headlineSmall: AppTextStyles.headlineSmall(isDark: true),
        titleLarge: AppTextStyles.titleLarge(isDark: true),
        titleMedium: AppTextStyles.titleMedium(isDark: true),
        bodyLarge: AppTextStyles.bodyLarge(isDark: true),
        bodyMedium: AppTextStyles.bodyMedium(isDark: true),
        bodySmall: AppTextStyles.bodySmall(isDark: true),
        labelLarge: AppTextStyles.labelLarge(isDark: true),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.accentWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.buttonText(isDark: true),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.buttonText(isDark: true),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCardHover,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        labelStyle: AppTextStyles.bodySmall(isDark: true),
        hintStyle: AppTextStyles.caption(isDark: true),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: AppColors.primaryBlue,
        labelStyle: AppTextStyles.labelMedium(isDark: true),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentRed,
        surface: AppColors.darkSurface,
        background: AppColors.darkBackground,
        error: AppColors.errorRed,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.lightBackground,
      canvasColor: AppColors.lightSurface,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightText,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge(isDark: false),
        iconTheme: const IconThemeData(
          color: AppColors.lightText,
          size: 24,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge(isDark: false),
        displayMedium: AppTextStyles.displayMedium(isDark: false),
        displaySmall: AppTextStyles.displaySmall(isDark: false),
        headlineMedium: AppTextStyles.headlineMedium(isDark: false),
        headlineSmall: AppTextStyles.headlineSmall(isDark: false),
        titleLarge: AppTextStyles.titleLarge(isDark: false),
        titleMedium: AppTextStyles.titleMedium(isDark: false),
        bodyLarge: AppTextStyles.bodyLarge(isDark: false),
        bodyMedium: AppTextStyles.bodyMedium(isDark: false),
        bodySmall: AppTextStyles.bodySmall(isDark: false),
        labelLarge: AppTextStyles.labelLarge(isDark: false),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.accentWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.buttonText(isDark: false),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.buttonText(isDark: false),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCardHover,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        labelStyle: AppTextStyles.bodySmall(isDark: false),
        hintStyle: AppTextStyles.caption(isDark: false),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightCard,
        selectedColor: AppColors.primaryBlue,
        labelStyle: AppTextStyles.labelMedium(isDark: false),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E7EB),
        thickness: 1,
      ),

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.accentRed,
        surface: AppColors.lightSurface,
        background: AppColors.lightBackground,
        error: AppColors.errorRed,
      ),
    );
  }
}