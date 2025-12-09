import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFF1F4788); // Deep Blue (NHL)
  static const Color primaryLight = Color(0xFF2E5CB8);
  static const Color primaryDark = Color(0xFF152C52);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B35); // Orange (Energy)
  static const Color secondaryLight = Color(0xFFFF8555);
  static const Color secondaryDark = Color(0xFFE55A25);

  // Accent Colors
  static const Color accent = Color(0xFF00D4FF); // Cyan
  static const Color accentLight = Color(0xFF33E0FF);
  static const Color accentDark = Color(0xFF00B8D4);

  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningDark = Color(0xFFFFA000);

  static const Color error = Color(0xFFF44336); // Red
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFDD33B30);

  static const Color info = Color(0xFF2196F3); // Blue
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  static const Color winColor = Color(0xFF4CAF50); 
  static const Color lossColor = Color(0xFFF44336); 

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFE0E0E0);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF616161);
  static const Color charcoal = Color(0xFF424242);
  static const Color black = Color(0xFF212121);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Game Status Colors
  static const Color gameLive = Color(0xFFFF6B6B); // Live game
  static const Color gameScheduled = Color(0xFF4ECDC4); // Scheduled
  static const Color gameFinal = Color(0xFF95E1D3); // Final

  static const Color tieColor = Color(0xFF9E9E9E); // Grey for ties/OT

  // Home/Away Colors
  static const Color homeTeam = Color(0xFF1F4788); // Blue
  static const Color awayTeam = Color(0xFFFF6B35); // Orange
}
