import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._(); 

  static const Duration refreshIndicatorDelay = Duration(milliseconds: 500);

  // Icon Sizes
  static const double emptyStateIconSize = 64.0;
  static const double errorStateIconSize = 64.0;

  // Padding & Spacing
  static const double defaultPadding = 32.0;
  static const double defaultVerticalPadding = 20.0;
  static const double cardPadding = 8.0;
  static const double bottomPadding = 16.0;
  static const double standardGap = 8.0;
  static const double largeGap = 16.0;
  static const double xlargeGap = 24.0;

  // List View
  static const EdgeInsets listViewPadding = EdgeInsets.only(
    top: cardPadding,
    bottom: bottomPadding,
  );

  // AppBar
  static const double appBarElevation = 0.0;

  // Border Radius
  static const double borderRadius = 8.0;
}
