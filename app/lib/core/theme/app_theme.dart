import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._(); 

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        surface: AppColors.surface,
        onSurface: AppColors.black,
        error: AppColors.error,
        onError: AppColors.white,
        background: AppColors.background,
        onBackground: AppColors.black,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text Themes
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),

      // Input Decoration (TextField/TextFormField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.mediumGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.mediumGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.labelMedium,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.mediumGrey,
        thickness: 1,
        space: 16,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightGrey,
        disabledColor: AppColors.mediumGrey,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        labelStyle: AppTextStyles.labelMedium,
        secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.white,
        ),
        brightness: Brightness.light,
        side: const BorderSide(color: AppColors.mediumGrey),
      ),

      // FloatingActionButton Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearMinHeight: 4,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.charcoal,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        elevation: 2,
        height: 64,
        labelTextStyle: MaterialStateProperty.all(
          AppTextStyles.labelSmall,
        ),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 28);
          }
          return const IconThemeData(color: AppColors.grey, size: 24);
        }),
      ),
    );
  }

  /// Dark theme data for the app (optional)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.black,
      
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.black,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.black,
        surface: AppColors.charcoal,
        onSurface: AppColors.white,
        error: AppColors.error,
        onError: AppColors.black,
        background: AppColors.black,
        onBackground: AppColors.white,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.charcoal,
        foregroundColor: AppColors.white,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: AppColors.white,
        ),
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.white),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.white),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.white),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.white),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.lightGrey),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.lightGrey),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGrey),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.lightGrey),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.grey),
      ),

      cardTheme: CardThemeData(
        color: AppColors.charcoal,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.black,
      ),
    );
  }
}
