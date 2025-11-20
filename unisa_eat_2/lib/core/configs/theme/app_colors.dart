import 'package:flutter/material.dart';

class AppColors {
  // Blu Royale - Colore primario
  static const Color primaryBlue = Color(0xFF0504AA);
  static const Color primaryBlueDark = Color(0xFF030375);
  static const Color primaryBlueLight = Color(0xFF3A3CCF);

  // Teal - Colore secondario
  static const Color secondaryTeal = Color(0xFF20B2AA);
  static const Color secondaryTealDark = Color(0xFF0D7A73);
  static const Color secondaryTealLight = Color(0xFF4ECDC1);

  // Oro/Amber - Colore terziario per accenti
  static const Color tertiaryGold = Color(0xFFFFB800);
  static const Color tertiaryGoldDark = Color(0xFFF7A600);
  static const Color tertiaryGoldLight = Color(0xFFFFD54F);

  // Colori funzionali
  static const Color successGreen = Color(0xFF43A047);
  static const Color errorRed = Color(0xFFE53935);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF1976D2);

  // Colori neutri - Light Mode
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF6D6D6D);
  static const Color borderLight = Color(0xFFE0E0E0);

  // Colori neutri - Dark Mode
  static const Color backgroundDark = Color.fromARGB(255, 32, 32, 32);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color borderDark = Color(0xFF333333);

  // Button text colors
  static const Color buttonTextDark = Color(0xFFFFFFFF); // White for dark backgrounds
  static const Color buttonTextLight = Color(0xFF0504AA); // Primary blue for light backgrounds
}
