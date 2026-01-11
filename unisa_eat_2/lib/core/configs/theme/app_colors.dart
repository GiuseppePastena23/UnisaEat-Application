import 'package:flutter/material.dart';



abstract class AppColors {
  // Shared brand colors (orange accents)
  static const Color primary = Color(0xFFFFB91A);      // Orange primary
  static const Color primaryLight = Color(0xFFF47B25);
  static const Color primaryDark = Color(0xFFDA8404);

  // Dark theme tokens (dark purple background, white text, orange accents)
  static const Color darkBackground = Color(0xFF1A1523);      // Dark purple background
  static const Color darkSurface = Color(0xFF2C253A);         // Surface
  static const Color darkTextHeadings = Color(0xFFFFFFFF);    // White headings
  static const Color darkTextBody = Color(0xFFD9D4E4);        // Light gray body
  static const Color darkSecondaryAccent = Color(0xFFFFB91A); // Orange accent

  // Light theme tokens (dark purple text, orange and light purple accents)
  static const Color lightBackground = Color(0xFFF8F7F5);     // Light background
  static const Color lightSurface = Color(0xFFFFFFFF);        // White surface
  static const Color lightTextHeadings = Color(0xFF4C3B70);   // Dark purple headings
  static const Color lightTextBody = Color(0xFF5533A0);       // Dark purple body
  static const Color lightSecondaryAccent = Color(0xFF8B5CF6);// Light purple accent

  // Extra helpers for specific elements
  static const Color balanceIconBackground = Color(0xFFF5ECD5);
}

