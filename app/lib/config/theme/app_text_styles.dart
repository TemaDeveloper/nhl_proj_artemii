import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Display Styles
  static TextStyle displayLarge({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle displayMedium({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle displaySmall({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  // Headline Styles
  static TextStyle headlineMedium({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle headlineSmall({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  // Title Styles
  static TextStyle titleLarge({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle titleMedium({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle titleSmall({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      );

  // Body Styles
  static TextStyle bodyLarge({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle bodyMedium({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      );

  static TextStyle bodySmall({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      );

  // Label Styles
  static TextStyle labelLarge({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle labelMedium({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle labelSmall({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      );

  // Custom Styles for Game Scores
  static TextStyle gameLargeScore({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle gameTeamName({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle gameStatus({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.scheduledGrey,
      );

  static TextStyle gameLiveStatus({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.liveRed,
      );

  // Custom Styles for Team Info
  static TextStyle teamTitle({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle teamRecord({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      );

  // Button Text Styles
  static TextStyle buttonText({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.accentWhite,
      );

  static TextStyle buttonSmall({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.accentWhite,
      );

  // Caption Styles
  static TextStyle caption({required bool isDark}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
      );

  // Helper method to get theme-aware text style
  static TextStyle getStyle(
    double fontSize,
    FontWeight fontWeight,
    Color color,
  ) =>
      GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
}