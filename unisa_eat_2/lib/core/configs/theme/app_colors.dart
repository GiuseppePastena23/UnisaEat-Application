import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppColors {
  // Shared brand colors (from both themes)
  static const Color primary = Color(0xFFF9A826);      
  static const Color primaryLight = Color(0xFFF47B25); 
  static const Color primaryDark = Color(0xFFf97316);

  // Dark theme tokens 
  static const Color darkBackground = Color(0xFF1A1523);      // background-dark
  static const Color darkSurface = Color(0xFF2C253A);         // surface-dark
  static const Color darkTextHeadings = Color(0xFFFFFFFF);    // text-headings
  static const Color darkTextBody = Color(0xFFD9D4E4);        // text-body
  static const Color darkSecondaryAccent = Color(0xFFA39CB9); // secondary-accent

  // Light theme tokens 
  static const Color lightBackground = Color(0xFFF8F7F5);     // background-light
  static const Color lightSurface = Color(0xFFFFFFFF);        // white cards / navbar
  static const Color lightTextHeadings = Color(0xFF4c3b70);   // text-headings
  static const Color lightTextBody = Color(0xFF6B5B8E);       // text-body
  static const Color lightSecondaryAccent = Color(0xFF8B5CF6);// secondary-accent
  
  // Extra helpers for specific elements
  static const Color lightNavbarGlass = Color(0x99FFFFFF);    // white/60%
  static const Color lightNavbarBorder = Color(0x4DFFFFFF);   // white/30%
}

