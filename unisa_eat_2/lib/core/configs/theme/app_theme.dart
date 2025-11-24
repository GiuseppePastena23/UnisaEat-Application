import 'package:flutter/material.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.light(
        error: AppColors.errorRed,
        primary: AppColors.primaryBlue,
        secondary: AppColors.secondaryTeal,
        surface: AppColors.surfaceLight,
        onPrimary: AppColors.buttonTextLight,    // Use high contrast for button text
        onSecondary: AppColors.textPrimaryLight,
        onSurface: AppColors.textPrimaryLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.buttonTextLight, // Use button text color for AppBar for contrast
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.tertiaryGold,
        foregroundColor: AppColors.buttonTextLight,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: AppColors.textPrimaryLight),
        bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
        bodyMedium: TextStyle(color: AppColors.textSecondaryLight),
        labelLarge: TextStyle(color: AppColors.buttonTextLight), // For button text, etc.
      ),
      dividerColor: AppColors.borderLight,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryBlueDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.dark(
        error: AppColors.errorRed,
        primary: AppColors.primaryBlueDark,
        secondary: AppColors.secondaryTealDark,
        surface: AppColors.surfaceDark,
        onPrimary: AppColors.buttonTextDark,    // Use high contrast for button text in dark mode
        onSecondary: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlueDark,
        foregroundColor: AppColors.buttonTextDark, // Use button text color for AppBar for contrast
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.tertiaryGoldDark,
        foregroundColor: AppColors.buttonTextDark,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: AppColors.textPrimaryDark),
        bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
        bodyMedium: TextStyle(color: AppColors.textSecondaryDark),
        labelLarge: TextStyle(color: AppColors.buttonTextDark), // For button text, etc.
      ),
      dividerColor: AppColors.borderDark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlueDark,
          foregroundColor: AppColors.buttonTextDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // create border visibile 
        border: OutlineInputBorder(
          borderSide: BorderSide(
            
          ),
        ),
      ),
    );
  }
}